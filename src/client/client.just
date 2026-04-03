# ── Xibalbá · Client ──────────────────────────────────────────
#  CI
# ── Xibalbá · Client ──────────────────────────────────────────
#  CI

[doc('Format Client code')]
[group('CI')]
fmt:
    deno fmt
    @echo "✓ Client code formatted"

[doc('Lint Client code')]
[group('CI')]
lint:
    deno lint .
    @echo "✓ Client code linted"

[doc('Type-check Client workspace')]
[group('CI')]
typecheck:
    deno check .
    @echo "✓ Client type-checked"

[doc('Full client quality gate')]
[group('CI')]
quality: fmt lint typecheck
    @echo "✓ Client quality checks passed"

# Build

[doc('Sync SvelteKit and Build SDK')]
[group('Build')]
sync-ui:
    # Ensure SvelteKit syncs the generated tsconfig that the apps extend
    deno task --cwd sdk/ui prepare
    deno task --cwd apps/agent check
    deno task --cwd apps/explorer check
    deno task --cwd apps/vision check

[doc('Build Client')]
[group('Build')]
build: sync-ui
    @echo "✓ Client built and synced successfully"

[doc('Run the client in development mode')]
[group('Dev')]
run app=`ls apps/`:
    yog reborn --deep
    deno task --cwd sdk/ui prepare
    # todo: Add a way to run all apps at once
    # todo: Somehow orchestrate the apps to run in parallel
    deno task --cwd apps/{{ app }} dev

[doc('Test the client')]
[group('Dev')]
test:
    cd sdk/infrastructure && deno task test
    @echo "✓ Client tests passed"

# ── Deploy (Tauri) ─────────────────────────────────────

[doc('Build the Tauri app for production')]
[group('Deploy')]
deploy:
    @echo "✓ Tauri app built for production"
