# Client

> Deno 2 monorepo — SvelteKit SPA + shared SDK.

## Stack

| Layer     | Tool                        | Why                                      |
| --------- | --------------------------- | ---------------------------------------- |
| Runtime   | Deno 2                      | Single toolchain: install/fmt/lint/test  |
| Framework | SvelteKit + Svelte 5 Runes  | Static SPA, no SSR (Tauri-compatible)    |
| Build     | Vite                        | Per-app `vite.config.ts`                 |
| Styling   | TailwindCSS v4 + DaisyUI v5 | Theme once in `@sdk/ui`, everywhere else |
| i18n      | Paraglide-JS (compile-time) | 13 locales in SDK, 5 per app             |

## Layout

```
src/client/
├── deno.json          ← workspace root + shared deps
├── apps/
│   ├── agent/         ← B2B — inventory CRUD + document gen (→ Tauri)
│   ├── explorer/      ← B2C — Leaflet map + search
│   └── vision/        ← telemetry + 3D visualization
└── sdk/
    ├── core/          ← pure TS domain types + WASM bridge (no framework)
    ├── state/         ← Svelte $state/$derived stores (no UI)
    └── ui/            ← component library + theme + all locales
```

## Dependency Rule

```
@sdk/ui  →  @sdk/state  →  @sdk/core  →  (WASM pkg from server)
```

No layer may import upward. Violations are architecture bugs.

## Key Constraints

- **No server-side SvelteKit** — no `+page.server.ts`, no `+server.ts`. Every
  app builds to a static SPA (`adapter-static`, `ssr = false`).
- **No raw `fetch()` in apps** — all data goes through `@sdk/state` stores.
- **No hardcoded strings** — all UI text via `m.key()` (Paraglide).
- **No raw floats for money** — always `Dinero.js`.

## Dev

```sh
nix develop        # enter the shell
just dev-agent     # or dev-explorer / dev-vision
```
