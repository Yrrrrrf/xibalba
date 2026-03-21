-- =============================================================================
-- Xibalbá — Field Definitions
-- =============================================================================

-- user
DEFINE FIELD username ON user TYPE string;
DEFINE FIELD email ON user TYPE string ASSERT string::is_email($value);
DEFINE FIELD password_hash ON user TYPE string;
DEFINE FIELD role ON user TYPE string ASSERT $value IN ['admin', 'agent', 'viewer'];
DEFINE FIELD display_name ON user TYPE option<string>;
DEFINE FIELD avatar_url ON user TYPE option<string>;
DEFINE FIELD locale ON user TYPE string;
DEFINE FIELD preferred_currency ON user TYPE string;
DEFINE FIELD created_at ON user TYPE datetime DEFAULT time::now();
DEFINE FIELD updated_at ON user TYPE datetime DEFAULT time::now();

-- session
DEFINE FIELD user ON session TYPE record<user> REFERENCE ON DELETE CASCADE;
DEFINE FIELD token ON session TYPE string;
DEFINE FIELD user_agent ON session TYPE string;
DEFINE FIELD ip_address ON session TYPE string;
DEFINE FIELD expires_at ON session TYPE datetime;
DEFINE FIELD created_at ON session TYPE datetime DEFAULT time::now();

-- category
DEFINE FIELD name ON category TYPE string;
DEFINE FIELD description ON category TYPE option<string>;
DEFINE FIELD slug ON category TYPE string;
DEFINE FIELD parent ON category TYPE option<record<category>>;
DEFINE FIELD path ON category VALUE 
    IF parent != NONE THEN parent.path + ' > ' + name
    ELSE name END;
DEFINE FIELD created_at ON category TYPE datetime DEFAULT time::now();

-- location
DEFINE FIELD name ON location TYPE string;
DEFINE FIELD address ON location TYPE string;
DEFINE FIELD city ON location TYPE string;
DEFINE FIELD country ON location TYPE string;
DEFINE FIELD coordinates ON location TYPE geometry<point>;
DEFINE FIELD capacity ON location TYPE option<int>;
DEFINE FIELD item_count ON location VALUE (SELECT VALUE count() FROM item WHERE location = $parent.id)[0];
DEFINE FIELD is_at_capacity ON location VALUE capacity != NONE AND item_count >= capacity;
DEFINE FIELD notes ON location TYPE option<string>;
DEFINE FIELD created_at ON location TYPE datetime DEFAULT time::now();

-- item
DEFINE FIELD name ON item TYPE string;
DEFINE FIELD sku ON item TYPE string ASSERT $value = /^[A-Z]{3}-\d{3,4}$/;
DEFINE FIELD description ON item TYPE option<string>;
DEFINE FIELD barcode ON item TYPE option<string>;
DEFINE FIELD category ON item TYPE record<category> REFERENCE ON DELETE REJECT;
DEFINE FIELD location ON item TYPE record<location> REFERENCE ON DELETE REJECT;
DEFINE FIELD quantity ON item TYPE int ASSERT $value >= 0;
DEFINE FIELD min_quantity ON item TYPE int;
DEFINE FIELD price ON item TYPE decimal ASSERT $value >= 0dec;
DEFINE FIELD cost ON item TYPE decimal
    PERMISSIONS FOR select WHERE $auth.role != 'viewer';
DEFINE FIELD currency ON item TYPE string;
DEFINE FIELD weight_kg ON item TYPE option<decimal>;
DEFINE FIELD image_urls ON item TYPE array<string>;
DEFINE FIELD tags ON item TYPE array<string>;
DEFINE FIELD is_active ON item TYPE bool;
DEFINE FIELD is_low_stock ON item VALUE quantity <= min_quantity;
DEFINE FIELD total_value ON item VALUE <decimal>quantity * price;
DEFINE FIELD created_at ON item TYPE datetime DEFAULT time::now();
DEFINE FIELD updated_at ON item TYPE datetime DEFAULT time::now();

-- movement
DEFINE FIELD item ON movement TYPE record<item>;
DEFINE FIELD performed_by ON movement TYPE record<user>;
DEFINE FIELD delta ON movement TYPE int;
DEFINE FIELD qty_before ON movement TYPE int;
DEFINE FIELD qty_after ON movement TYPE int;
DEFINE FIELD reason ON movement TYPE string ASSERT $value IN ['purchase', 'sale', 'transfer', 'adjustment', 'return', 'damage', 'initial'];
DEFINE FIELD reference_id ON movement TYPE option<string>;
DEFINE FIELD note ON movement TYPE option<string>;
DEFINE FIELD recorded_at ON movement TYPE datetime DEFAULT time::now();

-- transfer
DEFINE FIELD item ON transfer TYPE record<item>;
DEFINE FIELD from_location ON transfer TYPE record<location>;
DEFINE FIELD to_location ON transfer TYPE record<location>;
DEFINE FIELD quantity ON transfer TYPE int;
DEFINE FIELD status ON transfer TYPE string ASSERT $value IN ['pending', 'in_transit', 'completed', 'cancelled'];
DEFINE FIELD initiated_by ON transfer TYPE record<user>;
DEFINE FIELD completed_by ON transfer TYPE option<record<user>>;
DEFINE FIELD initiated_at ON transfer TYPE datetime DEFAULT time::now();
DEFINE FIELD completed_at ON transfer TYPE option<datetime>;
DEFINE FIELD notes ON transfer TYPE option<string>;

-- document_request
DEFINE FIELD requested_by ON document_request TYPE record<user>;
DEFINE FIELD template ON document_request TYPE string ASSERT $value IN ['inventory_report', 'item_label', 'transfer_manifest'];
DEFINE FIELD parameters ON document_request TYPE object;
DEFINE FIELD status ON document_request TYPE string ASSERT $value IN ['pending', 'processing', 'completed', 'failed'];
DEFINE FIELD output_url ON document_request TYPE option<string>;
DEFINE FIELD error ON document_request TYPE option<string>;
DEFINE FIELD requested_at ON document_request TYPE datetime DEFAULT time::now();
DEFINE FIELD completed_at ON document_request TYPE option<datetime>;
DEFINE FIELD processing_time_ms ON document_request VALUE 
    IF completed_at != NONE THEN time::unix(completed_at) - time::unix(requested_at)
    ELSE NONE END;

-- activity
DEFINE FIELD actor ON activity TYPE record<user>;
DEFINE FIELD action ON activity TYPE string;
DEFINE FIELD target_table ON activity TYPE string;
DEFINE FIELD target_id ON activity TYPE record;
DEFINE FIELD meta ON activity TYPE option<object>;
DEFINE FIELD occurred_at ON activity TYPE datetime DEFAULT time::now();

-- snapshot
DEFINE FIELD location ON snapshot TYPE record<location>;
DEFINE FIELD total_items ON snapshot TYPE int;
DEFINE FIELD total_quantity ON snapshot TYPE int;
DEFINE FIELD total_value ON snapshot TYPE decimal;
DEFINE FIELD low_stock_count ON snapshot TYPE int;
DEFINE FIELD snapped_at ON snapshot TYPE datetime DEFAULT time::now();

-- locale_string
DEFINE FIELD key ON locale_string TYPE string;
DEFINE FIELD locale ON locale_string TYPE string;
DEFINE FIELD value ON locale_string TYPE string;
DEFINE FIELD updated_at ON locale_string TYPE datetime DEFAULT time::now();
