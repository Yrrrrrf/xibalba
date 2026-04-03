# Xibalbá — Minimal Engine Server · Architectural Spec

> Implementation plan for replacing the inventory-domain engine stubs with a
> working tourism-domain Rust API that talks to the live SurrealDB instance.

---

## 0. Executive Summary

The current engine workspace (`src/server/engine/`) contains the correct
hexagonal skeleton (domain → store → api) but every entity, port, and repo
implementation belongs to a different project (inventory management). Meanwhile,
the SurrealDB instance holds a fully seeded tourism schema — users, businesses,
reviews, cities, categories, graph relations, events, and functions — that has
no Rust API in front of it.

This plan replaces the engine's domain layer with the Xibalbá tourism domain,
wires the store crate against the live SurrealDB v3 container, and exposes the
minimum set of Axum routes needed to prove the full vertical works end-to-end:
auth, business CRUD, review submission, geo search, and graph-powered
recommendations. The WASM crate is left as-is for now — it will be updated once
the domain stabilises.

---

## 1. Context & Constraints

### Project context

- **Status:** Existing monorepo with working SurrealDB (27 tests, 25+ passing),
  three SvelteKit client apps, and a Rust engine workspace that compiles but
  returns stub data for an unrelated domain.
- **Hackathon deadline:** Talent Land México, April 7–9, 2026. The engine must
  be demoable before then.
- **Team:** Solo developer (Fernando) + 4 teammates focused on client, docs, and
  pitch.
- **Stack:** Rust 2024 edition, Axum 0.8, SurrealDB v3 (surrealdb crate 3.0.3),
  Tokio, tracing, argon2, jsonwebtoken.

### Goals — what "done" looks like

1. `cargo run -p api` connects to the live Docker SurrealDB, authenticates, and
   uses namespace `app` / database `main`.
2. A tourist can hit `/auth/login` with email + password and get a JWT back.
3. `/businesses/near` calls `fn::businesses_near` and returns geo results.
4. `/businesses/search` calls `fn::search_businesses` with FTS.
5. `/businesses/{id}/reviews` accepts a `POST` (creates a review via `RELATE`).
6. `/recommendations/{user_id}` calls `fn::tourist_recommendations`.
7. The DB's computed rating fix (event-driven, from our earlier discussion) is
   wired in.
8. `just server test` passes 27/27.
9. The whole stack is deployable via `docker compose up`.

### Out of scope

