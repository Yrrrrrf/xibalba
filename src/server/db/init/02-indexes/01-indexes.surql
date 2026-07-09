-- =============================================================================
-- Xibalbá — Index Definitions (Tourism Domain)
-- =============================================================================

-- ---------------------------------------------------------------------------
-- Unique indexes: enforce data integrity at the DB level
-- ---------------------------------------------------------------------------
DEFINE INDEX user_email    ON user     FIELDS email    UNIQUE;
DEFINE INDEX user_username ON user     FIELDS username UNIQUE;
DEFINE INDEX session_token ON session  FIELDS token    UNIQUE;
DEFINE INDEX business_slug ON business FIELDS slug     UNIQUE;
DEFINE INDEX city_slug     ON city     FIELDS slug     UNIQUE;
DEFINE INDEX category_slug ON category FIELDS slug     UNIQUE;
DEFINE INDEX locale_idx    ON locale_string FIELDS key, locale UNIQUE;

-- One review per tourist per business (enforced via composite unique on the relation edge)
DEFINE INDEX review_per_tourist_per_business ON review FIELDS in, out UNIQUE;

-- ---------------------------------------------------------------------------
-- Full-text search: BM25 with ascii normalizer (diacritics-free Spanish/English)
-- ascii filter strips accents so 'artesania' matches 'Artesanías'
-- ---------------------------------------------------------------------------
DEFINE ANALYZER ascii_bm25
    TOKENIZERS blank, class, camel, punct
    FILTERS ascii, lowercase, snowball(spanish), snowball(english);

DEFINE INDEX business_name_ft ON business
    FIELDS name        FULLTEXT ANALYZER ascii_bm25 BM25;
DEFINE INDEX business_desc_ft ON business
    FIELDS description FULLTEXT ANALYZER ascii_bm25 BM25;

-- ---------------------------------------------------------------------------
-- Analytics indexes: support fn::popular_in_city and fn::city_snapshot
-- ---------------------------------------------------------------------------
DEFINE INDEX visits_by_business   ON visits   FIELDS out;
DEFINE INDEX favorites_by_business ON favorites FIELDS out;
DEFINE INDEX activity_by_time     ON activity  FIELDS occurred_at;
