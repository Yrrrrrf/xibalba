-- =============================================================================
-- Xibalbá — Table Definitions
-- =============================================================================

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
