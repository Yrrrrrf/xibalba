-- =============================================================================
-- Xibalbá — Index Definitions
-- =============================================================================

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
