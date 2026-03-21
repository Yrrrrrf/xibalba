#!/usr/bin/env bash
# =============================================================================
# GROUP C — Computed fields
# =============================================================================

# C1: is_low_stock computed (quantity=0, min_quantity=5)
RES=$(run_query "SELECT is_low_stock FROM item:monitor_01;")
if echo "$RES" | grep -q 'true'; then
    pass "C1 · is_low_stock computed correctly for monitor_01"
else
    fail "C1 · is_low_stock should be true for monitor_01" "$RES"
fi

# C2: total_value computed (quantity * price)
RES=$(run_query "SELECT total_value FROM item:laptop_01;")
if echo "$RES" | grep -q '49950'; then
    pass "C2 · total_value computed correctly (50 * 999 = 49950)"
else
    fail "C2 · total_value should be 49950" "$RES"
fi

# C3: item_count on location (cdmx_center has 1 item)
RES=$(run_query "SELECT item_count FROM location:cdmx_center;")
if echo "$RES" | grep -q '1'; then
    pass "C3 · location.item_count computed correctly"
else
    fail "C3 · location.item_count should be 1" "$RES"
fi
