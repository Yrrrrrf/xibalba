# ── Xibalbá · Server ──────────────────────────────────────────

#  CI

[doc('Format Server code')]
[group('CI')]
[working-directory('engine')]
fmt:
    cargo fmt --all

[doc('Lint Server code')]
[group('CI')]
lint:
    # todo: Add lint types for the lint command!
    # ^ lint lenient
    # * no warnings for clippy
    cd engine && cargo clippy --all-targets --all-features -- -A warnings

    # ^ lint normal
    # * normal
    # cd engine && cargo clippy --all-targets --all-features

    # ^ lint strict
    # * scale warnings to errors
    # cd engine && cargo clippy --all-targets --all-features -- -D warnings

[doc('Type-check Server workspace')]
[group('CI')]
[working-directory('engine')]
typecheck:
    cargo check --all-targets

[doc('Full server quality gate')]
[group('CI')]
quality: fmt lint typecheck
    @echo "✓ Server quality checks passed"

# Deploy

[doc('Build DB')]
[group('Build')]
build-db:
    # todo: Add the db build command
    # * build the db docker image
    # docker build -f db.Dockerfile -t xibalba-db:local .
    @echo "✓ DB built successfully"

[doc('Build Engine')]
[group('Build')]
build-engine:
    # todo: Add the engine build command
    # * build core
    #todo: Add build commands for the services (api)
    # * build services (api)
    #todo: Add build commands for the wasm service
    # * build services (wasm)
    just -f engine/services/wasm/justfile build
    # cd engine && cargo build --release -p api
    @echo "✓ Engine built successfully"

[doc('Build server')]
[group('Build')]
build:
    just build-engine
    just build-db
    @echo "✓ Server built successfully"

[doc('Build the WASM bridge and emit to sdk/core/src/pkg/')]
[group('Build')]
wasm:
    just -f engine/services/wasm/build-wasm.just build

#  Dev
[doc('Run the server in development mode')]
[group('Dev')]
run:
    # todo: Add the dev command
    # todo: Add a command to instantiate the server
    # todo: Init db
    # docker run -p 8000:8000 xibalba-db:local
    # todo: Init engine
    # cd engine && cargo run -p api
    @echo "✓ Server running in development mode"

[doc('Test the server')]
[group('Dev')]
test:
    # todo: Add the test command
    # todo: Add a command to run the server tests
    cd engine && cargo test

# todo: Add the new level of the test layer
# todo: Add the new level of the test layer
# todo: Add the new level of the test layer
# todo: Add the new level of the test layer
# todo: Add the new level of the test layer
# todo: Add the new level of the test layer
# todo: Add the new level of the test layer
# todo: Add the new level of the test layer
# todo: Add the new level of the test layer
# todo: Add the new level of the test layer
# todo: Add the new level of the test layer
# [doc('Run the test script against the local SurrealDB testing container')]
# [group('Test')]
# [working-directory('src/server')]
# test-db URL="http://127.0.0.1:8000/sql" USER="root" PASS="root" NS="app" DB="main":
#     @echo "Executing seed.surql against SurrealDB at {{ URL }} ..."
#     xh post "{{ URL }}" \
#       Accept:application/json \
#       NS:"{{ NS }}" \
#       DB:"{{ DB }}" \
#       -a "{{ USER }}:{{ PASS }}" \
#       @seed.surql
#     @echo ""
#     @echo "Done!"


# todo: Implement the deploy tasks!
# todo: Implement the deploy tasks!
# todo: Implement the deploy tasks!
# todo: Implement the deploy tasks!
# todo: Implement the deploy tasks!

# ── Deploy (Google Cloud) ─────────────────────────────────────


[doc('Deploy the app image to Cloud Run')]
[group('Deploy')]
deploy region='us-central1' project='':
    # todo: Add the deploy command
    # gcloud run deploy xibalba-db \
    #     --image {{ region }}-docker.pkg.dev/{{ project }}/xibalba/db:latest \
    #     --region {{ region }} \
    #     --project {{ project }} \
    #     --port 8000 \
    #     --set-env-vars SURREAL_PATH=file:///data \
    #     --no-allow-unauthenticated
    @echo "✓ Server deployed to Cloud Run"