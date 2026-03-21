#!/usr/bin/env bash
# =============================================================================
# GROUP F — Full-text search
# GROUP G — Reference integrity (ON DELETE REJECT)
# GROUP H — Seed data verification
# =============================================================================

# ── GROUP F — Full-text search ────────────────────────────────────────────────

# F1: title search
RES=$(run_query "SELECT name FROM item WHERE name @@ 'Laptop';")
if echo "$RES" | grep -qi 'Laptop'; then
    pass "F1 · Full-text search on name: 'Laptop' hits"
else
    fail "F1 · Full-text search for 'Laptop' should return items" "$RES"
fi

# ── GROUP G — Reference integrity ────────────────────────────────────────────

# G1: cannot delete a location that an item uses
RES=$(run_query "DELETE location:cdmx_center;")
if echo "$RES" | grep -qiE 'reject|reference|error|cannot'; then
    pass "G1 · ON DELETE REJECT: cannot delete location used by item"
else
    fail "G1 · Deleting a referenced location should be rejected" "$RES"
fi

# ── GROUP H — Seed data verification ─────────────────────────────────────────

# H1: user count
RES=$(run_query "SELECT count() FROM user GROUP ALL;")
if echo "$RES" | grep -qE '"count":5'; then
    pass "H1 · Users seeded (5 records)"
else
    fail "H1 · Expected 5 users" "$RES"
fi

# H2: items count
RES=$(run_query "SELECT count() FROM item GROUP ALL;")
if echo "$RES" | grep -qE '"count":3'; then
    pass "H2 · Items seeded (3 records)"
else
    fail "H2 · Expected 3 items" "$RES"
fi

# H3: ACID transaction (Transfer)
run_query "BEGIN TRANSACTION; UPDATE item:laptop_01 SET quantity -= 2; UPDATE item:laptop_02 SET quantity += 2; COMMIT TRANSACTION;" > /dev/null
RES=$(run_query "SELECT quantity FROM item:laptop_01;")
if echo "$RES" | grep -q '46'; then
    pass "H3 · ACID transaction: Transfer quantities correctly"
else
    fail "H3 · Transaction did not commit correctly" "$RES"
fi
