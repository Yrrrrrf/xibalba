#!/bin/sh
set -e

echo "Starting SurrealDB..."
surreal start --log ${SURREAL_LOG:-info} --user ${SURREAL_USER:-root} --pass ${SURREAL_PASS} --bind 0.0.0.0:${SURREAL_PORT:-8000} ${SURREAL_PATH:-memory} &
PID=$!

if [ "${SEED_ON_START:-true}" = "true" ]; then
    echo "Waiting for SurrealDB to accept connections..."
    # The official image doesn't usually have curl, so we can try to use surreal sql or just sleep
    sleep 3
    for i in 1 2 3 4 5; do
        if surreal sql --endpoint http://127.0.0.1:${SURREAL_PORT:-8000} -u ${SURREAL_USER:-root} -p ${SURREAL_PASS} --ns ${SURREAL_NS:-dev} --db ${SURREAL_DB:-main} -q 'RETURN true;' > /dev/null 2>&1; then
            break
        fi
        sleep 2
    done
    
    echo "Applying seed.surql..."
    surreal import --endpoint http://127.0.0.1:${SURREAL_PORT:-8000} -u ${SURREAL_USER:-root} -p ${SURREAL_PASS} --ns ${SURREAL_NS:-dev} --db ${SURREAL_DB:-main} /seed.surql
    echo "Seeding completed."
fi

wait $PID
