#!/usr/bin/env bash
# =============================================================================
# GROUP A — Schema integrity (ASSERT validations)
# GROUP B — Unique indexes
# =============================================================================

# ── GROUP A — Schema integrity ────────────────────────────────────────────────

# A1: invalid email rejected
RES=$(run_query "CREATE user SET email='not-an-email', username='bad', password_hash='x', role='viewer', locale='en', preferred_currency='USD';")
if echo "$RES" | grep -qiE 'assert|conform|email|error'; then
    pass "A1 · Invalid email rejected by ASSERT"
else
    fail "A1 · Invalid email should be rejected" "$RES"
fi

# A2: invalid role rejected
RES=$(run_query "CREATE user SET email='x@x.com', username='badrole', password_hash='x', role='hacker', locale='en', preferred_currency='USD';")
if echo "$RES" | grep -qiE 'assert|conform|error'; then
    pass "A2 · Invalid role rejected by ASSERT"
else
    fail "A2 · Invalid role 'hacker' should be rejected" "$RES"
fi

# A3: negative quantity rejected on item
RES=$(run_query "CREATE item:neg_qty SET name='Neg', sku='NEG-001', category=category:electronics, location=location:cdmx_center, quantity=-1, min_quantity=0, price=10.00dec, cost=5.00dec, currency='USD', image_urls=[], tags=[], is_active=true;")
if echo "$RES" | grep -qiE 'assert|conform|error'; then
    pass "A3 · Negative quantity rejected by ASSERT"
else
    fail "A3 · Negative quantity should be rejected" "$RES"
fi

# A4: invalid SKU format rejected
RES=$(run_query "CREATE item SET name='Bad SKU', sku='bad-sku', category=category:electronics, location=location:cdmx_center, quantity=1, min_quantity=0, price=10.00dec, cost=5.00dec, currency='USD', image_urls=[], tags=[], is_active=true;")
if echo "$RES" | grep -qiE 'assert|conform|error'; then
    pass "A4 · Invalid SKU format rejected by ASSERT"
else
    fail "A4 · SKU 'bad-sku' should be rejected" "$RES"
fi

# ── GROUP B — Unique indexes ──────────────────────────────────────────────────

# B1: duplicate user email
RES=$(run_query "CREATE user SET email='admin1@xibalba.com', username='admin_dupe', password_hash='x', role='admin', locale='en', preferred_currency='USD';")
if echo "$RES" | grep -qiE 'already contains|unique|index|error'; then
    pass "B1 · Duplicate user email rejected by UNIQUE index"
else
    fail "B1 · Duplicate email should be blocked" "$RES"
fi

# B2: duplicate item SKU
RES=$(run_query "CREATE item:dup_sku SET name='Dup', sku='LAP-001', category=category:laptops, location=location:cdmx_center, quantity=1, min_quantity=0, price=10.00dec, cost=5.00dec, currency='USD', image_urls=[], tags=[], is_active=true;")
if echo "$RES" | grep -qiE 'already contains|unique|index|error'; then
    pass "B2 · Duplicate item SKU rejected by UNIQUE index"
else
    fail "B2 · Duplicate SKU should be blocked" "$RES"
fi
