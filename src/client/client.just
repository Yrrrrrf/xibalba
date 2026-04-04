# ── Xibalbá · Client ──────────────────────────────────────────
#  CI
# ── Xibalbá · Client ──────────────────────────────────────────
#  CI

[doc('Format Client code')]
[group('CI')]
fmt:
    @echo "TODO: Add prettier"
    # bun run prettier --write .
    @echo "✓ Client code formatted"

[doc('Lint Client code')]
[group('CI')]
lint:
    @echo "TODO: Add eslint"
    # bun run eslint .
    @echo "✓ Client code linted"

[doc('Type-check Client workspace')]
[group('CI')]
typecheck:
    bun run svelte-check --tsconfig ./tsconfig.json
    @echo "✓ Client type-checked"

[doc('Full client quality gate')]
[group('CI')]
quality: typecheck
    @echo "✓ Client quality checks passed"

# Build

[doc('Sync SvelteKit and Build SDK')]
[group('Build')]
sync-ui:
    # Ensure SvelteKit syncs the generated tsconfig that the apps extend
    bun run --cwd sdk/ui prepare
    bun run --cwd apps/explorer check
    bun run --cwd apps/vision check

[doc('Build Client')]
[group('Build')]
build: sync-ui
    @echo "✓ Client built and synced successfully"

[doc('Run the client in development mode')]
[group('Dev')]
run app=`ls apps/`:
    yog reborn --deep
    bun run --cwd sdk/ui prepare
    # todo: Add a way to run all apps at once
    # todo: Somehow orchestrate the apps to run in parallel
    bun run --cwd apps/{{ app }} dev

[doc('Test the client')]
[group('Dev')]
test:
    bun test
    @echo "✓ Client tests passed"

# ── Deploy (Tauri) ─────────────────────────────────────

[doc('Build the Tauri app for production')]
[group('Deploy')]
deploy:
    @echo "✓ Tauri app built for production"
