# Server

## Database ([SurrealDB](https://surrealdb.com/))

### Schema

This file must define the main about the database schema.

### Data

This file must define the main about the database data.

## Engine

### Core

### Services

### ❄️ How the Nix Environment Works

Our server infrastructure is strictly isolated and reproducible using **Nix
Flakes**. You don't need `rustup`, `cargo`, or OpenSSL installed on your host
machine to work on this project.

Here is the magic behind our [`flake.nix`](./flake.nix):

- **Native WASM Toolchain:** We
  use[`rust-overlay`](https://github.com/oxalica/rust-overlay) to inject a
  deterministic Rust compiler that comes pre-configured with the
  `wasm32-unknown-unknown` target. No imperative `rustup target add` commands
  required.
- **Layered Build Caching:** We use
  [`naersk`](https://github.com/nix-community/naersk) to compile our Cargo
  workspace. It compiles dependencies (`axum`, `surrealdb`) in a separate
  derivation from our application code. If you change one line of business
  logic, Nix only rebuilds that line—making local builds and CI lightning fast.
- **C-Bindings Tamed:** Nix automatically exposes `pkg-config` and maps the
  `OPENSSL_DIR` environment variables so our backend crypto and database drivers
  compile seamlessly across Linux and macOS.

#### Quick Commands

- `nix develop` — Enter the isolated shell (Rust, Cargo, Deno, and WASM tools
  ready to go).
- `nix build .#api` — Build a pure, production-ready binary of the Axum server.
- `nix build .#wasm` — Build the WASM bridge for the SvelteKit frontend.
