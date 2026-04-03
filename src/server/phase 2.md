# Xibalbá — Phase 2 Implementation Plan

> **Goal:** Replace every stub route with a real handler that calls the store
> repos, add JWT auth, and build a Rust integration test suite that mirrors
> the 27 shell DB tests — proving the engine can do everything the raw
> SurrealQL tests already validate.

---

## 0. Executive Summary

Phase 1 established the foundation: tourism domain entities that deserialize
from SurrealDB, store repos that execute real SurrealQL, and an AppState
wired with trait objects. But the API routes still return hardcoded JSON.

Phase 2 closes that gap. Every route handler gets wired to its repo. Auth
gets a real JWT flow. And critically, a `cargo test -p store` suite exercises
every DB feature — schema validation, computed fields, events, graph
traversals, FTS, and geo search — through the Rust crate, not curl. When
this phase is done, `just server test` runs both the shell suite AND the
Rust suite, and you never touch the DB layer again.

---

## 1. Current State (Phase 1 deliverables)

What's already working:

| Component | Status | Notes |
|-----------|--------|-------|
| Domain entities | Done | User, Business, Review, City, Category with correct serde |
| Domain ports | Done | AuthRepository, BusinessRepository, ReviewRepository traits |
| Store repos | Done | Real SurrealQL queries, Value→JSON→domain deserialization |
| SurrealClient | Done | `Arc<Surreal<Any>>` wrapper |
| AppState | Done | `Arc<dyn Trait>` for all three repos |
| Route skeletons | Stub | All return hardcoded `json!({})` or `json!([])` |
| Auth middleware | Partial | Checks Bearer token against session table, but login doesn't create sessions |
| Config | Partial | Reads `SURREAL_DB_URL`, `PORT`, `JWT_SECRET` but not `SURREAL_USER`/`SURREAL_PASS` |
| Store tests | Minimal | One test: `test_list_active_businesses` |

What needs to happen in Phase 2:

1. **Config** — read all env vars from `src/server/.env`
2. **Auth routes** — real login flow with JWT
3. **Business routes** — wire to `BusinessRepository` methods
4. **Review routes** — wire to `ReviewRepository` methods
5. **Recommendation route** — wire to `BusinessRepository::get_recommendations`
6. **Rust test suite** — 27+ tests mirroring the shell suite

---

## 2. Config Update

`infra/config.rs` must read these variables to match the `.env` file:

```
SURREAL_DB_URL  → "ws://localhost:8000"   (existing, keep)
SURREAL_USER    → "root"                  (NEW — used in setup.rs signin)
SURREAL_PASS    → "super_secret_dev_pass_override_me" (NEW)
SURREAL_NS      → "app"                  (NEW)
SURREAL_DB      → "main"                 (NEW)
PORT            → 3000                    (existing, keep)
JWT_SECRET      → "default_secret"        (existing, keep)
```

**Implementation contract:**

- Add `db_user`, `db_pass`, `db_ns`, `db_db` fields to `AppConfig`.
- Update `setup.rs` to use `config.db_user` and `config.db_pass` in the
  `Root` signin instead of hardcoded `"root"`.
- Update `db.use_ns(...).use_db(...)` to use config values.
- For the test suite, provide a `test_config()` helper that reads from env
  or falls back to the `.env` defaults.

---

## 3. Auth Flow

### 3.1 Login route: `POST /auth/login`

**Request body:**
```json
{ "email": "akiko@demo.xibalba.mx", "password": "demo_hash_akiko" }
```

**Handler logic:**
1. Extract `LoginRequest { email, password }` from JSON body.
2. Call `auth_repo.find_user_by_email(&email)`.
3. If no user → return 401.
4. Compare `password` with `user.password_hash`. For the hackathon, this is a
   plain string match (`password == user.password_hash`). Mark with a
   `// HACKATHON: replace with Argon2 verify` comment.
5. Generate a JWT using `jsonwebtoken::encode` with the user's `id`, `role`,
   and `email` as claims. Set expiry to 24h.
