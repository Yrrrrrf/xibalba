-- =============================================================================
-- Xibalbá — Event Definitions
-- =============================================================================

DEFINE EVENT stock_movement ON item WHEN $event = "UPDATE" AND $before.quantity != $after.quantity THEN (
    CREATE movement SET 
        item = $after.id,
        performed_by = $auth.id OR user:admin1,
        delta = $after.quantity - $before.quantity,
        qty_before = $before.quantity,
        qty_after = $after.quantity,
        reason = 'adjustment',
        note = 'Auto trigger',
        recorded_at = time::now()
);

DEFINE EVENT document_status_change ON document_request WHEN $event = "UPDATE" AND $after.status = 'completed' THEN (
    CREATE activity SET
        actor = $after.requested_by,
        action = 'document.generated',
        target_table = 'document_request',
        target_id = $after.id,
        meta = { },
        occurred_at = time::now()
);
