[doc('Placeholder: System health check')]
[group('Test')]
test-health:
    @echo "TODO: Implement sys-health"

[doc('Test the server')]
[group('Test')]
test-server:
    just test-db

[doc('Test the client')]
[group('Test')]
[working-directory('src/client')]
test-client:
    deno test

[doc('Run the test script against the local SurrealDB testing container')]
[group('Test')]
[working-directory('src/server')]
test-db URL="http://127.0.0.1:8000/sql" USER="root" PASS="root" NS="app" DB="main":
    @echo "Executing seed.surql against SurrealDB at {{ URL }} ..."
    xh post "{{ URL }}" \
      Accept:application/json \
      NS:"{{ NS }}" \
      DB:"{{ DB }}" \
      -a "{{ USER }}:{{ PASS }}" \
      @seed.surql
    @echo ""
    @echo "Done!"

[doc('Run all tests')]
[group('Test')]
test-all: test-server test-client
    @echo "All tests passed"
