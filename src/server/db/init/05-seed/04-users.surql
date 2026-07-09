-- =============================================================================
-- Xibalbá — Seed: Users
-- Dependency: 03-cities.surql
-- 1 admin, 3 owners (Mexican, locale es), 4 tourists (international)
-- Passwords are placeholder hashes — demo only, not production values.
-- =============================================================================

-- Admin
CREATE user:admin SET
    username      = 'admin',
    email         = 'admin@xibalba.mx',
    password_hash = 'demo_hash_admin',
    role          = 'admin',
    display_name  = 'Xibalbá Admin',
    locale        = 'es',
    country_code  = 'MX';

-- Business owners (Mexican, Spanish locale)
CREATE user:owner_carlos SET
    username      = 'owner_carlos',
    email         = 'carlos@xibalba.mx',
    password_hash = 'demo_hash_carlos',
    role          = 'owner',
    display_name  = 'Carlos Mendoza',
    locale        = 'es',
    country_code  = 'MX';

CREATE user:owner_lucia SET
    username      = 'owner_lucia',
    email         = 'lucia@xibalba.mx',
    password_hash = 'demo_hash_lucia',
    role          = 'owner',
    display_name  = 'Lucía Ramírez',
    locale        = 'es',
    country_code  = 'MX';

CREATE user:owner_roberto SET
    username      = 'owner_roberto',
    email         = 'roberto@xibalba.mx',
    password_hash = 'demo_hash_roberto',
    role          = 'owner',
    display_name  = 'Roberto Vázquez',
    locale        = 'es',
    country_code  = 'MX';

-- Tourists (international — World Cup visitor personas)
CREATE user:tourist_akiko SET
    username      = 'tourist_akiko',
    email         = 'akiko@demo.xibalba.mx',
    password_hash = 'demo_hash_akiko',
    role          = 'tourist',
    display_name  = 'Akiko Tanaka',
    locale        = 'ja',
    country_code  = 'JP';

CREATE user:tourist_james SET
    username      = 'tourist_james',
    email         = 'james@demo.xibalba.mx',
    password_hash = 'demo_hash_james',
    role          = 'tourist',
    display_name  = 'James Mitchell',
    locale        = 'en',
    country_code  = 'US';

CREATE user:tourist_camille SET
    username      = 'tourist_camille',
    email         = 'camille@demo.xibalba.mx',
    password_hash = 'demo_hash_camille',
    role          = 'tourist',
    display_name  = 'Camille Dupont',
    locale        = 'fr',
    country_code  = 'FR';

CREATE user:tourist_rafael SET
    username      = 'tourist_rafael',
    email         = 'rafael@demo.xibalba.mx',
    password_hash = 'demo_hash_rafael',
    role          = 'tourist',
    display_name  = 'Rafael Oliveira',
    locale        = 'pt',
    country_code  = 'BR';
