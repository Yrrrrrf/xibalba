-- =============================================================================
-- Xibalbá — Field Definitions (Tourism Domain)
-- This file is the schema contract. Every ASSERT and VALUE field here is
-- a domain invariant enforced at the DB level, regardless of which client connects.
-- =============================================================================

-- ---------------------------------------------------------------------------
-- locale_string: i18n key-value store
-- ---------------------------------------------------------------------------
DEFINE FIELD key        ON locale_string TYPE string;
DEFINE FIELD locale     ON locale_string TYPE string;
DEFINE FIELD value      ON locale_string TYPE string;
DEFINE FIELD updated_at ON locale_string TYPE datetime DEFAULT time::now();

-- ---------------------------------------------------------------------------
-- category: tourism taxonomy with parent hierarchy
-- ---------------------------------------------------------------------------
DEFINE FIELD slug        ON category TYPE string;
DEFINE FIELD icon        ON category TYPE option<string>;
DEFINE FIELD name        ON category TYPE string;
DEFINE FIELD description ON category TYPE option<string>;
DEFINE FIELD parent      ON category TYPE option<record<category>>;
DEFINE FIELD path        ON category VALUE
    IF parent != NONE THEN parent.path + ' > ' + name
    ELSE name END;
DEFINE FIELD created_at  ON category TYPE datetime DEFAULT time::now();

-- ---------------------------------------------------------------------------
-- city: geo anchor for businesses
-- ---------------------------------------------------------------------------
DEFINE FIELD name          ON city TYPE string;
DEFINE FIELD slug          ON city TYPE string;
DEFINE FIELD country_code  ON city TYPE string;
DEFINE FIELD coordinates   ON city TYPE geometry<point>;
DEFINE FIELD is_venue_city ON city TYPE bool DEFAULT false;
DEFINE FIELD created_at    ON city TYPE datetime DEFAULT time::now();

-- ---------------------------------------------------------------------------
-- user: tourists, owners, admins
-- ---------------------------------------------------------------------------
DEFINE FIELD username     ON user TYPE string;
DEFINE FIELD email        ON user TYPE string ASSERT string::is_email($value);
DEFINE FIELD password_hash ON user TYPE string;
DEFINE FIELD role         ON user TYPE string
    ASSERT $value IN ['tourist', 'owner', 'admin'];
DEFINE FIELD display_name ON user TYPE option<string>;
DEFINE FIELD avatar_url   ON user TYPE option<string>;
DEFINE FIELD locale       ON user TYPE string DEFAULT 'en';
DEFINE FIELD country_code ON user TYPE option<string>;
DEFINE FIELD created_at   ON user TYPE datetime DEFAULT time::now();
DEFINE FIELD updated_at   ON user TYPE datetime DEFAULT time::now();

-- ---------------------------------------------------------------------------
-- session: auth tokens linked to users
-- ---------------------------------------------------------------------------
DEFINE FIELD user       ON session TYPE record<user> REFERENCE ON DELETE CASCADE;
DEFINE FIELD token      ON session TYPE string;
DEFINE FIELD user_agent ON session TYPE option<string>;
DEFINE FIELD ip_address ON session TYPE option<string>;
DEFINE FIELD expires_at ON session TYPE datetime;
DEFINE FIELD created_at ON session TYPE datetime DEFAULT time::now();

-- ---------------------------------------------------------------------------
-- business: the core domain entity
-- ---------------------------------------------------------------------------
DEFINE FIELD name             ON business TYPE string;
DEFINE FIELD slug             ON business TYPE string;
DEFINE FIELD description      ON business TYPE option<string>;
DEFINE FIELD category         ON business TYPE record<category> REFERENCE ON DELETE REJECT;
DEFINE FIELD city             ON business TYPE record<city>     REFERENCE ON DELETE REJECT;
DEFINE FIELD coordinates      ON business TYPE geometry<point>;
DEFINE FIELD address          ON business TYPE option<string>;
DEFINE FIELD neighborhood     ON business TYPE option<string>;
DEFINE FIELD price_range      ON business TYPE string
    ASSERT $value IN ['$', '$$', '$$$'];
