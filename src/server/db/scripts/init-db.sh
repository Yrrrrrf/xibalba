#!/bin/sh
# =============================================================================
# Xibalbá — SurrealDB Initialization Runner
# =============================================================================
# Discovers and executes all *.surql files under /init in numeric order.
# Provides colored, per-file output with ✓/✗ indicators.
# =============================================================================
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
GRAY='\033[0;90m'
NC='\033[0m'
BOLD='\033[1m'
CHECK='✓'
CROSS='✗'
ARROW='→'
BULLET='•'

URL="${SURREAL_URL:-http://localhost:8000/sql}"
SURREAL_USER="${SURREAL_USER:-root}"
SURREAL_PASS="${SURREAL_PASS:-root}"
NS="${SURREAL_NS:-app}"
DB="${SURREAL_DB:-main}"

# ---------------------------------------------------------------------------
run_surql() {
    curl -sf -X POST "$URL" \
        -H "Accept: application/json" \
        -H "surreal-ns: $NS" \
        -H "surreal-db: $DB" \
        -u "$SURREAL_USER:$SURREAL_PASS" \
        --data-binary "@$1"
}

execute_surql_file() {
    local file="$1"
    local filename
    filename=$(basename "$file")
    local dirname
    dirname=$(basename "$(dirname "$file")")
    printf "\t${GRAY}${BULLET} %s/%s${NC} " "$dirname" "$filename"
    if run_surql "$file" > /dev/null 2>&1; then
        printf "${GREEN}${CHECK}${NC}\n"
    else
        printf "${RED}${CROSS}${NC}\n"
        printf "${RED}    Failed: %s${NC}\n" "$file"
        return 1
    fi
}

# ---------------------------------------------------------------------------
main() {
    printf "${BOLD}Xibalbá — SurrealDB Initialization${NC}\n\n"
    local base="/init"

    for dir in $(find "$base" -mindepth 1 -maxdepth 1 -type d | sort); do
        printf "${BLUE}${ARROW} %s${NC}\n" "$(basename "$dir")"
        for f in $(find "$dir" -name "*.surql" | sort); do
            execute_surql_file "$f"
        done
        printf "\n"
    done

    printf "${GREEN}${CHECK} Initialization complete — %s/%s${NC}\n\n" "$NS" "$DB"
}

main
