# ── WASM Build Pipeline ──────────────────────────────────────────────────────
# Builds the `wasm` crate → generates JS/TS bindings → formats output.
# The generated pkg/ is consumed by @sdk/core on the client side.
#
# Usage:
#   just wasm              → full pipeline (clean → build → bind → fmt)
#   just wasm-check        → cargo check only (fastest feedback)
#   just wasm-lint         → clippy (no build)
#   just wasm-clean        → remove generated pkg/ directory
# ─────────────────────────────────────────────────────────────────────────────

wasm_out := "../../../../src/client/sdk/core/src/pkg"
wasm_artifact := "target/wasm32-unknown-unknown/release/wasm.wasm"

# ── Pre-flight ────────────────────────────────────────────────────────────────

[doc('Ensure wasm32 target is installed (run once)')]
[group('wasm')]
wasm-setup:
    @echo "🎯 Adding wasm32-unknown-unknown target..."
    rustup target add wasm32-unknown-unknown
    @echo "✓ Target ready"

# ── Individual steps ──────────────────────────────────────────────────────────

[doc('Remove generated WASM JS/TS bindings')]
[group('wasm')]
wasm-clean:
    @echo "🧹 Cleaning WASM bindings..."
    rm -rf {{ wasm_out }}
    @echo "✓ Cleaned"

[doc('Compile the wasm crate to wasm32-unknown-unknown (release)')]
[group('wasm')]
wasm-build:
    @echo "🦀 Compiling wasm crate..."
    cargo build \
        -p wasm \
        --lib \
        --target wasm32-unknown-unknown \
        --release
    @echo "✓ Compiled → {{ wasm_artifact }}"

[doc('Generate JS/TS bindings from the compiled .wasm artifact')]
[group('wasm')]
wasm-bind:
    @echo "🔗 Generating JS/TS bindings..."
    mkdir -p {{ wasm_out }}
    wasm-bindgen \
        --target web \
        --out-dir {{ wasm_out }} \
        {{ wasm_artifact }}
    @echo "✓ Bindings written to {{ wasm_out }}"

[doc('Format generated bindings and wasm crate source')]
[group('wasm')]
wasm-fmt:
    @echo "✨ Formatting..."
    cargo fmt -p wasm
    deno fmt {{ wasm_out }}
    @echo "✓ Formatted"

# ── Feedback loop (no build output) ──────────────────────────────────────────

[doc('cargo check on the wasm crate (fastest feedback)')]
[group('wasm')]
wasm-check:
    @echo "🔎 Checking wasm crate..."
    cargo check \
        -p wasm \
        --lib \
        --target wasm32-unknown-unknown
    @echo "✓ Check passed"

[doc('Run clippy on the wasm crate (-D warnings)')]
[group('wasm')]
wasm-lint:
    @echo "📎 Linting wasm crate..."
    cargo clippy \
        -p wasm \
        --lib \
        --target wasm32-unknown-unknown \
        -- -D warnings
    @echo "✓ Lint passed"

# ── Full pipeline ─────────────────────────────────────────────────────────────

[doc('Full WASM pipeline: clean → build → bind → fmt')]
[group('wasm')]
wasm: wasm-clean wasm-build wasm-bind wasm-fmt
    @echo ""
    @echo "🎉 WASM pipeline complete!"
    @echo "   Bindings → {{ wasm_out }}"
    @echo "   Re-run 'just wasm' whenever domain types change."