6. Create a `Session` record in the DB via `auth_repo.create_session(...)`.
7. Return `{ "token": "<jwt>", "user": { id, username, email, role, ... } }`.

**JWT claims struct (define in `application/use_cases/auth.rs`):**
```
struct Claims {
    sub: String,       // user id ("user:tourist_akiko")
    email: String,
    role: String,      // "tourist", "owner", "admin"
    exp: usize,        // expiry timestamp
}
```

### 3.2 Auth middleware update

The current middleware checks `find_session_by_token`. Update it to:

1. Extract Bearer token from header.
2. Decode JWT using `jsonwebtoken::decode` with the `JWT_SECRET`.
3. If decode fails → 401.
4. Optionally verify the session still exists in DB (defense in depth).
5. Insert the decoded `Claims` (or the `User`) into request extensions so
   route handlers can access the authenticated user.

**Injecting user into extensions:**
```
req.extensions_mut().insert(claims);
```

Route handlers then extract via:
```
let claims = req.extensions().get::<Claims>().unwrap();
```

Or use a custom Axum extractor `AuthUser(claims)`.

### 3.3 Config: JWT_SECRET

Read from `AppConfig`. Pass it into `AppState` so both the login route and
the middleware can access it for encode/decode.

---

## 4. Business Routes

### 4.1 `GET /businesses/near?lat=19.4326&lon=-99.1332&radius_km=10`

**Handler:**
1. Extract query params: `lat: f64`, `lon: f64`, `radius_km: f64`.
2. Construct `Point::new(lon, lat)`.
3. Call `business_repo.find_near(point, radius_km)`.
4. Return `Json(businesses)`.

**Query params struct:**
```
#[derive(Deserialize)]
struct NearQuery {
    lat: f64,
    lon: f64,
    radius_km: f64,
}
```

Extract with `Query<NearQuery>`.

### 4.2 `GET /businesses/search?q=Tacos&locale=en&city=city:cdmx`

**Handler:**
1. Extract query params: `q`, `locale`, `city` (optional), `category` (optional).
2. Call `business_repo.search(&q, &locale, city.as_deref(), category.as_deref())`.
3. Return `Json(businesses)`.

### 4.3 `GET /businesses/:id`

**Handler:**
1. Extract `id` from path via `Path<String>`.
2. The `id` param will be something like `tacos_el_memo`. Prepend `business:`
   to form the full record ID, or accept the full ID.
3. Call `business_repo.find_by_id(&full_id)`.
4. If `None` → return 404.
5. Return `Json(business)`.

**Important:** Axum's `/:id` syntax in your Phase 1 code should be `/{id}`
(Axum 0.8 uses `{id}` not `:id`). Verify this compiles — your Phase 1 route
file uses `/:id` which was valid in Axum 0.7 but changed in 0.8.

---

## 5. Review Routes

### 5.1 `POST /reviews` (auth-gated)

**Request body:**
```json
{
    "business_id": "business:tacos_el_memo",
    "rating": 5,
    "body": "Amazing tacos!",
    "locale": "en"
}
```

**Handler:**
1. Extract authenticated user from extensions (from middleware).
2. Extract `CreateReviewRequest` from JSON body.
3. Validate: `rating >= 1 && rating <= 5`.
4. Construct a `Review` with `user: claims.sub`, `business: business_id`, etc.
5. Call `review_repo.create(review)`.
6. Return 201 with `{ "status": "created" }`.

**Note:** The `RELATE` in the store repo already handles the graph edge
creation and fires the `on_review_created` event which updates
`business.rating` and `business.review_count`.

### 5.2 `GET /reviews/:business_id` (public)

**Handler:**
1. Extract `business_id` from path.
2. Call `review_repo.find_by_business(&business_id)`.
3. Return `Json(reviews)`.

---

## 6. Recommendation Route

### 6.1 `GET /recommendations` (auth-gated)

**Handler:**
1. Extract authenticated user from extensions.
2. Call `business_repo.get_recommendations(&claims.sub, 5)`.
3. Return `Json(recommendations)`.

**Optional query param:** `limit` (default 5).

---

