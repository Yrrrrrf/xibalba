# Xibalbá — Database Architecture Overview

> SurrealDB v3 · Namespace `app` · Database `main`
> Tourism visibility platform for micro-businesses · FIFA World Cup 2026

---

## 1. What kind of database is this?

Xibalbá runs on **SurrealDB v3**, a multi-model database that collapses what
would normally be 3–4 separate systems into one:

- **Document store** — each business, user, or city is a SCHEMAFULL JSON
  document with typed fields, ASSERTs, and DEFAULT values.
- **Graph database** — tourists and businesses are connected by typed relation
  edges (`review`, `manages`, `visits`, `favorites`) that support full graph
  traversal with `->` and `<-` arrow syntax.
- **Full-text search engine** — a BM25 analyzer with ASCII normalization enables
  diacritics-free search (`"artesania"` matches `"Artesanías"`).
- **Geospatial engine** — `geometry<point>` fields with `geo::distance()` enable
  radius-based business discovery.

The DB runs in Docker on port 8000. In development it uses in-memory storage;
for persistence, switch to `file://data`. The Rust engine connects via
WebSocket (`ws://localhost:8000`), and the SvelteKit client can connect directly
via the `surrealdb` npm package.

---

## 2. Schema pipeline

Initialization runs in strict order. Each stage depends on the previous:

```
01-schema/      tables → fields
02-indexes/     unique + FTS + analytics
03-functions/   read-only SurrealQL functions
04-events/      mutation side-effects (audit log, rating recalculation)
05-seed/        locale strings → categories → cities → users → businesses
                → media → graph edges → reviews → visits/favorites → activity
```

All `.surql` files are executed by `scripts/init-db.sh` via HTTP POST to
`/sql`. The entrypoint script starts SurrealDB, waits for readiness, then
runs initialization.

---

## 3. Tables — vertex types (documents)

### 3.1 `user` — the actor

Every person in the system. Three roles determine access patterns:

| Role | Can do | Seed examples |
|------|--------|---------------|
| `tourist` | Search, visit, review, favorite businesses | akiko (JP), james (US), camille (FR), rafael (BR) |
| `owner` | Manage their businesses, see reviews/metrics | carlos, lucia, roberto (all MX) |
| `admin` | Set `is_ola_mexico`, see `internal_notes` | admin |

**Key fields:** `email` (ASSERT `string::is_email`), `role` (ASSERT IN
`['tourist','owner','admin']`), `locale` (default `'en'`), `country_code`
(ISO 2-letter, optional), `password_hash` (stub values in seed).

**Indexes:** UNIQUE on `email`, UNIQUE on `username`.

### 3.2 `business` — the core domain entity

A local tourism business: taquería, hostel, mezcalería, craft shop, tour
company, cantina. Every business has:

**Identity:** `name`, `slug` (UNIQUE), `description`, `category` (record link
→ `category`), `city` (record link → `city`).

**Location:** `coordinates` (`geometry<point>`, GeoJSON `[lon, lat]`),
`address`, `neighborhood`.

**Commerce:** `price_range` (ASSERT IN `['$','$$','$$$']`),
`languages_spoken` (array of ISO codes, 13 supported locales validated by
ASSERT), `phone`, `website`, `opening_hours`.

**State flags:**
- `is_active` — business is operational (default `true`)
- `is_verified` — appears on the tourist map (default `false`)
- `is_ola_mexico` — Ola México certified badge (admin-only update via
  `PERMISSIONS FOR update WHERE $auth.role = 'admin'`)

**Computed stats (event-driven):**
- `rating` — `option<float>`, recalculated by `on_review_created` event as
  `math::mean(rating) FROM review WHERE out = $this`
- `review_count` — `int`, recalculated alongside rating

These were originally `VALUE` subqueries (computed on read) but were changed
to event-driven explicit UPDATEs because SurrealDB v3 evaluates VALUE fields
at write-time on the business record, not reactively when reviews change.
This caused non-deterministic `null` results.

