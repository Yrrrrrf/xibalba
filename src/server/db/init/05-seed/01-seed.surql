-- =============================================================================
-- Xibalbá — Seed Data
-- =============================================================================

-- 1. USERS
CREATE user:admin1 SET username='admin1', email='admin1@xibalba.com', password_hash='', role='admin', locale='en', preferred_currency='USD';
CREATE user:agent1 SET username='agent1', email='agent1@xibalba.com', password_hash='', role='agent', locale='es', preferred_currency='MXN';
CREATE user:agent2 SET username='agent2', email='agent2@xibalba.com', password_hash='', role='agent', locale='en', preferred_currency='USD';
CREATE user:viewer1 SET username='viewer1', email='viewer1@xibalba.com', password_hash='', role='viewer', locale='ja', preferred_currency='JPY';
CREATE user:viewer2 SET username='viewer2', email='viewer2@xibalba.com', password_hash='', role='viewer', locale='es', preferred_currency='MXN';

-- 2. CATEGORIES
CREATE category:electronics SET name='Electronics', slug='electronics';
CREATE category:laptops SET name='Laptops', slug='laptops', parent=category:electronics;
CREATE category:monitors SET name='Monitors', slug='monitors', parent=category:electronics;
CREATE category:furniture SET name='Furniture', slug='furniture';

-- 3. LOCATIONS
CREATE location:cdmx_center SET name='CDMX Downtown', address='Centro 1', city='Mexico City', country='MXN', coordinates={ type: 'Point', coordinates: [-99.1332, 19.4326] };
CREATE location:cdmx_south SET name='CDMX South', address='Pedregal', city='Mexico City', country='MXN', coordinates={ type: 'Point', coordinates: [-99.1992, 19.3000] };
CREATE location:ny_warehouse SET name='NY Warehouse', address='Brooklyn', city='New York', country='USA', coordinates={ type: 'Point', coordinates: [-73.935242, 40.730610] };
CREATE location:tokyo_hub SET name='Tokyo Hub', address='Shibuya', city='Tokyo', country='JPN', coordinates={ type: 'Point', coordinates: [139.6917, 35.6895] };

-- 4. ITEMS
CREATE item:laptop_01 SET name='Pro Laptop 15', sku='LAP-001', category=category:laptops, location=location:cdmx_center, quantity=50, min_quantity=10, price=999.00dec, cost=700.00dec, currency='USD', weight_kg=1.5, image_urls=[], tags=['apple', 'macbook'], is_active=true;
CREATE item:laptop_02 SET name='Air Laptop 13', sku='LAP-002', category=category:laptops, location=location:ny_warehouse, quantity=5, min_quantity=10, price=899.00dec, cost=650.00dec, currency='USD', weight_kg=1.2, image_urls=[], tags=['laptop'], is_active=true;
CREATE item:monitor_01 SET name='Ultra Monitor', sku='MON-001', category=category:monitors, location=location:cdmx_south, quantity=0, min_quantity=5, price=299.00dec, cost=200.00dec, currency='USD', weight_kg=4.0, image_urls=[], tags=['display'], is_active=true;

-- 5. GRAPH RELATIONS
RELATE user:agent1->manages->location:cdmx_center;
RELATE user:agent1->manages->location:cdmx_south;
RELATE user:agent2->manages->location:ny_warehouse;
RELATE user:agent2->manages->location:tokyo_hub;

-- 6. INITIAL MOVEMENTS
CREATE movement SET item=item:laptop_01, performed_by=user:admin1, delta=50, qty_before=0, qty_after=50, reason='initial';
CREATE movement SET item=item:laptop_02, performed_by=user:admin1, delta=5, qty_before=0, qty_after=5, reason='initial';
CREATE movement SET item=item:monitor_01, performed_by=user:admin1, delta=0, qty_before=0, qty_after=0, reason='initial';

-- 7. WATCHES
RELATE user:agent1->watches->item:laptop_01 SET alert_on=['low_stock'];
RELATE user:agent2->watches->item:laptop_02 SET alert_on=['movement'];
RELATE user:viewer1->watches->item:monitor_01 SET alert_on=['movement', 'low_stock'];

-- 8. SNAPSHOTS
CREATE snapshot SET location=location:cdmx_center, total_items=1, total_quantity=50, total_value=49950.00dec, low_stock_count=0;
