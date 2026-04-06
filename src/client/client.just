# ── Xibalbá · Client ──────────────────────────────────────────
#  CI

[doc('Format Client code')]
[group('CI')]
fmt:
    deno fmt .
    @echo "✓ Client code formatted"

[doc('Lint Client code')]
[group('CI')]
lint:
    deno lint .
    @echo "✓ Client code linted"

[doc('Type-check Client workspace')]
[group('CI')]
typecheck:
    -bunx svelte-check --tsconfig ./apps/explorer/tsconfig.json
    -bunx svelte-check --tsconfig ./apps/vision/tsconfig.json
    # todo: Add a svelte-check for the sdk/ui
    # deno check .
    @echo "✓ Client type-checked"

[doc('Full client quality gate')]
[group('CI')]
quality: typecheck
    @echo "✓ Client quality checks passed"

# Build

[doc('Sync SvelteKit and Build SDK')]
[group('Build')]
sync-ui:
    # Compile Paraglide
    deno run -A npm:@inlang/paraglide-js compile --project ./sdk/ui/src/i18n/project.inlang --outdir ./sdk/ui/src/i18n/paraglide
    # SvelteKit sync
    bun run --cwd sdk/ui svelte-kit sync
    # bun run --cwd apps/explorer svelte-kit sync
    # bun run --cwd apps/vision svelte-kit sync

[doc('Build Client')]
[group('Build')]
build: sync-ui
    @echo "✓ Client built and synced successfully"

[doc('Run the client in development mode')]
[group('Dev')]
run app=`ls apps/`: sync-ui
    yog reborn --deep
    # todo: Add a way to run all apps at once
    # todo: Somehow orchestrate the apps to run in parallel
    bun run --cwd apps/{{ app }} vite dev --host

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
