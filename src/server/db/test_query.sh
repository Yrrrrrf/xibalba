#!/usr/bin/env bash

URL="http://127.0.0.1:8000/sql"
USER="root"
PASS="super_secret_dev_pass_override_me"
NS="app"
DB="main"

function run_query() {
    xh post "$URL" Accept:application/json surreal-ns:"$NS" surreal-db:"$DB" -a "$USER:$PASS" --raw "$1" 2>/dev/null
}

FAILS=0

echo "=== GROUP A: Schema integrity ==="
echo "Testing missing SKU insertion..."
RES=$(run_query "CREATE item SET name='No SKU', category=category:electronics, location=location:cdmx_center, quantity=1, min_quantity=0, price=10.00dec, cost=5.00dec, currency='USD', image_urls=[], tags=[], is_active=true;")
if echo "$RES" | grep -qiE 'coerce|expected.*string'; then
    echo "✔ Passed missing SKU check"
else
    echo "❌ Failed: allowed missing SKU!"
    echo "$RES"
    FAILS=$((FAILS + 1))
fi

echo "Testing negative quantity..."
RES=$(run_query "CREATE item:neg_qty SET name='Neg', sku='NEG-001', category=category:electronics, location=location:cdmx_center, quantity=-1, min_quantity=0, price=10.00dec, cost=5.00dec, currency='USD', image_urls=[], tags=[], is_active=true;")
if echo "$RES" | grep -qi 'conform to'; then
    echo "✔ Passed negative quantity check"
else
    echo "❌ Failed: allowed negative quantity!"
    echo "$RES"
    FAILS=$((FAILS + 1))
fi

echo "=== GROUP B: Indexes ==="
echo "Testing duplicate SKU..."
RES=$(run_query "CREATE item:dup_sku SET name='Dup', sku='LAP-001', category=category:laptops, location=location:cdmx_center, quantity=1, min_quantity=0, price=10.00dec, cost=5.00dec, currency='USD', image_urls=[], tags=[], is_active=true;")
if echo "$RES" | grep -qi 'already contains'; then
    echo "✔ Passed duplicate SKU check"
else
    echo "❌ Failed: allowed duplicate SKU!"
    echo "$RES"
    FAILS=$((FAILS + 1))
fi

echo "=== GROUP C: Computed fields ==="
RES=$(run_query "SELECT VALUE is_low_stock FROM item:monitor_01;")
if echo "$RES" | grep -q 'true'; then
    echo "✔ Passed is_low_stock computation"
else
    echo "❌ Failed: is_low_stock should be true for monitor_01"
    echo "$RES"
    FAILS=$((FAILS + 1))
fi

echo "=== GROUP F: Functions ==="
RES=$(run_query "RETURN fn::is_low_stock(item:monitor_01);")
if echo "$RES" | grep -q 'true'; then
    echo "✔ Passed fn::is_low_stock"
else
    echo "❌ Failed: fn::is_low_stock did not return true"
    echo "$RES"
    FAILS=$((FAILS + 1))
fi

echo "========================="

echo "=== GROUP D: Events ==="
run_query "UPDATE item:laptop_01 SET quantity = 48;" > /dev/null
RES=$(run_query "SELECT * FROM movement WHERE item = item:laptop_01 AND reason = 'adjustment';")
if echo "$RES" | grep -q '"delta":-2'; then
    echo "✔ Passed event movement creation"
else
    echo "❌ Failed: event movement not created correctly!"
    echo "$RES"
    FAILS=$((FAILS + 1))
fi

echo "=== GROUP E: Graph traversal ==="
RES=$(run_query "SELECT ->manages->location.name AS locations FROM user:agent1;")
if echo "$RES" | grep -qi 'CDMX Downtown'; then
    echo "✔ Passed forward graph traversal"
else
    echo "❌ Failed: forward graph traversal did not return correct location!"
    echo "$RES"
    FAILS=$((FAILS + 1))
fi

echo "=== GROUP H: Transactions ==="
run_query "BEGIN TRANSACTION; UPDATE item:laptop_01 SET quantity -= 2; UPDATE item:laptop_02 SET quantity += 2; COMMIT TRANSACTION;" > /dev/null
RES=$(run_query "SELECT quantity FROM item:laptop_01;")
if echo "$RES" | grep -q '46'; then
    echo "✔ Passed ACID transactions"
else
    echo "❌ Failed: transaction did not commit correctly!"
    echo "$RES"
    FAILS=$((FAILS + 1))
fi

echo "========================="
if [ "$FAILS" -eq 0 ]; then
    echo "All basic smoke tests passed! 🎉"
    exit 0
else
    echo "$FAILS test(s) failed."
    exit 1
fi
