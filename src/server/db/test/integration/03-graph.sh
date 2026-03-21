#!/usr/bin/env bash
# =============================================================================
# GROUP E — Graph traversal
# =============================================================================

# E1: forward — agent manages locations
RES=$(run_query "SELECT ->manages->location.name AS territories FROM user:agent1;")
if echo "$RES" | grep -qi 'CDMX Downtown'; then
    pass "E1 · Forward traversal: agent1 ->manages-> location"
else
    fail "E1 · agent1 should manage 'CDMX Downtown' location" "$RES"
fi

# E2: reverse — find agents for a location
RES=$(run_query "SELECT <-manages<-user.username AS managers FROM location:cdmx_center;")
if echo "$RES" | grep -qi 'agent1'; then
    pass "E2 · Reverse traversal: location:cdmx_center <-manages<- user"
else
    fail "E2 · agent1 should appear as manager of cdmx_center" "$RES"
fi

# E3: watches relation
RES=$(run_query "SELECT ->watches->item.sku AS watched FROM user:agent1;")
if echo "$RES" | grep -qi 'LAP-001'; then
    pass "E3 · Forward traversal: agent1 ->watches-> item"
else
    fail "E3 · agent1 should watch LAP-001" "$RES"
fi
