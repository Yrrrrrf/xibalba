-- 1. NAMESPACE & DATABASE
USE NS app DB main;

-- 2. FUNCTION DEFINITIONS
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

-- 3. TABLE DEFINITIONS
DEFINE TABLE user SCHEMAFULL
    PERMISSIONS
        FOR select, update WHERE id = $auth.id OR $auth.role = 'admin'
        FOR create, delete WHERE $auth.role = 'admin';

DEFINE TABLE session SCHEMAFULL;

DEFINE TABLE category SCHEMAFULL;

DEFINE TABLE location SCHEMAFULL
    PERMISSIONS
        FOR select WHERE $auth.role = 'admin' OR id IN (SELECT VALUE ->manages->location FROM $auth);

DEFINE TABLE item SCHEMAFULL
    PERMISSIONS
        FOR select WHERE is_active = true OR $auth.role != 'viewer'
        FOR update, delete WHERE $auth.role = 'admin' OR location IN (SELECT VALUE ->manages->location FROM $auth);

DEFINE TABLE movement SCHEMAFULL
    PERMISSIONS
        FOR select FULL
        FOR create, update, delete NONE;

DEFINE TABLE transfer SCHEMAFULL;
DEFINE TABLE document_request SCHEMAFULL;
DEFINE TABLE activity SCHEMAFULL;
DEFINE TABLE snapshot SCHEMAFULL;
DEFINE TABLE locale_string SCHEMAFULL;

-- 4. FIELD DEFINITIONS
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

-- 5. INDEX DEFINITIONS
DEFINE INDEX user_email ON user FIELDS email UNIQUE;
DEFINE INDEX user_username ON user FIELDS username UNIQUE;
DEFINE INDEX session_token ON session FIELDS token UNIQUE;
DEFINE INDEX category_name ON category FIELDS name UNIQUE;
DEFINE INDEX category_slug ON category FIELDS slug UNIQUE;
DEFINE INDEX item_sku ON item FIELDS sku UNIQUE;
DEFINE INDEX item_barcode ON item FIELDS barcode UNIQUE;
DEFINE ANALYZER ascii_bm25 TOKENIZERS blank,class,camel,punct FILTERS ascii,lowercase;
DEFINE INDEX item_name_idx ON item FIELDS name FULLTEXT ANALYZER ascii_bm25 BM25;
DEFINE INDEX item_desc_idx ON item FIELDS description FULLTEXT ANALYZER ascii_bm25 BM25;
DEFINE INDEX activity_occurred_idx ON activity FIELDS occurred_at;
DEFINE INDEX locale_idx ON locale_string FIELDS key, locale UNIQUE;

-- 6. EVENT DEFINITIONS
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

-- 7. SEED — USERS
CREATE user:admin1 SET username='admin1', email='admin1@xibalba.com', password_hash='', role='admin', locale='en', preferred_currency='USD';
CREATE user:agent1 SET username='agent1', email='agent1@xibalba.com', password_hash='', role='agent', locale='es', preferred_currency='MXN';
CREATE user:agent2 SET username='agent2', email='agent2@xibalba.com', password_hash='', role='agent', locale='en', preferred_currency='USD';
CREATE user:viewer1 SET username='viewer1', email='viewer1@xibalba.com', password_hash='', role='viewer', locale='ja', preferred_currency='JPY';
CREATE user:viewer2 SET username='viewer2', email='viewer2@xibalba.com', password_hash='', role='viewer', locale='es', preferred_currency='MXN';

-- 8. SEED — CATEGORIES
CREATE category:electronics SET name='Electronics', slug='electronics';
CREATE category:laptops SET name='Laptops', slug='laptops', parent=category:electronics;
CREATE category:monitors SET name='Monitors', slug='monitors', parent=category:electronics;
CREATE category:furniture SET name='Furniture', slug='furniture';

-- 9. SEED — LOCATIONS
CREATE location:cdmx_center SET name='CDMX Downtown', address='Centro 1', city='Mexico City', country='MXN', coordinates={ type: 'Point', coordinates: [-99.1332, 19.4326] };
CREATE location:cdmx_south SET name='CDMX South', address='Pedregal', city='Mexico City', country='MXN', coordinates={ type: 'Point', coordinates: [-99.1992, 19.3000] };
CREATE location:ny_warehouse SET name='NY Warehouse', address='Brooklyn', city='New York', country='USA', coordinates={ type: 'Point', coordinates: [-73.935242, 40.730610] };
CREATE location:tokyo_hub SET name='Tokyo Hub', address='Shibuya', city='Tokyo', country='JPN', coordinates={ type: 'Point', coordinates: [139.6917, 35.6895] };

-- 10. SEED — ITEMS
CREATE item:laptop_01 SET name='Pro Laptop 15', sku='LAP-001', category=category:laptops, location=location:cdmx_center, quantity=50, min_quantity=10, price=999.00dec, cost=700.00dec, currency='USD', weight_kg=1.5, image_urls=[], tags=['apple', 'macbook'], is_active=true;
CREATE item:laptop_02 SET name='Air Laptop 13', sku='LAP-002', category=category:laptops, location=location:ny_warehouse, quantity=5, min_quantity=10, price=899.00dec, cost=650.00dec, currency='USD', weight_kg=1.2, image_urls=[], tags=['laptop'], is_active=true;
CREATE item:monitor_01 SET name='Ultra Monitor', sku='MON-001', category=category:monitors, location=location:cdmx_south, quantity=0, min_quantity=5, price=299.00dec, cost=200.00dec, currency='USD', weight_kg=4.0, image_urls=[], tags=['display'], is_active=true;

-- 11. SEED — GRAPH RELATIONS
RELATE user:agent1->manages->location:cdmx_center;
RELATE user:agent1->manages->location:cdmx_south;
RELATE user:agent2->manages->location:ny_warehouse;
RELATE user:agent2->manages->location:tokyo_hub;

-- 12. SEED — INITIAL MOVEMENTS
CREATE movement SET item=item:laptop_01, performed_by=user:admin1, delta=50, qty_before=0, qty_after=50, reason='initial';
CREATE movement SET item=item:laptop_02, performed_by=user:admin1, delta=5, qty_before=0, qty_after=5, reason='initial';
CREATE movement SET item=item:monitor_01, performed_by=user:admin1, delta=0, qty_before=0, qty_after=0, reason='initial';

-- 13. SEED — WATCHES
RELATE user:agent1->watches->item:laptop_01 SET alert_on=['low_stock'];
RELATE user:agent2->watches->item:laptop_02 SET alert_on=['movement'];
RELATE user:viewer1->watches->item:monitor_01 SET alert_on=['movement', 'low_stock'];

-- 14. SEED — SNAPSHOTS
CREATE snapshot SET location=location:cdmx_center, total_items=1, total_quantity=50, total_value=49950.00dec, low_stock_count=0;