DEFINE FIELD languages_spoken ON business TYPE array<string>
    ASSERT array::all($value, |$l| $l IN ['es','en','fr','ja','de','pt','zh','it','ko','ar','ru','nl','pl']);
DEFINE FIELD phone            ON business TYPE option<string>;
DEFINE FIELD website          ON business TYPE option<string>;
DEFINE FIELD opening_hours    ON business TYPE option<string>;
DEFINE FIELD is_active        ON business TYPE bool DEFAULT true;
DEFINE FIELD is_verified      ON business TYPE bool DEFAULT false;
DEFINE FIELD is_ola_mexico    ON business TYPE bool DEFAULT false
    PERMISSIONS FOR update WHERE $auth.role = 'admin';
DEFINE FIELD internal_notes   ON business TYPE option<string>
    PERMISSIONS FOR select WHERE $auth.role IN ['owner', 'admin'];

-- Rating and Review Count: explicitly updated by events for performance and consistency
DEFINE FIELD rating       ON business TYPE option<float> DEFAULT 0;
DEFINE FIELD review_count ON business TYPE int            DEFAULT 0;

DEFINE FIELD created_at ON business TYPE datetime DEFAULT time::now();
DEFINE FIELD updated_at ON business TYPE datetime DEFAULT time::now();

-- ---------------------------------------------------------------------------
-- review: tourist → review → business (immutable relation)
-- ---------------------------------------------------------------------------
DEFINE FIELD rating     ON review TYPE int
    ASSERT $value >= 1 AND $value <= 5;
DEFINE FIELD body       ON review TYPE option<string>;
DEFINE FIELD locale     ON review TYPE string DEFAULT 'en';
DEFINE FIELD created_at ON review TYPE datetime DEFAULT time::now();

-- ---------------------------------------------------------------------------
-- media: external asset URLs linked to a business
-- ---------------------------------------------------------------------------
DEFINE FIELD business   ON media TYPE record<business> REFERENCE ON DELETE CASCADE;
DEFINE FIELD url        ON media TYPE string;
DEFINE FIELD caption_es ON media TYPE option<string>;
DEFINE FIELD caption_en ON media TYPE option<string>;
DEFINE FIELD sort_order ON media TYPE int DEFAULT 0;
DEFINE FIELD created_at ON media TYPE datetime DEFAULT time::now();

-- ---------------------------------------------------------------------------
-- manages: owner → manages → business (graph edge)
-- ---------------------------------------------------------------------------
DEFINE FIELD since ON manages TYPE datetime DEFAULT time::now();

-- ---------------------------------------------------------------------------
-- visits: tourist → visits → business (behavioral graph fact)
-- ---------------------------------------------------------------------------
DEFINE FIELD source     ON visits TYPE string
    ASSERT $value IN ['map', 'search', 'qr', 'link', 'recommendation'];
DEFINE FIELD visited_at ON visits TYPE datetime DEFAULT time::now();

-- ---------------------------------------------------------------------------
-- favorites: tourist → favorites → business (graph edge)
-- ---------------------------------------------------------------------------
DEFINE FIELD added_at ON favorites TYPE datetime DEFAULT time::now();

-- ---------------------------------------------------------------------------
-- activity: audit log, written only by DB events
-- ---------------------------------------------------------------------------
DEFINE FIELD type            ON activity TYPE string;
DEFINE FIELD target_owner    ON activity TYPE option<record<user>>;
DEFINE FIELD target_business ON activity TYPE option<record<business>>;
DEFINE FIELD meta            ON activity TYPE option<object>;
DEFINE FIELD meta.*          ON activity TYPE any;
DEFINE FIELD occurred_at     ON activity TYPE datetime DEFAULT time::now();
