#!/usr/bin/env bash
# =============================================================================
# GROUP D — Events (live DB, side effects)
# =============================================================================

# D1: stock_movement — movement recorded on quantity UPDATE
run_query "UPDATE item:laptop_01 SET quantity = 48;" > /dev/null
sleep 1 # allow event to fire
RES=$(run_query "SELECT delta, reason FROM movement WHERE item = item:laptop_01 AND reason = 'adjustment';")
if echo "$RES" | grep -q '"delta":-2'; then
    pass "D1 · stock_movement event: movement record created on UPDATE"
else
    fail "D1 · A movement record with delta -2 should exist" "$RES"
fi

# D2: document_status_change — activity recorded on 'completed' status
RES=$(run_query "
    CREATE document_request SET
        requested_by = user:agent1,
        template = 'inventory_report',
        parameters = {},
        status = 'pending';
")
DOC_ID=$(echo "$RES" | grep -oE '"id":"[^"]*"' | head -1 | cut -d'"' -f4)
run_query "UPDATE $DOC_ID SET status = 'completed';" > /dev/null
sleep 1
RES2=$(run_query "SELECT action FROM activity WHERE target_id = $DOC_ID;")
if echo "$RES2" | grep -q 'document.generated'; then
    pass "D2 · document_status_change event: activity record created on 'completed'"
else
    fail "D2 · An activity record should be auto-created" "$RES2"
fi
