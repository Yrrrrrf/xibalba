[doc('Format all code')]
[group('CI')]
fmt:
    cd src/server/engine && cargo fmt --all
    cd src/client && deno fmt .

[doc('Lint all code')]
[group('CI')]
lint:
    cd src/server/engine && cargo clippy -- -D warnings
    cd src/client && deno lint 

[doc('Type-check client')]
[group('CI')]
typecheck:
    # todo: Add a correct ts + svelte typecheck on client
    # cd src/client && deno check src/**/*.ts
    @echo "Add client typecheck"
    cd src/server/engine && cargo check

[group('CI')]
[doc('Check formatting and linting')]
quality: fmt lint typecheck
    @echo "Quality checks passed ✓"

# todo: Add the imports to make it work the build-all and test-all tasks
# [group('CI')]
# [doc('Full CI pipeline')]
# ci: quality build-all test-all
#     @echo "CI passed ✓"