## 7. Rust Integration Test Suite

This is the critical deliverable. The test suite lives in
`core/store/src/tests.rs` and mirrors the 27 shell tests group by group.

### 7.1 Test infrastructure

**Shared test helper** — a function that creates a `SurrealClient` connected
to the live DB:

```rust
async fn test_client() -> SurrealClient {
    let db = connect("ws://localhost:8000").await.unwrap();
    db.signin(Root {
        username: std::env::var("SURREAL_USER").unwrap_or("root".into()),
        password: std::env::var("SURREAL_PASS")
            .unwrap_or("super_secret_dev_pass_override_me".into()),
    }).await.unwrap();
    db.use_ns("app").use_db("main").await.unwrap();
    SurrealClient::new(Arc::new(db))
}
```

**Important:** These are integration tests that require the Docker SurrealDB
to be running with seeded data. They are NOT unit tests. They run against the
same DB instance as the shell tests.

**Test ordering:** Some tests are read-only (safe to run in any order), others
mutate data (create reviews, verify businesses). The mutating tests should be
aware that the shell test suite may have already run, so they should query for
existing state rather than assuming a pristine DB.

### 7.2 Test map — mirroring the 27 shell tests

Below is the complete test specification. Each test describes: what it
validates, the SurrealQL it executes (through the repo or raw query), and
the assertion.

---

#### GROUP A — Schema Integrity (read the DB's ASSERT enforcement via Rust)

These tests prove the Rust client gets proper errors when schema constraints
are violated. They use raw `.query()` since the repos don't expose "create
invalid data" methods.

**A1 · Invalid email rejected**
- Query: `CREATE user SET email='not-an-email', username='rust_bad', password_hash='x', role='tourist', locale='en'`
- Assert: response contains error (the query should fail)

**A2 · Invalid role rejected**
- Query: `CREATE user SET email='rust@x.com', username='rust_badrole', password_hash='x', role='hacker', locale='en'`
- Assert: response contains error

**A3 · Negative rating rejected**
- Query: `RELATE user:tourist_akiko->review->business:hostal_mundo_libre SET rating=-1, locale='ja'`
- Assert: response contains error

**A4 · Invalid price_range rejected**
- Query: `CREATE business SET name='Rust Bad Price', slug='rust-bad-price', category=category:gastronomy, city=city:cdmx, coordinates={type:'Point',coordinates:[0,0]}, price_range='$$$$', languages_spoken=['es']`
- Assert: response contains error

**A5 · Unsupported locale rejected**
- Query: `CREATE business SET name='Rust Bad Locale', slug='rust-bad-locale', category=category:gastronomy, city=city:cdmx, coordinates={type:'Point',coordinates:[0,0]}, price_range='$', languages_spoken=['xx']`
- Assert: response contains error

---

#### GROUP B — Unique Indexes

**B1 · Duplicate email rejected**
- Query: `CREATE user SET email='admin@xibalba.mx', username='rust_dupe', password_hash='x', role='admin', locale='es'`
- Assert: response contains error (email already exists)

**B2 · Duplicate slug rejected**
- Query: `CREATE business SET name='Rust Dupe', slug='tacos-el-memo', category=category:gastronomy, city=city:cdmx, coordinates={type:'Point',coordinates:[0,0]}, price_range='$', languages_spoken=['es']`
- Assert: response contains error

---

#### GROUP C — Computed Fields (via repos)

**C1 · Business rating computed correctly**
- Use `BusinessRepository::find_by_id("business:mezcaleria_la_condesa")`
- Assert: `business.rating` is approximately 4.5 (two reviews: 4 + 5)
- Note: The shell test suite and/or seed data may have added more reviews.
  Query the actual review ratings and compute expected average dynamically.

**C2 · Review count correct**
- Use `BusinessRepository::find_by_id("business:tacos_el_memo")`
- Assert: `business.review_count >= 1`

**C3 · Category path hierarchy**
- Raw query: `SELECT path FROM category:tacos`
- Assert: path contains "Gastronomía > Tacos" (created by shell test C3)
- Note: If shell tests haven't run, create the child category first.