- WASM crate update (keep compiling, don't touch).
- Typst document generation (remove the adapter, clean the dependency).
- Client-side changes (the SvelteKit apps will be adapted separately).
- Production auth hardening (OAuth, refresh token rotation, rate limiting).
- CI/CD pipeline.

### Assumptions

- **[ASSUMPTION]** SurrealDB runs in Docker on `localhost:8000` with root/root
  credentials during development, and the init-db.sh script has already
  provisioned namespace `app` / database `main`.
- **[ASSUMPTION]** The engine API runs on port `3000` (existing `AppConfig`
  default).
- **[ASSUMPTION]** The JWT secret is read from `JWT_SECRET` env var; a default
  dev value is acceptable.
- **[ASSUMPTION]** The DB password hashes in the seed data are plaintext stubs
  (`demo_hash_*`). The first auth implementation will do a simple string match
  against these, with Argon2 hashing added in Phase 2.

---

## 2. Architecture Overview

The hexagonal architecture is already in place and correct. The refactor
replaces *what's inside each crate* — not the crate boundaries themselves.

```
                    ┌─────────────────────────────────────────┐
                    │             SurrealDB v3                 │
                    │   NS: app  DB: main   Docker :8000      │
                    └──────────────┬──────────────────────────┘
                                   │ SurrealQL (ws://)
                    ┌──────────────▼──────────────────────────┐
                    │         core/store                       │
                    │  SurrealClient + repo implementations   │
                    │  (AuthRepo, BusinessRepo, ReviewRepo)   │
                    └──────────────┬──────────────────────────┘
                                   │ impl domain::ports::*
┌───────────────┐   ┌──────────────▼──────────────────────────┐
│  core/domain  │◄──│         services/api                    │
│  entities     │   │  Axum routes + middleware + AppState    │
│  ports        │   │  :3000                                  │
│  (pure Rust)  │   └──────────────┬──────────────────────────┘
└───────────────┘                  │ JSON REST
                    ┌──────────────▼──────────────────────────┐
                    │   SvelteKit clients / curl / tests       │
                    └─────────────────────────────────────────┘
```

### Core domain vs. supporting

**Core domain:** Business visibility for tourists — business discovery
(geo + FTS), reviews, and recommendations. These are the three features that
make the hackathon demo compelling.

**Supporting domains:** Auth (session management), i18n (locale strings), and
city/category taxonomy. These exist to support the core but are not the
product's differentiator.

---

## 3. Design Patterns & Code Standards

### 3.1 Domain layer — Pure Value Objects + Port Traits

**Pattern:** Ports & Adapters (Hexagonal Architecture).

**Why:** The domain crate must remain infrastructure-free so that both `store`
and a future `wasm` crate can depend on it without pulling in Axum, SurrealDB,
or any async runtime. This protects the team from coupling domain logic to a
specific database or framework. At year 3, you can swap SurrealDB for Postgres
without touching a single domain type. At year 10, the domain crate is still
the contract that every consumer (API, WASM, CLI, test harness) depends on.

**How it's applied:**

- Entities are plain Rust structs deriving `Serialize`, `Deserialize`, `Clone`,
  `Debug`. They map 1:1 to the SurrealDB schema but use Rust-native types
  (`String` for SurrealDB record IDs like `"business:tacos_el_memo"`).
- Port traits are defined with `#[trait_variant::make(Trait: Send)]` so they
  work in both async (API) and sync (WASM) contexts.
- The `DomainError` enum is the only error type the domain exposes. All infra
  errors are mapped into it at the store boundary.

**Standards:**

- No `use surrealdb::*` anywhere in this crate. No `use axum::*`. No
  `use tokio::*`. The only allowed external crates are: serde, serde_json,
  uuid, chrono, trait-variant.
- Entity field names match the SurrealDB column names exactly (snake_case) to
  keep serialization trivial.
- Port trait methods return `Result<T, DomainError>`, never `anyhow::Result`.

### 3.2 Store layer — Repository Implementations

**Pattern:** Repository pattern with a shared `SurrealClient` newtype.

**Why:** Centralises all database access behind the `SurrealClient` wrapper.
Every repo receives a clone of the same `Arc<Surreal<Any>>`. This protects
against connection pool mismanagement and makes testing straightforward — swap
the `SurrealClient` for one pointing at an in-memory instance.

**How it's applied:**

- `SurrealClient` wraps `Arc<Surreal<Any>>` (already exists, stays unchanged).
- Each repo struct (`SurrealAuthRepo`, `SurrealBusinessRepo`,
  `SurrealReviewRepo`) holds a `SurrealClient` and implements the
  corresponding domain port trait.
- SurrealDB queries use the typed `.query()` API with bound parameters, never
  raw string interpolation.
- Record IDs use SurrealDB's `RecordId` type from the crate, converted to/from
  the domain's `String` representation at the repo boundary.

**Standards:**

- Every repo method logs at `debug` level on entry and at `error` on failure.
- No business logic in repos — only data access, serialization, and error
  mapping.
- Functions in SurrealDB (`fn::businesses_near`, `fn::tourist_recommendations`,
  etc.) are called via `.query("RETURN fn::...()")` with bound args.

### 3.3 API layer — Thin Axum Routes + Middleware

**Pattern:** Application Service (Use Case) layer mediating between HTTP and
domain.

**Why:** Routes should be paper-thin — extract request, call a use case or
repo method, return a response. This keeps the Axum-specific code minimal and
testable. At year 5, migrating to a different HTTP framework (or gRPC) means
rewriting only the route handlers, not the business logic.

**How it's applied:**

- `AppState` holds `Arc<dyn PortTrait>` for each repository, not concrete
  types. This enables test doubles.
- Auth middleware extracts `Bearer <jwt>`, verifies it via `jsonwebtoken`,
  and injects the authenticated `User` into request extensions.
- Routes are grouped: `/auth/*`, `/businesses/*`, `/reviews/*`,
  `/recommendations/*`.
- `AppError` variants map cleanly to HTTP status codes via `IntoResponse`.

**Standards:**

- Request/response types are defined as Axum-specific structs in the routes
  module, not in the domain. The domain doesn't know about HTTP.
- All routes return `AppResult<Json<T>>` where `T` is a concrete response
  struct.
- CORS is permissive in dev, locked down in production via env var.

### 3.4 Error handling

**Pattern:** Error type per layer, mapped at boundaries.

```
DomainError  ←  stored in domain crate
     ↑
     │ impl From<surrealdb::Error>
     │
StoreError   ←  SurrealDB errors mapped to DomainError in each repo
     ↑
     │ impl From<DomainError>
     │
AppError     ←  adds HTTP-specific variants (Unauthorized, Validation)
     ↑
     │ impl IntoResponse
     │
HTTP response (status + JSON body)
```

---

## 4. Component Map & Directory Structure

### 4.1 `core/domain` — Pure domain types and port traits

**Responsibility:** Define the tourism domain contract.

**Location:** `src/server/engine/core/domain/src/`

**Interfaces it exposes:** Entity structs, port traits, `DomainError`.

**Dependencies:** serde, serde_json, chrono, uuid, trait-variant.

**Must NOT:** Import surrealdb, axum, tokio, or any infrastructure crate.

### 4.2 `core/store` — SurrealDB adapters

**Responsibility:** Implement domain ports against the live SurrealDB instance.

**Location:** `src/server/engine/core/store/src/`

**Interfaces it exposes:** `SurrealClient`, `SurrealAuthRepo`,
`SurrealBusinessRepo`, `SurrealReviewRepo`.

**Dependencies:** domain, surrealdb, serde, tokio, tracing, thiserror.

**Must NOT:** Import axum or any HTTP crate. Must not contain business logic.

### 4.3 `services/api` — Axum HTTP service

**Responsibility:** Wire repos into an HTTP server, handle auth, expose REST
endpoints.

**Location:** `src/server/engine/services/api/src/`

**Interfaces it exposes:** `create_app() -> Router`, `AppConfig`, `AppState`.

**Dependencies:** domain, store, axum, tower, tower-http, tokio, surrealdb
(for connection setup only), jsonwebtoken, argon2, serde, serde_json, tracing,
tracing-subscriber, thiserror, anyhow, uuid, chrono, secrecy.

**Must NOT:** Contain SQL/SurrealQL queries (those belong in store).

### 4.4 `services/wasm` — Untouched for now

**Responsibility:** Compile domain types to WASM for the client.

**Status:** Compiles with the old inventory types. Will be updated in a later
phase when the domain stabilises.

**Must NOT:** Be modified in this plan. Temporarily remove the `domain` import
paths that reference deleted entities and replace with empty re-exports so the
workspace still compiles.

### Proposed directory tree

```
engine/
├── Cargo.toml                          # workspace: [domain, store, api, wasm]
├── core/
│   ├── domain/
│   │   ├── Cargo.toml
│   │   └── src/
│   │       ├── lib.rs                  # pub mod entities; pub mod ports;
│   │       ├── entities/
│   │       │   ├── mod.rs
│   │       │   ├── user.rs             # User, Role (tourist/owner/admin)
│   │       │   ├── business.rs         # Business, PriceRange
│   │       │   ├── review.rs           # Review (relation: user → business)
│   │       │   ├── city.rs             # City
│   │       │   └── category.rs         # Category (with parent hierarchy)
│   │       └── ports/
│   │           ├── mod.rs              # DomainError, Result<T>
│   │           ├── auth.rs             # AuthRepository trait
│   │           ├── business.rs         # BusinessRepository trait
│   │           └── review.rs           # ReviewRepository trait
│   └── store/
│       ├── Cargo.toml
│       └── src/
│           ├── lib.rs
│           ├── client.rs               # SurrealClient (unchanged)
│           └── repos/
│               ├── mod.rs
│               ├── auth.rs             # SurrealAuthRepo (real impl)
│               ├── business.rs         # SurrealBusinessRepo
│               └── review.rs           # SurrealReviewRepo
└── services/
    ├── api/
    │   ├── Cargo.toml
    │   └── src/
    │       ├── lib.rs
    │       ├── main.rs                 # tokio::main entry point
    │       ├── application/
    │       │   ├── mod.rs              # AppError, AppResult
    │       │   └── app_error.rs
    │       ├── adapters/
    │       │   ├── mod.rs
    │       │   └── http/
    │       │       ├── mod.rs
    │       │       ├── app_state.rs    # Arc<dyn repos>
    │       │       ├── app_error_impl.rs
    │       │       ├── middleware/
    │       │       │   ├── mod.rs
    │       │       │   ├── auth.rs     # JWT verification
    │       │       │   └── logger.rs
    │       │       └── routes/
    │       │           ├── mod.rs
    │       │           ├── auth.rs     # POST /login
    │       │           ├── businesses.rs # GET /near, /search, /{id}
    │       │           ├── reviews.rs  # POST /{biz_id}/reviews
    │       │           └── recommendations.rs  # GET /{user_id}
    │       └── infra/
    │           ├── mod.rs
    │           ├── config.rs           # AppConfig from env
    │           ├── setup.rs            # init_tracing, init_app_state
    │           └── app.rs              # create_app -> Router
    └── wasm/                           # UNTOUCHED — compiles, stubs only
        ├── Cargo.toml
        └── src/
            └── lib.rs
```

### What gets deleted

- `entities/inventory.rs`, `entities/document.rs` — replaced by tourism
  entities.
- `ports/inventory.rs`, `ports/documents.rs` — replaced by `business.rs`,
  `review.rs`.
- `repos/inventory.rs` — replaced by `business.rs`, `review.rs`.
- `adapters/crypto/` — kept but simplified (Argon2 used in Phase 2).
- `adapters/documents/` — deleted entirely (Typst compiler, templates).
- `routes/inventory.rs`, `routes/documents.rs` — replaced by tourism routes.

---

## 5. Trade-off Analysis

### DECISION: SurrealDB record ID representation in Rust

```
OPTIONS CONSIDERED:
  A. Use `surrealdb::RecordId` throughout domain — full type safety
     - Pro: compile-time guarantees on table + id
     - Con: domain crate must depend on surrealdb crate (breaks hexagonal purity)
  B. Use `String` in domain, convert at store boundary
     - Pro: domain stays infra-free
     - Con: lose type safety, need parsing in store
  C. Define a custom `RecordId(table: String, id: String)` in domain
     - Pro: infra-free AND structured
     - Con: must manually keep in sync with surrealdb's format

CHOSEN: B (String in domain, RecordId in store)
REASON: The domain crate must remain free of surrealdb. String IDs like
  "business:tacos_el_memo" are human-readable, serialise cleanly to JSON,
  and the SvelteKit client already works with them. Conversion is trivial
  and happens in exactly one place per repo method.
REVISIT IF: The team needs to enforce table-level type safety across more
  than 5 entity types, at which point option C becomes worth the effort.
```

### DECISION: Auth strategy for the hackathon

```
OPTIONS CONSIDERED:
  A. Full Argon2 hashing + JWT with refresh tokens
     - Pro: production-ready
     - Con: 2+ days of work, seed data needs real hashes
  B. Stub auth (any token accepted)
     - Pro: 30 minutes
     - Con: no real security, demo looks fake
  C. JWT-only, plaintext password match against seed stubs, no refresh
     - Pro: 4 hours, demo-able, real JWT flow
     - Con: not production-safe, but clearly marked as hackathon-only

CHOSEN: C
REASON: The hackathon demo needs a real login flow with a real token to
  impress judges, but doesn't need production hardening. The seed data
  already has `demo_hash_*` placeholders. Phase 2 adds Argon2.
REVISIT IF: The project goes to production or handles real user data.
```

### DECISION: How to call SurrealDB functions from Rust

```
OPTIONS CONSIDERED:
  A. Raw SurrealQL strings via `.query()`
     - Pro: direct, matches what tests already validate
     - Con: no compile-time checks on SurrealQL
  B. Build a Rust wrapper per function
     - Pro: type-safe interface
     - Con: duplicates logic that's already in the DB
  C. Use the surrealdb crate's `.run()` method for functions
     - Pro: first-class function call support, parameter binding
     - Con: API may differ between surrealdb crate versions

CHOSEN: A (raw `.query()` with parameter binding)
REASON: The SurrealDB functions (`fn::businesses_near`,
  `fn::tourist_recommendations`, etc.) are already tested via the shell
  test suite. Calling them with `.query("RETURN fn::businesses_near($pt, $r)")` 
  with bound parameters is the simplest, most direct approach. The
  SurrealQL strings are short and unlikely to change. 
REVISIT IF: The function count exceeds 10 or the team wants compile-time 
  SurrealQL validation.
```

### DECISION: AppState — concrete types vs. trait objects

```
OPTIONS CONSIDERED:
  A. AppState holds `Arc<SurrealAuthRepo>` (concrete)
     - Pro: simple, no vtable overhead, existing pattern
     - Con: can't swap implementations for testing
  B. AppState holds `Arc<dyn AuthRepository>` (trait object)
     - Pro: testable, can inject mocks
     - Con: requires `Send + Sync` bounds, slightly more ceremony

CHOSEN: B (trait objects) 
REASON: The whole point of the hexagonal architecture is swappable 
  implementations. Using trait objects lets the test suite inject an 
  in-memory mock without spinning up SurrealDB. The performance cost 
  of dynamic dispatch is negligible for an HTTP API.
REVISIT IF: Never — this is a foundational decision that only gets 
  more valuable over time.
```

### DECISION: Fix computed rating field (from earlier discussion)

```
OPTIONS CONSIDERED:
  A. Keep VALUE subqueries, add sleep() in tests
     - Pro: no schema change
     - Con: doesn't fix the root cause, production reads will be stale
  B. Event-driven: on_review_created updates business.rating + review_count
     - Pro: deterministic, always correct, tests pass reliably
     - Con: schema change required

CHOSEN: B
REASON: The VALUE subquery approach is fundamentally broken in SurrealDB v3 
  for cross-table computed fields. The event-driven fix makes the data 
  deterministic and the test suite reliable. This is a prerequisite for 
  everything else.
REVISIT IF: SurrealDB v4 adds reactive computed fields.
```

---

## 6. Phased Implementation Plan

### Phase 1 — Domain + Store (vertical slice)

**Goal:** The `domain` and `store` crates compile with tourism entities and at
least one repo method (business listing) can be called and returns real data
from SurrealDB.

**Components to build:**

1. **Domain entities:** `User` (with `Role` enum: `Tourist`, `Owner`, `Admin`),
   `Business`, `Review`, `City`, `Category`. Each maps 1:1 to the DB schema.
2. **Domain ports:** `AuthRepository` (find_user_by_email, verify session),
   `BusinessRepository` (list, get_by_id, search, near), `ReviewRepository`
   (create, list_for_business).
3. **Store repos:** `SurrealAuthRepo`, `SurrealBusinessRepo`,
   `SurrealReviewRepo` — each implementing their domain port with real
   SurrealDB queries.
4. **Store client:** Update `init_app_state` to connect to `ws://localhost:8000`
   with root credentials and `USE NS app DB main`.

**Exit criteria:**
- `cargo test -p store` has at least one integration test that queries a live
  SurrealDB and returns a `Business` struct.
- `cargo build --workspace` compiles with zero errors.

**Risk flags:**
- [MEDIUM RISK] The `surrealdb` v3 Rust crate's deserialization of `geometry<point>` into a Rust struct may require a custom `serde` implementation. Spike this early.
- [LOW RISK] SurrealDB relation edges (review is `TYPE RELATION IN user OUT business`) may not deserialize cleanly via the crate's `.select()` method. Use `.query()` with raw SurrealQL as a fallback.

---

### Phase 2 — API Routes + Auth

**Goal:** The Axum server starts, serves real data from SurrealDB, and
authenticates requests via JWT.

**Components to build:**

1. **Auth flow:**
   - `POST /auth/login` — accepts `{email, password}`, looks up user, verifies
     password (stub match for now), returns JWT.
   - JWT middleware — extracts `Bearer` token from `Authorization` header,
     decodes with `jsonwebtoken`, injects `User` into request extensions.
2. **Business routes (public):**
   - `GET /businesses/near?lat=X&lon=Y&radius_km=Z` — calls
     `fn::businesses_near`.
   - `GET /businesses/search?q=X&city=Y&category=Z` — calls
     `fn::search_businesses`.
   - `GET /businesses/{id}` — returns a single business with computed rating.
3. **Review routes (auth-gated):**
   - `POST /businesses/{id}/reviews` — accepts `{rating, body, locale}`,
     creates via `RELATE`.
   - `GET /businesses/{id}/reviews` — lists reviews for a business.
4. **Recommendation route (auth-gated):**
   - `GET /recommendations` — calls `fn::tourist_recommendations` for the
     authenticated user.
5. **AppState refactor:** Use `Arc<dyn Trait>` instead of concrete types.
6. **Config:** Update `AppConfig` to read `SURREAL_DB_URL`, `SURREAL_USER`,
   `SURREAL_PASS`, `SURREAL_NS`, `SURREAL_DB`, `JWT_SECRET`, `PORT`.

**Dependencies:** Phase 1.

**Exit criteria:**
- `curl -X POST localhost:3000/auth/login -d '{"email":"akiko@demo.xibalba.mx","password":"demo_hash_akiko"}'` returns a JWT.
- `curl localhost:3000/businesses/near?lat=19.4326&lon=-99.1332&radius_km=10` returns businesses.
- `curl -H "Authorization: Bearer <jwt>" -X POST localhost:3000/businesses/tacos_el_memo/reviews -d '{"rating":4,"locale":"ja"}'` creates a review and the business rating updates.

**Risk flags:**
- [LOW RISK] JWT secret management — use a hardcoded dev default, read from env
  in production.

---

### Phase 3 — Docker Compose + Justfile + Deploy

**Goal:** `docker compose up` starts both SurrealDB and the engine API.
`just server test` runs DB tests AND engine integration tests.

**Components to build:**

1. **engine.Dockerfile:** Multi-stage build — builder stage compiles the `api`
   binary, runtime stage is `debian:bookworm-slim` with just the binary.
2. **docker-compose.yml update:** Add `engine` service, depends_on `db`,
   environment variables for DB connection.
3. **Justfile update:** Add `engine build`, `engine run`, `engine test` recipes.
   Update `server test` to run both DB tests and engine tests.
4. **Health check route:** `GET /health` — returns 200 if SurrealDB is
   reachable.

**Dependencies:** Phase 2.

**Exit criteria:**
- `docker compose up -d` starts both services.
- `curl localhost:3000/health` returns 200.
- `just server test` runs both suites and reports combined pass/fail.

**Risk flags:**
- [MEDIUM RISK] The engine container must wait for SurrealDB to be ready AND
  seeded. Use a retry loop in `setup.rs` or a health check dependency in
  compose.

---

### Phase 4 — Hardening (post-hackathon)

**Goal:** Replace hackathon shortcuts with production patterns.

**Components:**
- Real Argon2 password hashing + seed data with proper hashes.
- JWT refresh token rotation.
- Rate limiting on auth endpoints.
- CORS locked to specific origins.
- Structured JSON logging.
- WASM crate updated with tourism domain types.
- OpenAPI spec generation (via `utoipa` or `aide`).

**Dependencies:** Phase 3 + hackathon feedback.

**Exit criteria:** Security audit passes. OWASP top-10 addressed.

---

## 7. Implementation Management

### Sequencing (dependency graph)

```
Phase 1: domain entities + store repos
    │
    ├──► WASM stub fix (parallel, 30 min)
    │
    ▼
Phase 2: API routes + auth + middleware
    │
    ▼
Phase 3: Docker + justfile + deploy
    │
    ▼
Phase 4: Hardening (post-hackathon)
```

### Time estimates

| Phase | Estimated effort | Critical path? |
|-------|-----------------|----------------|
| 0     | 1–2 hours       | Yes            |
| 1     | 4–6 hours       | Yes            |
| 2     | 6–8 hours       | Yes            |
| 3     | 2–3 hours       | Yes            |
| 4     | Multi-day       | No             |

**Total to demoable:** ~15–19 hours of focused work.

### Ownership

- **Fernando (backend):** All phases. This is a solo backend effort.
- **Teammates:** Can start testing API routes from Phase 2 onwards. Client apps
  can be wired to the real API in parallel with Phase 3.

### Critical path

Phase 1 → Phase 2. Everything else can be parallelised. The single
biggest risk is Phase 1's SurrealDB Rust crate deserialization — if
`geometry<point>` or relation edges don't deserialize cleanly, it could add
2–4 hours of debugging.

### Breaking changes

- **[HIGH RISK] Domain entity deletion is irreversible.** Once the inventory
  entities are removed, the WASM crate will fail to compile until it's updated
  or stubbed. Fix: keep the WASM crate compiling with empty type re-exports
  during Phase 1.
- **[HIGH RISK] API route paths change.** Any client currently hitting
  `/inventory/*` will break. Since the client isn't wired yet, this is safe
  now but must be coordinated before client integration.

---

## 8. Validation & Testing Strategy

| Layer | Test type | What it verifies |
|-------|-----------|------------------|
| Domain entities | Unit tests (`cargo test -p domain`) | Serialization round-trips, enum variants, field defaults |
| Store repos | Integration tests (`cargo test -p store`) | Real SurrealDB queries return correct Rust types, error mapping works |
| API routes | Integration tests (`cargo test -p api`) | HTTP status codes, JSON shapes, auth enforcement |
| Full stack | E2E via curl/shell | Login → search → review → recommendation flow |
| DB schema | Existing shell test suite (`just server test`) | All 27 tests pass, computed fields deterministic |

### Architecture fitness functions

- **No surrealdb in domain:** Add a CI check that `grep -r "surrealdb"
  core/domain/` returns empty.
- **No axum in store:** Same pattern for `grep -r "axum" core/store/`.
- **No raw SurrealQL in api:** Queries must only exist in `store/src/repos/`.

### Local dev validation

1. `docker compose up db` — start SurrealDB.
2. `just server test` — verify DB schema (27/27).
3. `cargo run -p api` — start the engine.
4. Run the curl commands from Phase 2 exit criteria.

### Observability

- `tracing` with `EnvFilter` — `RUST_LOG=info,api=debug,store=debug`.
- Every request logged: method, path, status, duration (via `TraceLayer`).
- Every SurrealDB query logged at `debug` level with execution time.
- Errors logged at `error` level with full context.

---

## 9. Open Questions & Risks

1. **SurrealDB Rust crate + geometry types.** Does
   `surrealdb::sql::Geometry::Point` deserialize cleanly from the DB's
   `geometry<point>` field? Unknown — needs a spike in Phase 1.

2. **Relation edge deserialization.** The `review` table is `TYPE RELATION IN
   user OUT business`. Does the Rust crate's `.query()` return the `in` and
   `out` fields as `RecordId`? Needs verification.

3. **WASM crate breakage.** Removing inventory entities breaks the WASM
   compilation. Mitigation: stub the exports with empty types until Phase 4.
   This is a known, manageable risk.
