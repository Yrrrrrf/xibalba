set dotenv-load := true

[doc('Run project in development mode')]
[group('Dev')]
run:
    just -f server/server.just run
    just -f client/client.just run

[doc('Test the entire project')]
[group('Dev')]
test:
    just -f server/server.just test
    just -f client/client.just test
