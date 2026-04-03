# Xibalbá — Test Infrastructure Fix Plan

> **Principal Architect Assessment**
> Scope: Fix cascading test failures, establish test isolation, and harden the test infrastructure for safe feature development.

---

## 0. Executive Summary

Xibalbá's test suite has a **shared mutable state problem**: the Rust integration tests and the DB shell tests both operate on the same live SurrealDB instance (`app:main`) without any isolation or cleanup. A single Rust test (`c4`) permanently inserts a review that breaks the shell test's exact-count assertion (`H3`), and on re-run, the Rust test itself fails because of a UNIQUE index collision. Separately, `e5_recommendation_engine` fails because the SurrealQL function returns record ID strings where the Rust deserializer expects full `Business` structs.

These are **two independent bugs** amplified by **one architectural gap** (no test isolation). The fix plan addresses all three in phased, independently-verifiable steps.

---

## 1. Root Cause Analysis

### Bug 1 — `e5_recommendation_engine` (Rust): Deserialization mismatch

**Where:** `engine/core/store/src/repos/business.rs` → `get_recommendations()`

**What happens:**
- The repo calls `RETURN fn::tourist_recommendations(type::record($user), $limit)`
- The SurrealQL function's final line is `RETURN $recommendations.business`
- `$recommendations.business` extracts the `business` field from each row, which is `out AS business` — a **record reference** (string like `"business:mezcaleria_la_condesa"`)
- The Rust code tries to deserialize these strings as `Vec<Business>` structs via `to_domain_vec()`
- Serde fails: `"invalid type: string, expected struct Business"`

**Why the shell test passes:** The shell test (`03-graph.sh E5`) just `grep`s the raw JSON response for the record ID substring — it never attempts struct deserialization.

**Fix strategy:** Two options (choose one):
- **Option A — Fix the SurrealQL function** to `SELECT * FROM` the returned business IDs, returning full documents. This is the cleaner solution because the function becomes self-contained and the Rust layer stays thin.
- **Option B — Fix the Rust repo** to first get IDs, then fetch full records. This adds a round-trip and couples the repo to the function's return shape.

**Recommendation:** Option A.

**Concrete change to `db/init/03-functions/01-functions.surql`:**
```
-- CURRENT (broken for Rust):
RETURN $recommendations.business;

-- FIXED:
LET $biz_ids = $recommendations.business;
RETURN SELECT * FROM business WHERE id IN $biz_ids;
```

This makes the function return full `Business` documents. Both the shell test (which greps for the ID) and the Rust test (which deserializes to `Business`) will pass.

**Validation:** Run `just server test` — `e5` should pass in both suites.

---

### Bug 2 — `c4_rating_recomputed_after_review` (Rust): Permanent mutation + UNIQUE violation

**Where:** `engine/core/store/src/tests.rs` → `c4_rating_recomputed_after_review()`

**What happens:**
1. The test creates a review: `RELATE user:tourist_james → review → business:cantina_la_perla` with `rating=5`
2. This review is **never cleaned up** — it persists in the live database
3. On the next `just server test` run:
   - The **shell test H3** expects exactly 9 reviews but finds 10 → ❌
   - The **Rust test c4** tries to create the same review again, hits the `review_per_tourist_per_business` UNIQUE index → ❌

**This is the cascade:** One Rust test poisons the DB for both suites on all subsequent runs.

**Fix strategy:** Introduce test cleanup. Three sub-options:
- **Option A — Teardown in the test itself:** Delete the review at the end of `c4` (and in a panic hook to handle failures). Simple, local, but fragile.
- **Option B — Use a dedicated test namespace/database:** Each Rust test run uses `app:test_<timestamp>` instead of `app:main`. The DB is seeded fresh into the test DB, tests run, then the test DB is dropped. This is the gold standard for integration test isolation.
- **Option C — Use idempotent test data:** Generate a unique user+business pair per test run so the UNIQUE index is never hit. Avoids the count problem but doesn't fix the root issue (DB accumulates garbage).

**Recommendation:** Option A as an **immediate fix** (5 minutes of work), with Option B as the **Phase 2 hardening** step (requires more plumbing but gives you true isolation forever).

---

### Bug 3 — Shell test `H3` count drift

**Where:** `db/test/e2e/01-smoke.sh` line `H3`

**What happens:**
- H3 asserts `"count":9` exactly
- 7 seed reviews + 1 from C4 (shell) + 1 from D1 (shell) = 9
- But after Rust tests run, there's an extra review from Rust's `c4` → count becomes 10

**Fix strategy:** This is a **symptom** of Bug 2, not an independent bug. Fixing Bug 2's cleanup resolves H3 automatically. However, the exact-count assertion style is inherently brittle — any new test that creates a review will break H3.

