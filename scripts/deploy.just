[doc('Build all services')]
[group('Deploy')]
build: build-server build-client

[private]
build-server:
    cd src/server/
    just build

[private]
build-client:
    cd src/client/
    just build

[doc('Run on local machine (based on build output)')]
[group('Deploy')]
run-local: build
    # todo: Add a run local setup

[doc('Run on remote machine via SSH')]
[group('Deploy')]
run-remote:
    # todo: Add a remote setup
    @echo "Deploying remotely..."
    @echo "Error: Remote deployment script not yet configured."
    exit 1