**C4 · Rating re-computed after review**
- This is a mutation test. It should:
  1. Read current rating of a business.
  2. Create a review via `ReviewRepository::create(...)`.
  3. Read rating again.
  4. Assert it changed to the correct average.
- Use a business that hasn't been review-bombed by other tests.

---

#### GROUP D — Events

**D1 · on_review_created produces activity**
- After the review in C4, query: `SELECT type FROM activity WHERE target_business = $biz AND type = 'review.received'`
- Assert: at least one result exists

**D2 · First-review milestone**
- Query: `SELECT type FROM activity WHERE type = 'review.first'`
- Assert: at least one result (from seed or C4)

**D3 · on_business_verified produces activity**
- Query: `SELECT type FROM activity WHERE type = 'business.verified'`
- Assert: at least one result (from seed event tests)

---

#### GROUP E — Graph Traversals

**E1 · Forward traversal: owner → manages → business**
- Query: `SELECT ->manages->business.name FROM user:owner_carlos`
- Assert: result contains "Taquería El Memo"

**E2 · Reverse traversal: business ← manages ← user**
- Query: `SELECT <-manages<-user.username FROM business:tacos_el_memo`
- Assert: result contains "owner_carlos"

**E3 · Visits relation**
- Query: `SELECT ->visits->business.name FROM user:tourist_akiko`
- Assert: result contains "Artesanías Xochimilco"

**E4 · Favorites relation**
- Query: `SELECT ->favorites->business.name FROM user:tourist_james`
- Assert: result contains "Taquería El Memo"

**E5 · Recommendation engine**
- Use `BusinessRepository::get_recommendations("user:tourist_akiko", 5)`
- Assert: result is non-empty (or contains specific business IDs)

---

#### GROUP F — Full-Text Search

**F1 · FTS on name: "Tacos"**
- Use `BusinessRepository::search("Tacos", "en", None, None)`
- Assert: result contains a business with "Taquería El Memo" in the name

**F2 · FTS with ASCII normalization**
- Use `BusinessRepository::search("artesanias", "en", None, None)`
- Assert: result contains "Artesanías Xochimilco"

---

#### GROUP G — Reference Integrity

**G1 · Cannot delete referenced city**
- Raw query: `DELETE city:cdmx`
- Assert: response contains error (ON DELETE REJECT)

---

#### GROUP H — Seed Verification

**H1 · User count**
- Raw query: `SELECT count() FROM user GROUP ALL`
- Assert: count >= 8 (seed) — use >= because tests may have added users

**H2 · Business count**
- Raw query: `SELECT count() FROM business GROUP ALL`
- Assert: count >= 7 (seed minimum)

**H3 · Review count**
- Raw query: `SELECT count() FROM review GROUP ALL`
- Assert: count >= 7 (seed minimum)

---

#### GROUP I — Geo Search

**I1 · Businesses near CDMX**
- Use `BusinessRepository::find_near(Point::new(-99.1332, 19.4326), 10.0)`
- Assert: result is non-empty, contains businesses in CDMX

**I2 · No businesses near Tokyo**
- Use `BusinessRepository::find_near(Point::new(139.6503, 35.6762), 10.0)`
- Assert: result is empty

---

### 7.3 Test execution

Tests run with:
```bash
cargo test -p store -- --test-threads=1
```

The `--test-threads=1` is important because some tests mutate shared state
(creating reviews, verifying businesses). Serial execution prevents races.

Add to the justfile:
```just
engine-test:
    cd engine && cargo test -p store -- --test-threads=1 --nocapture
```

Update `server test` recipe:
```just
server-test:
    sh db/test/run-all.sh
    cd engine && cargo test -p store -- --test-threads=1
```

---

## 8. Phased Delivery Within Phase 2

### Step 2a — Config + Auth (3–4 hours)

1. Update `AppConfig` with all env vars.
2. Update `setup.rs` to use config values.
3. Add `Claims` struct and JWT encode/decode.
4. Wire `POST /auth/login` to real flow.
5. Update auth middleware to decode JWT.
6. Add `jwt_secret: String` to `AppState`.