**Hardening recommendation:** Change H3 from exact-match (`"count":9`) to minimum-bound (`count >= 9`). This matches what the Rust tests already do for H1/H2/H3 (`assert!(count >= 9)`). The shell test should verify that seed data **exists**, not that the DB is in an exact pristine state.

---

## 2. Phased Implementation Plan

### Phase 1 — Immediate Fix (target: same day)

**Goal:** Make `just server test` pass reliably and be re-runnable.

**Step 1.1 — Fix `fn::tourist_recommendations` return type**

File: `db/init/03-functions/01-functions.surql`

Replace the last line of the function body:
```surql
-- BEFORE:
RETURN $recommendations.business;

-- AFTER:
LET $biz_ids = $recommendations.business;
RETURN SELECT * FROM business WHERE id IN $biz_ids;
```

Rebuild the DB container (`just server build-db`) to apply the schema change.

**Exit criteria:** Rust test `e5_recommendation_engine` passes. Shell test `E5` still passes.

---

**Step 1.2 — Add cleanup to Rust test `c4`**

File: `engine/core/store/src/tests.rs`, function `c4_rating_recomputed_after_review`

After the final assertion, delete the review that was created:
```rust
// Cleanup: remove the test review so the DB returns to seed state
client
    .db
    .query("DELETE FROM review WHERE in = user:tourist_james AND out = business:cantina_la_perla")
    .await
    .unwrap();
```

**Why `tourist_james → cantina_la_perla`?** Because `tourist_james` has no seeded review for `cantina_la_perla`, so this delete only removes the test-created record without touching seed data.

**Edge case:** If the test panics before cleanup, the review persists. For now this is acceptable — Phase 2 eliminates this risk entirely.

**Exit criteria:** Run `just server test` twice in a row. Both runs pass 27/27 on both suites.

---

**Step 1.3 — Harden shell test H3 (optional but recommended)**

File: `db/test/e2e/01-smoke.sh`

Change the H3 assertion from exact to minimum:
```bash
# BEFORE:
if echo "$RES" | grep -qE '"count":9'; then

# AFTER:
COUNT=$(echo "$RES" | grep -oP '"count":\K[0-9]+')
if [ "$COUNT" -ge 9 ]; then
```

Update the pass/fail messages accordingly.

**Exit criteria:** H3 passes even if extra reviews exist from previous test debris.

---

**Step 1.4 — Remove unused imports**

File: `engine/core/store/src/tests.rs`

Remove the two unused imports that generate warnings:
```rust
// DELETE these lines:
use crate::repos::auth::SurrealAuthRepo;
use domain::ports::auth::AuthRepository;
```

**Exit criteria:** `cargo test -p store` compiles with zero warnings.

---

### Phase 2 — Test Isolation Infrastructure (target: next sprint)

**Goal:** Rust integration tests run against an ephemeral database, completely isolated from the seeded `app:main`.

**Step 2.1 — Create a test harness module**

File: `engine/core/store/src/test_harness.rs` (new)

Responsibilities:
- Connect to SurrealDB
- Create a unique namespace/database pair (e.g., `test:run_<uuid>`)
- Execute all `.surql` init files from `db/init/` in order (schema → indexes → functions → events → seed)
- Return a `SurrealClient` pointed at the test database
- On drop (or explicit teardown), delete the test database

Interface (described, not code):
- `TestHarness::setup() -> (SurrealClient, TestHarness)` — creates and seeds the ephemeral DB
- `TestHarness::teardown(&self)` — drops the test DB
- Implement `Drop` for automatic cleanup

**Step 2.2 — Migrate all tests to use the harness**

Replace `test_client()` with `TestHarness::setup()` in every test. The `--test-threads=1` constraint can be relaxed if each test gets its own DB, but for simplicity, keep sharing one test DB per run initially.

**Step 2.3 — Update `server.just` test recipe**

The Rust tests no longer depend on the shell-tested DB being in a specific state. The recipe can run both suites in parallel if desired, or keep sequential execution for simplicity.

**Exit criteria:**
- Rust tests create and destroy their own database
- `app:main` is never touched by Rust tests
- Shell tests and Rust tests can run in any order, any number of times, with identical results

---

### Phase 3 — Long-term Hardening (target: before feature expansion)

**Step 3.1 — CI pipeline enforcement**

Add a CI job that:
1. Starts SurrealDB in Docker (memory mode)
2. Runs `just server test`
3. Runs `just server test` **a second time** (regression gate for idempotency)
4. Fails the pipeline if any test fails on either run

**Step 3.2 — Test categorization**

