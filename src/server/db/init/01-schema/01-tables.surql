-- =============================================================================
-- Xibalbá — Table Definitions (Tourism Domain)
-- Pipeline order: tables → fields → indexes → functions → events → seed
-- =============================================================================

DEFINE NAMESPACE app;
USE NAMESPACE app;
DEFINE DATABASE main;
USE DATABASE main;

-- Supporting domain: i18n, taxonomy, geo anchoring
DEFINE TABLE locale_string SCHEMAFULL PERMISSIONS FULL;
DEFINE TABLE category SCHEMAFULL PERMISSIONS FULL;
DEFINE TABLE city SCHEMAFULL PERMISSIONS FULL;
DEFINE TABLE user SCHEMAFULL PERMISSIONS FULL;
DEFINE TABLE session SCHEMAFULL PERMISSIONS FULL;
DEFINE TABLE business SCHEMAFULL PERMISSIONS FULL;
DEFINE TABLE review SCHEMAFULL TYPE RELATION IN user OUT business PERMISSIONS FULL;
DEFINE TABLE media SCHEMAFULL PERMISSIONS FULL;
DEFINE TABLE manages SCHEMAFULL TYPE RELATION IN user OUT business PERMISSIONS FULL;
DEFINE TABLE visits SCHEMAFULL TYPE RELATION IN user OUT business PERMISSIONS FULL;
DEFINE TABLE favorites SCHEMAFULL TYPE RELATION IN user OUT business PERMISSIONS FULL;
DEFINE TABLE activity SCHEMAFULL PERMISSIONS FULL;