**Reference integrity:**
- `category` → `REFERENCE ON DELETE REJECT` (can't delete a category in use)
- `city` → `REFERENCE ON DELETE REJECT` (can't delete a city in use)

**Indexes:** UNIQUE on `slug`. FULLTEXT BM25 on `name` and `description`.

### 3.3 `session` — auth tokens

Links a user to a Bearer token. `REFERENCE ON DELETE CASCADE` — deleting a
user auto-deletes their sessions.

### 3.4 `category` — tourism taxonomy

Hierarchical categories with optional `parent` (self-referencing
`record<category>`). A computed `path` field builds the breadcrumb:
`IF parent != NONE THEN parent.path + ' > ' + name ELSE name END`.

Seed categories: `gastronomy`, `lodging`, `crafts`, `entertainment`,
`tourist_services`, `bar_cantina`.

### 3.5 `city` — geo anchors

Mexican venue cities (CDMX, Guadalajara, Monterrey) plus tourist origin
cities (New York, Toronto). Each has `coordinates` (geometry point) and
`is_venue_city` (bool) to distinguish host cities from origin context.

### 3.6 `locale_string` — i18n key-value store

Flat table: `(key, locale, value)` with a composite UNIQUE index on
`(key, locale)`. Covers category names, city names, price labels, UI strings,
and the "Ola México" badge text across 7 locales (es, en, fr, ja, de, pt, zh).

Resolved at runtime by `fn::t(key, locale)` with English fallback.

### 3.7 `media` — business photos

External asset URLs (Cloudinary-style) with bilingual captions (`caption_es`,
`caption_en`) and `sort_order`. `REFERENCE ON DELETE CASCADE` — deleting a
business removes its photos.

### 3.8 `activity` — event-driven audit log

Written exclusively by DB events, never by application code. Records:
`type` (string like `'review.received'`, `'review.first'`,
`'business.verified'`, `'visit.first'`), `target_owner`, `target_business`,
`meta` (freeform object), `occurred_at`.

---

## 4. Tables — edge types (graph relations)

All four relation tables are defined with `TYPE RELATION IN user OUT business`.
This means SurrealDB enforces that `in` is always a `user` record and `out`
is always a `business` record. Edges are created with `RELATE`, not `CREATE`.

### 4.1 `review` — tourist rates a business

```
user:tourist_james -> review -> business:tacos_el_memo
  SET rating=5, body='Best tacos in CDMX', locale='en'
```

**Fields:** `rating` (int, ASSERT 1–5), `body` (optional text), `locale`
(string, default `'en'`), `created_at`.

**Constraint:** Composite UNIQUE index on `(in, out)` — one review per tourist
per business.

**Side effects (via `on_review_created` event):**
1. Recalculates `business.rating` and `business.review_count`
2. Creates `activity` record of type `'review.received'`
3. If this is the first review for the business, also creates
   `'review.first'` activity

### 4.2 `manages` — owner operates a business

```
user:owner_carlos -> manages -> business:tacos_el_memo
```

**Fields:** `since` (datetime, default `time::now()`).

No special constraints beyond the relation type. An owner can manage multiple
businesses; a business can have multiple owners (though seed data uses 1:1).

### 4.3 `visits` — tourist discovers a business

```
user:tourist_akiko -> visits -> business:artesanias_xochimilco
  SET source='qr', visited_at=time::now()-2d
```

**Fields:** `source` (ASSERT IN `['map','search','qr','link','recommendation']`),
`visited_at` (datetime).

**Side effects (via `on_visit_recorded` event):** First visit creates a
`'visit.first'` activity for the business owner. Repeat visits are tracked
silently.

This is the table that powers the recommendation engine — the graph traversal
follows visit edges to find similar tourists.

### 4.4 `favorites` — tourist bookmarks a business

```
user:tourist_james -> favorites -> business:tacos_el_memo
  SET added_at=time::now()-2d
```

**Fields:** `added_at` (datetime).

Lightest edge — no events, no constraints beyond the relation type.

---

## 5. Graph traversal patterns

SurrealDB's arrow syntax enables traversals without JOINs:

| Query | SurrealQL | What it does |
|-------|-----------|--------------|
| Owner's businesses | `SELECT ->manages->business.name FROM user:owner_carlos` | Forward traversal through `manages` |
| Business's owner | `SELECT <-manages<-user.username FROM business:tacos_el_memo` | Reverse traversal |
| Tourist's visited places | `SELECT ->visits->business.name FROM user:tourist_akiko` | Forward through `visits` |
| Tourist's favorites | `SELECT ->favorites->business.name FROM user:tourist_james` | Forward through `favorites` |
| Collaborative filtering | `fn::tourist_recommendations(user_id, limit)` | Multi-hop: tourist → visits → business ← visits ← similar_tourists → visits → unseen businesses |

The recommendation engine is the most complex traversal — a 3-hop
collaborative filter implemented as a pure SurrealQL function with zero
application logic.

---

## 6. Indexes

### Unique indexes (data integrity)

| Index | Table | Fields | Purpose |
|-------|-------|--------|---------|
| `user_email` | user | email | One account per email |
| `user_username` | user | username | Unique usernames |
| `session_token` | session | token | Token lookup O(1) |
| `business_slug` | business | slug | URL-safe unique identifiers |
| `city_slug` | city | slug | URL-safe city identifiers |
| `category_slug` | category | slug | URL-safe category identifiers |
| `locale_idx` | locale_string | key, locale | One translation per key+locale |
| `review_per_tourist_per_business` | review | in, out | One review per tourist per business |

### Full-text search

A custom analyzer `ascii_bm25` chains tokenizers (`blank`, `class`, `camel`,
`punct`) with filters (`ascii`, `lowercase`, `snowball(spanish)`,
`snowball(english)`). The `ascii` filter strips diacritics so searching
`"artesanias"` matches `"Artesanías"` — critical for tourists who can't type
accented characters.

Applied to `business.name` and `business.description` via BM25 FULLTEXT
indexes. Queried with the `@@` operator.

### Analytics indexes

- `visits_by_business` on `visits.out` — speeds up `fn::popular_in_city`
- `favorites_by_business` on `favorites.out` — same
- `activity_by_time` on `activity.occurred_at` — dashboard queries

---

## 7. Functions

All functions are read-only. Mutations belong to events or direct queries.

### `fn::t(key, locale)` — i18n lookup

Resolves a locale string key to a value with English fallback. Used everywhere
a display string needs locale-aware resolution.

### `fn::businesses_near(point, radius_km)` — geo search

Primary data source for the Explorer map. Filters `is_active = true` AND
`is_verified = true`, computes `geo::distance()`, returns results ordered by
proximity with an augmented `distance_km` field.

### `fn::search_businesses(query, locale, city_id?, category_id?)` — FTS

BM25 full-text search on name and description with optional city and category
filters. Results ordered by `review_count DESC` as a relevance proxy.

### `fn::tourist_recommendations(user_id, limit)` — collaborative filtering

The hackathon's strongest demo feature. Pure graph traversal:

1. Find businesses this tourist visited
2. Find other tourists who visited those same places
3. Find what those similar tourists visited (excluding already-known)
4. Rank by overlap count, return top N business IDs

### `fn::popular_in_city(city_id, limit)` — trending

Score = `review_count × rating`. Feeds the "trending" UI section.

### `fn::city_snapshot(city_id)` — telemetry

Point-in-time metrics for a city: active businesses, total reviews,
visits this week, top category. Powers the Vision dashboard.

---

## 8. Events

Events fire on DML operations and handle side effects. The activity table is
the observable event log.

### `on_review_created` (ON review WHEN CREATE)

1. Recalculates business `rating` (`math::mean`) and `review_count` via
   explicit `UPDATE` on the target business
2. Creates `'review.received'` activity for the business owner
3. If `review_count = 1`, creates `'review.first'` milestone activity

### `on_business_verified` (ON business WHEN UPDATE)

Fires when `is_verified` transitions from `false` → `true`. Creates
`'business.verified'` activity for the owner. This marks the moment a
business first appears on the tourist map.

### `on_visit_recorded` (ON visits WHEN CREATE)

If this is the tourist's first visit to this business, creates
`'visit.first'` activity. Repeat visits are tracked with no event.

---

## 9. Seed data summary

| Table | Records | Notes |
|-------|---------|-------|
| locale_string | ~70 | 6 categories × 7 locales + cities + UI labels |
| category | 6 | gastronomy, lodging, crafts, entertainment, tourist_services, bar_cantina |
| city | 5 | 3 venue (CDMX, GDL, MTY) + 2 origin (NYC, Toronto) |
| user | 8 | 1 admin + 3 owners + 4 tourists |
| business | 7 | All in CDMX, all verified + Ola México |
| media | ~17 | 2–3 photos per business |
| manages | 7 | Carlos→3, Lucia→2, Roberto→2 |
| review | 7 | Cross-locale reviews (ja, en, fr, pt) |
| visits | 6 | Behavioral data for recommendations |
| favorites | 4 | Bookmark data |
| activity | 4 | Historical milestones |

### Business catalog (seed)

| ID | Name | Category | Neighborhood | Price |
|----|------|----------|-------------|-------|
| `tacos_el_memo` | Taquería El Memo (Tacos) | gastronomy | Centro Histórico | $ |
| `hostal_mundo_libre` | Hostal Mundo Libre | lodging | Roma Norte | $$ |
| `artesanias_xochimilco` | Artesanías Xochimilco | crafts | Coyoacán | $$ |
| `mezcaleria_la_condesa` | Mezcalería La Condesa | bar_cantina | Condesa | $$$ |
| `tours_cdmx` | Tours CDMX | tourist_services | Zócalo | $$ |
| `cafe_de_olla` | Café de Olla | gastronomy | Coyoacán | $ |
| `cantina_la_perla` | Cantina La Perla | bar_cantina | Centro Histórico | $$ |

---

## 10. Test suite

27 tests across 4 groups, executed via `sh db/test/run-all.sh`:

| Group | Tests | What it validates |
|-------|-------|-------------------|
| A (Schema) | 5 | ASSERT validations: email format, role enum, rating range, price_range, locale whitelist |
| B (Unique) | 2 | UNIQUE index enforcement: duplicate email, duplicate slug |
| C (Computed) | 4 | Event-driven rating/review_count, category path hierarchy |
| D (Events) | 3 | `on_review_created` → activity records, `on_business_verified` → activity |
| E (Graph) | 5 | Forward/reverse traversals, recommendation engine |
| F (FTS) | 2 | BM25 name search, ASCII normalization |
| G (Referential) | 1 | ON DELETE REJECT (can't delete referenced city) |
| H (Seed) | 3 | Record counts (users=8, businesses=8, reviews=9) |
| I (Geo) | 2 | `fn::businesses_near` within radius + empty for far location |

---

## 11. Key design decisions

**Named record IDs everywhere.** All seed records use human-readable IDs
(`business:tacos_el_memo`, `user:tourist_akiko`) instead of auto-generated
UUIDs. This makes the graph traversals, test assertions, and seed scripts
dramatically more readable.

**SCHEMAFULL on every table.** No schemaless tables. Every field is typed and
constrained. The DB enforces domain invariants that would otherwise need
application-level validation — invalid emails, out-of-range ratings, and
unsupported locales are all rejected at the DB boundary.

**Graph edges for behavioral data.** Reviews, visits, and favorites are
`TYPE RELATION` edges, not document tables with foreign keys. This enables
native graph traversal for the recommendation engine without JOINs.

**Events for derived data.** Rating and review_count are denormalized onto the
business record via DB events (not application code). This ensures consistency
regardless of which client writes data — the Rust API, the SvelteKit client
via the npm SDK, or direct SurrealQL queries.

**i18n at the DB level.** Locale strings live in the database, not in JSON
files on the client. The `fn::t()` function resolves keys with English
fallback. This means a single API call can return localized content without
the client needing to bundle all translations.

**Reference integrity via DB constraints.** `ON DELETE REJECT` prevents
orphaning businesses when a city or category is deleted. `ON DELETE CASCADE`
auto-cleans sessions and media when their parent is deleted. These are DB-level
guarantees, not application trust.