**Exit criteria:** `curl -X POST localhost:3000/auth/login -d '{"email":"akiko@demo.xibalba.mx","password":"demo_hash_akiko"}'` returns a real JWT.

### Step 2b — Business + Review + Recommendation routes (2–3 hours)

1. Wire `GET /businesses/near` with `Query<NearQuery>` extraction.
2. Wire `GET /businesses/search` with query params.
3. Wire `GET /businesses/{id}` with path extraction.
4. Wire `POST /reviews` with auth + body extraction.
5. Wire `GET /reviews/{business_id}` with path extraction.
6. Wire `GET /recommendations` with auth extraction.

**Exit criteria:** All curl commands from Phase 2 exit criteria in the engine
spec work end-to-end.

### Step 2c — Rust test suite (3–4 hours)

1. Create `test_client()` helper.
2. Implement all 27 tests as described in Section 7.
3. Run and fix any deserialization issues.
4. Update justfile.

**Exit criteria:** `cargo test -p store -- --test-threads=1` passes all 27+
tests with a running SurrealDB instance.

---

## 9. Files to Modify

| File | Change |
|------|--------|
| `services/api/src/infra/config.rs` | Add db_user, db_pass, db_ns, db_db, jwt_secret fields |
| `services/api/src/infra/setup.rs` | Use config for Root signin and ns/db selection |
| `services/api/src/adapters/http/app_state.rs` | Add `jwt_secret: String` field |
| `services/api/src/application/use_cases/auth.rs` | Add Claims struct, LoginRequest, LoginResponse |
| `services/api/src/adapters/http/routes/auth.rs` | Real login handler with JWT |
| `services/api/src/adapters/http/routes/businesses.rs` | Wire to BusinessRepository |
| `services/api/src/adapters/http/routes/reviews.rs` | Wire to ReviewRepository |
| `services/api/src/adapters/http/routes/recommendations.rs` | Wire to BusinessRepository |
| `services/api/src/adapters/http/middleware/auth.rs` | JWT decode + extensions injection |
| `core/store/src/tests.rs` | Full 27-test integration suite |
| `core/store/Cargo.toml` | Add `chrono` to dev-dependencies if needed |
| `services/api/Cargo.toml` | Remove `typst` dependency (leftover from old project) |

---

## 10. Risks and Mitigations

**Risk: Axum 0.8 route syntax.**
Your Phase 1 routes use `/:id` (Axum 0.7 syntax). Axum 0.8 uses `/{id}`.
This will cause a compile error or silent route mismatch.
**Mitigation:** Fix all route definitions to use `/{id}` syntax.

**Risk: Test ordering with shared DB state.**
The Rust tests and shell tests share the same DB instance. If both suites
run, the second suite sees mutations from the first (extra reviews, extra
businesses).
**Mitigation:** Use `>=` assertions for counts, not `==`. For rating tests,
compute expected values dynamically from current review data rather than
assuming exact seed state.

**Risk: JWT library API differences.**
`jsonwebtoken` v10 has a different API than v9 (which many tutorials reference).
**Mitigation:** Use `jsonwebtoken::encode(&header, &claims, &EncodingKey::from_secret(secret.as_ref()))` and `decode::<Claims>(&token, &DecodingKey::from_secret(secret.as_ref()), &validation)`. Verify against v10 docs.

**Risk: SurrealDB `Value` deserialization edge cases.**
Some SurrealDB values (geometry points, record IDs) may not round-trip cleanly
through the `Value → JSON → serde` path.
**Mitigation:** The Phase 1 store already handles this for the happy path.
The test suite will surface any edge cases. If a specific field fails to
deserialize, add a custom `#[serde(deserialize_with = "...")]` on the entity.

---

## 11. Post-Phase 2 State

When Phase 2 is complete:

- `just server test` runs 27 shell tests + 27+ Rust tests = **54+ tests** all green

**You never need to touch the DB or engine again for the hackathon demo.**
The client team can integrate against these endpoints immediately.