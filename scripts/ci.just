[group('CI')]
[doc('Check formatting and linting')]
quality:
    @echo "Checking code quality..."
    deno fmt .
    deno lint .

[group('CI')]
[doc('Full CI pipeline')]
ci: quality build test-all
    @echo "CI passed ✓"
