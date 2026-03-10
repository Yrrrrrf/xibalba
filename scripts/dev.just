[group('Dev')]
[doc('Run all services concurrently')]
dev:
    just serve & just preview
    @echo "All services running"

[group('Dev')]
[doc('Start the server in dev mode')]
[working-directory('src/server')]
serve:
    docker compose up

[group('Dev')]
[doc('Start the client in dev mode')]
[working-directory('src/client')]
preview:
    deno task dev
