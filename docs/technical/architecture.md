# Xibalbá — Architecture

> Inventory System Engine. Multi-platform (Web + Desktop + Mobile via Tauri).
> Strict client-server split: a [Deno](https://deno.com) monorepo on the
> frontend, a [Rust](https://www.rust-lang.org) Cargo workspace on the backend,
> and a [SurrealDB](https://surrealdb.com) instance as the single source of
> truth.

---

## Overview

```
src/
  client/          # Deno workspace — SvelteKit apps + shared SDK
    sdk/           # Shared SDK packages
    apps/          # SvelteKit apps
  server/
    db/            # SurrealDB container + seed
    engine/        # Rust workspace — domain, store, HTTP API, WASM bridge
```

**Data flow (end to end):**
`SurrealDB → store → api → @sdk/core → @sdk/state → @sdk/ui → SvelteKit apps → Tauri (native)`

**Dependency rule (both sides):** dependencies flow in one direction only.
Nothing at a lower layer may import from a higher layer. Violations are
architecture bugs, not style issues.

---

## [Client](/src/client/)

**Runtime:** [Deno 2](https://deno.com) — single toolchain for install, fmt,
lint, test, and task running. No Node.js, no npm scripts. The workspace root
`deno.json` declares all shared deps (npm: prefixed) so every app and SDK
package resolves from one lock.

**Rendering:** strict SPA (`adapter-static`, `ssr = false`). Reason: the same
static build must run on GitHub Pages, inside a Docker/Traefik container, and
inside a Tauri WebView on iOS/Android. Server-side code (`+page.server.ts`,
`+server.ts`) is forbidden — it breaks the mobile build.

**Build tool:** [Vite](https://vitejs.dev) — used by every SvelteKit app and the
UI SDK package. Configured per-app via `vite.config.ts`.

**Framework:** [Svelte 5](https://svelte.dev) with Runes (`$state`, `$derived`,
`$effect`). Legacy stores are not used. Reactivity is explicit and compile-time.

**Component runtime:** [Rune-Lab](https://github.com/Yrrrrrf/rune-lab) — an
internal library providing the `RuneProvider`, app shell, and dev tooling built
on top of the Svelte 5 Runes API. Injected locally during development via
`client.just`.

**i18n:**
[Paraglide-JS](https://inlang.com/m/gerre34r/library-inlang-paraglideJs) —
compile-time i18n. All UI text must be tokenized (`m.key()`). No hardcoded
strings. Strategy: `localStorage → preferredLanguage → baseLocale`. The SDK UI
package carries 13 locales (ar, de, en, es, fr, hi, it, ja, ko, pt, ru, vi, zh).

**Styling:** [TailwindCSS v4](https://tailwindcss.com) +
[DaisyUI v5](https://daisyui.com) — utility classes only, no custom CSS unless
strictly required for layout. Theme changes happen once in `@sdk/ui` and
propagate everywhere.

**Forms:** [sveltekit-superforms](https://superforms.rocks) — typed form
handling with built-in validation. Works under SPA mode.

**Money:** [Dinero.js](https://dinerojs.com) — immutable monetary values. Never
use raw floats for prices.

**Maps:** [Leaflet](https://leafletjs.com) — used in Explorer App for property
and inventory geolocation.

**Keyboard:** [hotkeys-js](https://github.com/jaywcjlove/hotkeys-js) — shortcut
bindings for the Agent App command interface.

---

### [sdk/](/src/client/sdk/)

The SDK is a Deno sub-workspace (`src/client/sdk/`) consumed by all three apps
via path aliases (`@sdk/core`, `@sdk/state`, `@sdk/ui`). No circular imports.

#### [`@sdk/core`](/src/client/sdk/core/)

Pure TypeScript — zero framework dependencies. Defines domain entities,
repository interfaces (port traits), and business logic. Nothing here may import
from `@sdk/state` or `@sdk/ui`. Also re-exports WASM-compiled types and
validation functions from the server's `engine/services/wasm` crate, making Rust
domain types available in TypeScript with zero duplication.

#### [`@sdk/state`](/src/client/sdk/state/)

Svelte-specific reactive layer. Wraps core services with `$state` / `$derived` /
`$effect`. All data fetching (via `surrealdb` npm client or REST `fetch()` to
the API) lives here. Apps never call `fetch()` directly — they read from state
stores. Cannot import from `@sdk/ui`.

#### [`@sdk/ui`](/src/client/sdk/ui/)

Svelte component library. Primitives → domain components → features → layouts.
Imports types from `@sdk/core` and state from `@sdk/state`. No direct
infrastructure calls. Owns the TailwindCSS + DaisyUI theme and all 13 i18n
locale files. Changes here propagate to all apps automatically.

---

### [apps/](/src/client/apps/)

Three independent SvelteKit apps, each with its own `deno.json`,
`vite.config.ts`, and Dockerfile. They share deps via the workspace root and SDK
packages via aliases. Each can be deployed independently.

#### [agent](/src/client/apps/agent) — CRM & Management (B2B)

Admin-facing. Inventory CRUD, document generation (PDF reports, item labels),
user and session management. Planned Tauri packaging for desktop + mobile.
Auth-gated via session cookie checked in `hooks.server.ts`.

#### [explorer](/src/client/apps/explorer) — B2C Search & Map

Public-facing discovery interface. Leaflet map, search, filters. Uses `@sdk/ui`
map components (`MapView`, `PropertyClusterLayer`, etc.) and the `surrealdb`
client for real-time queries.

#### [vision](/src/client/apps/vision) — Telemetry & 3D

Real-time system health and data visualization. 3D virtual tours. Read-only
consumer of the API.

**Native output:** [Tauri](https://tauri.app) wraps the static SvelteKit build
into native binaries for macOS, Windows, Linux, iOS, and Android. SSG export
from `SvelteKit Hub → Tauri`. The Tauri layer has no extra logic — it is purely
a WebView shell pointing at the compiled SPA.

---

## [Server](/src/server/)

**Language:** [Rust](https://www.rust-lang.org) — chosen for performance, memory
safety, and the ability to compile the same domain types to WASM for use on the
client. Edition 2024.

**Async runtime:** [Tokio](https://tokio.rs) with `features = ["full"]`.

**Task runner:** [just](https://just.systems) — all build, test, deploy, and
WASM pipeline commands are defined in `.just` files.

**Containerisation:** [Docker](https://www.docker.com) via `docker-compose.yml`.
Currently runs SurrealDB only; the `engine` API Dockerfile is pending.

---

### [db/](/src/server/db/)

[SurrealDB v3](https://surrealdb.com) running in Docker on port `8000`.
Namespace `app`, database `main`. Chosen because it collapses the DB + API layer
into one: it supports SurrealQL (graph queries, live queries, relations), acts
as both a document and relational store, and has a first-class Rust client and
an npm client for direct use from the frontend.

In development it runs in-memory (`--log trace memory`). For persistence, switch
the compose command to `file://data` and uncomment the volume.

The `seed.surql` file provisions initial records and graph relations. The
`test_query.sh` script runs it against a live instance via
[xh](https://github.com/ducaale/xh) (a `curl` replacement).

---

### [engine/](/src/server/engine/)

Cargo workspace at `src/server/engine/`. Four crates with strict unidirectional
dependencies.

```
core/
  domain    ← no external deps except serde/uuid/chrono
  store     ← depends on domain only
services/
  api       ← depends on domain + store
  wasm      ← depends on domain only
```

#### [`core/domain`](/src/server/engine/core/domain)

Pure Rust. No infrastructure crates allowed. Contains:

- **entities** — `User`, `Role`, `Session`, `Item`, `Category`, `Location`,
  `DocumentRequest`, `DocumentOutput`
- **ports** — repository and renderer trait definitions (`AuthRepository`,
  `InventoryRepository`, `DocumentRenderer`)

Ports live here (not in `api`) so that `store` can implement them without
creating a circular dependency. This is the Dependency Inversion Principle
applied at the crate level.

#### [`core/store`](/src/server/engine/core/store)

Implements `domain` ports against SurrealDB using the official
[surrealdb](https://crates.io/crates/surrealdb) Rust crate. Wraps a shared
`Arc<Surreal<Any>>` in a `SurrealClient` newtype so it is cheaply cloneable
across async tasks. Exposes `SurrealAuthRepo` and `SurrealInventoryRepo`. No
HTTP, no WASM.

#### [`services/api`](/src/server/engine/services/api)

[Axum](https://github.com/tokio-rs/axum) HTTP service on port `3000`. Clean
architecture inside:

- **infra/** — `AppConfig` (env vars), `setup.rs` (tracing init, `AppState`
  construction), `app.rs` (`create_app` → `Router`)
- **application/** — `AppError` enum + `AppResult<T>` alias; error variants map
  to HTTP status codes via `IntoResponse`
- **adapters/http/** — `AppState` (holds `Arc<repos>` + `Arc<TypstCompiler>`),
  auth middleware (Bearer token → session lookup), logger middleware
- **adapters/documents/typst/** — [Typst](https://typst.app) compiler adapter
  implementing `DocumentRenderer`. Renders inventory reports and item labels
  from `.typ` templates
- **adapters/crypto/** — [Argon2](https://crates.io/crates/argon2) password
  hashing
- **routes/** — `/auth` (login, refresh), `/inventory` (CRUD), `/documents`
  (generate). `/inventory` and `/documents` are auth-gated via middleware

Auth uses [jsonwebtoken](https://crates.io/crates/jsonwebtoken) (JWT) with the
secret read from `JWT_SECRET` env var.

Observability via [tracing](https://crates.io/crates/tracing) +
[tracing-subscriber](https://crates.io/crates/tracing-subscriber) with
`EnvFilter`. Production target: JSON to file + pretty to stdout.

#### [`services/wasm`](/src/server/engine/services/wasm)

Compiles `domain` types to WebAssembly using
[wasm-bindgen](https://rustwasm.github.io/wasm-bindgen/). Exports TypeScript
type definitions for all domain entities and exposes validation functions
(`validate_sku`, `validate_quantity`) callable from JavaScript. Built via
`wasm-bindgen` CLI and output to `src/client/sdk/core/src/pkg/`. This is the
bridge that keeps Rust domain types and client TypeScript types in sync without
any manual duplication.

---

## Architectural Rules

1. **Unidirectional dependencies** — on both sides. Client: `ui → state → core`.
   Server: `api → store → domain`. Cross-cutting: `wasm` depends on `domain`
   only.

2. **No server-side code in SvelteKit** — no `+page.server.ts`, no `+server.ts`,
   no `$env/static/private`. The app is a static SPA.

3. **No business logic outside `domain`** — validation, invariants, and rules
   live in `core/domain` (Rust) and `@sdk/core` (TS). Infrastructure is plumbing
   only.

4. **Ports in `domain`, not in consumers** — repository and renderer traits are
   defined in `core/domain` so any crate can implement them without depending
   upward.

5. **State is the only data gateway in the client** — apps never call `fetch()`
   or the `surrealdb` client directly. They read from `@sdk/state` stores.

6. **Money is always `Dinero.js`** — never raw floats for prices.

7. **All UI text is tokenized** — no hardcoded strings anywhere in the client.
   Use `m.key()` from Paraglide.

8. **WASM bundle keeps types in sync** — when a domain entity changes in Rust,
   run `just wasm` to regenerate the TypeScript definitions. Do not manually
   edit the generated `pkg/` files.
