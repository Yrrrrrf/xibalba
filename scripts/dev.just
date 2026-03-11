set dotenv-load := true

# loads .env automatically from project root

[doc('Start SurrealDB only')]
[group('Dev')]
dev-db:
    docker compose up db

[doc('Start API (watches Rust source)')]
[group('Dev')]
dev-api:
    cd src/server/engine && \
    cargo watch -x 'run --bin api'

[doc('Start Agent app')]
[group('Dev')]
dev-agent:
    cd src/client && deno task --filter agent dev

[doc('Start Explorer app')]
[group('Dev')]
dev-explorer:
    cd src/client && deno task --filter explorer dev

[doc('Start Vision app')]
[group('Dev')]
dev-vision:
    cd src/client && deno task --filter vision dev

[doc('Full local dev stack (tmux / parallel)')]
[group('Dev')]
dev: dev-db dev-api dev-agent
