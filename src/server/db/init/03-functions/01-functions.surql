-- =============================================================================
-- Xibalbá — Function Definitions
-- =============================================================================

DEFINE FUNCTION fn::is_low_stock($item: record<item>) {
    RETURN $item.quantity <= $item.min_quantity;
};

DEFINE FUNCTION fn::t($key: string, $locale: string) {
    LET $trans = (SELECT VALUE value FROM locale_string WHERE key = $key AND locale = $locale LIMIT 1);
    IF array::len($trans) > 0 {
        RETURN $trans[0];
    } ELSE {
        LET $fallback = (SELECT VALUE value FROM locale_string WHERE key = $key AND locale = 'en' LIMIT 1);
        RETURN array::first($fallback) OR NONE;
    };
};

DEFINE FUNCTION fn::take_snapshot($loc_id: record<location>) {
    LET $items = (SELECT quantity, total_value, is_low_stock FROM item WHERE location = $loc_id);
    LET $total_items = array::len($items);
    LET $total_quantity = math::sum($items.quantity);
    LET $total_value = math::sum($items.total_value);
    
    LET $low_stock_count = array::len(
        (SELECT * FROM $items WHERE is_low_stock = true)
    );

    CREATE snapshot SET 
        location = $loc_id,
        total_items = $total_items,
        total_quantity = $total_quantity,
        total_value = $total_value,
        low_stock_count = $low_stock_count,
        snapped_at = time::now();
};
