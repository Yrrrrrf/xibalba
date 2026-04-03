-- =============================================================================
-- Xibalbá — Seed: Graph — Visits & Favorites
-- Dependency: 04-users.surql, 05-businesses.surql
-- Behavioral data for recommendations and analytics.
-- =============================================================================

-- Visits
RELATE user:tourist_akiko->visits->business:artesanias_xochimilco SET
    source = 'qr',
    visited_at = time::now() - 2d;

RELATE user:tourist_akiko->visits->business:tours_cdmx SET
    source = 'map',
    visited_at = time::now() - 1d;

RELATE user:tourist_james->visits->business:tacos_el_memo SET
    source = 'search',
    visited_at = time::now() - 3d;

RELATE user:tourist_james->visits->business:artesanias_xochimilco SET
    source = 'search',
    visited_at = time::now() - 4d;

RELATE user:tourist_james->visits->business:mezcaleria_la_condesa SET
    source = 'recommendation',
    visited_at = time::now() - 5h;

RELATE user:tourist_camille->visits->business:hostal_mundo_libre SET
    source = 'link',
    visited_at = time::now() - 12h;

-- Favorites
RELATE user:tourist_james->favorites->business:tacos_el_memo SET
    added_at = time::now() - 2d;

RELATE user:tourist_james->favorites->business:artesanias_xochimilco SET
    added_at = time::now() - 1d;

RELATE user:tourist_akiko->favorites->business:artesanias_xochimilco SET
    added_at = time::now() - 5h;

RELATE user:tourist_akiko->favorites->business:tours_cdmx SET
    added_at = time::now() - 2h;
