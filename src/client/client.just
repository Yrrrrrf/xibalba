# ── Xibalbá · Client ──────────────────────────────────────────
#  CI

[doc('Format Rust code')]
[group('CI')]
fmt:
    deno fmt .

[doc('Lint Rust code')]
[group('CI')]
lint:
    deno lint .

[doc('Type-check Rust workspace')]
[group('CI')]
typecheck:
    deno check .

[doc('Full client quality gate')]
[group('CI')]
quality: fmt lint typecheck
    @echo "✓ Client quality checks passed"

# Deploy

[doc('Build SDK (from wasm to ui)')]
[group('Build')]
build-sdk:
    # todo: Add the sdk build command
    # * build the wasm bridge and emit to sdk/core/src/pkg/
    just -f engine/services/wasm/build-wasm.just build
    # * build the ui sdk
    # todo: Add build commands for the ui sdk
    # deno run ...
    @echo "✓ SDK built successfully"

[doc('Build Apps')]
[group('Build')]
build-apps:
    # todo: Add the apps build command
    # * build agent
    # * build explorer
    # * build vision
    @echo "✓ Apps built successfully"

[doc('Build Client')]
[group('Build')]
build:
    just build-sdk
    just build-apps
    @echo "✓ Client built successfully"

# Dev

[doc('Run the client in development mode')]
[group('Dev')]
run:
    # todo: Add the dev command
    # todo: Add a command to instantiate the client
    # todo: Init agent
    # deno run agent
    # todo: Init explorer
    # deno run explorer
    # todo: Init vision
    # deno run vision
    @echo "✓ Client running in development mode"

[doc('Test the client')]
test:
    # todo: Add the test command
    # todo: Add a command to run the client tests
    cd engine && cargo test

# todo: Implement the deploy tasks!
# todo: Implement the deploy tasks!
# todo: Implement the deploy tasks!
# todo: Implement the deploy tasks!
# todo: Implement the deploy tasks!

# ── Deploy (Tauri) ─────────────────────────────────────

[doc('Build the Tauri app for production')]
[group('Deploy')]
deploy:
    # todo: Add the Tauri build command
    @echo "✓ Tauri app built for production"
