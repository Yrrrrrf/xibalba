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
    # deno run -A npm:svelte-check
    -deno run -A npm:svelte-check --tsconfig ./apps/explorer/tsconfig.json
    -deno run -A npm:svelte-check --tsconfig ./apps/vision/tsconfig.json
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
    # 1. Compile Paraglide
    deno run -A npm:@inlang/paraglide-js compile --project ./sdk/ui/src/i18n/project.inlang --outdir ./sdk/ui/src/i18n/paraglide
    # 2. Verify output exists
    test -f sdk/ui/src/i18n/paraglide/messages.js || exit 1
    # 3. Remove stale .gitignore
    # rm -f sdk/ui/src/i18n/paraglide/.gitignore
    # 4. SvelteKit sync
    bun run --cwd sdk/ui prepare

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