Separate tests into:
- **Pure unit tests** (no DB): Schema validation assertions that don't need a live DB (move to `domain` crate)
- **Integration tests** (ephemeral DB): Everything in `store/src/tests.rs`
- **E2E/smoke tests** (seeded DB): Shell test suite

**Step 3.3 — Architectural fitness functions**

Add automated checks:
- **No raw SQL in tests that bypass repos**: Grep for `client.db.query()` in test files and flag any that create/mutate data without using the repository layer
- **Seed count assertions are bounds-based, not exact**: Lint shell tests for exact count patterns
- **Every mutating test has cleanup or uses the harness**: Code review checklist item

---

## 3. Trade-off Analysis

```
DECISION: How to fix fn::tourist_recommendations return type
OPTIONS CONSIDERED:
  A. Fix the SurrealQL function to return full documents — single change, function becomes self-documenting
  B. Fix the Rust repo to do a second query — adds latency, couples repo to function internals
CHOSEN: Option A
REASON: The function's contract should be "give me recommended businesses", not "give me recommended business IDs".
         The repo layer should not need to know the function's internal query shape.
REVISIT IF: Performance profiling shows the SELECT * inside the function is too expensive at scale.
```

```
DECISION: How to achieve test isolation for Rust integration tests
OPTIONS CONSIDERED:
  A. Per-test cleanup (delete created records) — minimal change, fragile if tests panic
  B. Ephemeral test database per run — robust, requires harness code, slightly slower setup
  C. Docker container reset between suites — very slow, overkill for this project size
CHOSEN: Option A (immediate), transitioning to Option B (Phase 2)
REASON: Option A unblocks development today. Option B provides the foundation for safe feature expansion.
         Option C is unnecessary given SurrealDB's native namespace isolation.
REVISIT IF: Test count exceeds ~50 and per-test cleanup becomes unmaintainable.
```

```
DECISION: Exact vs. minimum-bound count assertions in shell tests
OPTIONS CONSIDERED:
  A. Keep exact counts — catches unexpected data creation, but breaks on any test ordering change
  B. Use minimum bounds — resilient to test debris, but won't catch unexpected deletions
CHOSEN: Option B
REASON: The shell tests verify "seed data loaded correctly", not "database is in pristine state".
         Exact counts create coupling between test suites that shouldn't exist.
REVISIT IF: You need a "database audit" test — create a separate dedicated script for that.
```

---

## 4. Dependency Graph (Execution Order)

```
Step 1.1 (fix SurrealQL function)
    │
    ├── Step 1.2 (add Rust test cleanup)     ← independent of 1.1
    │
    ├── Step 1.3 (harden H3 assertion)       ← independent of 1.1 and 1.2
    │
    └── Step 1.4 (remove unused imports)     ← independent of everything

All Phase 1 steps can be done in parallel or any order.
Phase 2 depends on Phase 1 being complete and validated.
Phase 3 depends on Phase 2.
```

---

## 5. Risk Flags

- **[MEDIUM RISK]** Step 1.1 changes the return type of `fn::tourist_recommendations`. If any other code (client-side SvelteKit, WASM bridge) calls this function and expects record IDs instead of full documents, it will break. **Mitigation:** Search the entire codebase for `tourist_recommendations` — based on the file tree, only the Rust repo and the shell test call it.

- **[LOW RISK]** Step 1.2's cleanup query (`DELETE FROM review WHERE in = ... AND out = ...`) could accidentally delete seed data if someone changes the seed to include `tourist_james → cantina_la_perla`. **Mitigation:** Phase 2 eliminates this risk entirely.

- **[HIGH RISK — existing]** The `test_client()` function connects to `app:main` with hardcoded credentials. Any developer running `cargo test` accidentally mutates the development database. This is the single biggest risk to your workflow and is resolved by Phase 2.

---

## 6. Quick-Start Checklist

For the developer who wants to fix this right now:

- [ ] Edit `db/init/03-functions/01-functions.surql` — change `RETURN $recommendations.business;` to fetch full records
- [ ] Rebuild DB: `just server build-db && podman-compose up -d`
- [ ] Edit `engine/core/store/src/tests.rs`:
  - [ ] Add cleanup DELETE query at end of `c4_rating_recomputed_after_review`
  - [ ] Remove unused imports (`SurrealAuthRepo`, `AuthRepository`)
- [ ] Edit `db/test/e2e/01-smoke.sh` — change H3 from exact to `>=` assertion
- [ ] Run `just server test` — expect 27/27 on both suites
- [ ] Run `just server test` again — expect 27/27 again (idempotency verified)
- [ ] Commit with message: `fix: test isolation + recommendation deserialization`