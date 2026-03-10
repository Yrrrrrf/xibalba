# Build the client
[group("build")]
build:
    cd src/client/
    deno task build

# Initialize the server (development mode)
[group("dev")]
serve:
    cd src/server/
    deno task dev

# Initialize the client (preview mode)
[group("dev")]
preview: serve
    cd src/client/
    deno task preview

# Run all the services (client + server)
[group("dev")]
dev: serve preview
    echo "All services are running"

# podman or ci/cd related tasks
[group("ci")]
ci: build serve preview
    echo "All services are running"
