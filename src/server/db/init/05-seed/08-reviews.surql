-- =============================================================================
-- Xibalbá — Seed: Graph — Reviews
-- Dependency: 04-users.surql, 05-businesses.surql
-- Tourism persona reviews. Triggers events and updates computed ratings.
-- =============================================================================

RELATE user:tourist_akiko->review->business:artesanias_xochimilco SET
    rating = 5,
    body   = '素晴らしい職人技！',
    locale = 'ja';

RELATE user:tourist_james->review->business:tacos_el_memo SET
    rating = 5,
    body   = 'Best tacos in downtown CDMX. Authentic and cheap.',
    locale = 'en';

RELATE user:tourist_james->review->business:mezcaleria_la_condesa SET
    rating = 4,
    body   = 'Great mezcal selection, but a bit pricey for my taste.',
    locale = 'en';

RELATE user:tourist_camille->review->business:hostal_mundo_libre SET
    rating = 5,
    body   = "J'adore la terrasse sur le toit. Très recommandé !",
    locale = 'fr';

RELATE user:tourist_rafael->review->business:cafe_de_olla SET
    rating = 4,
    body   = 'Café muito bom e ambiente tranquilo.',
    locale = 'pt';

RELATE user:tourist_james->review->business:tours_cdmx SET
    rating = 5,
    body   = 'Awesome tour, well organized.',
    locale = 'en';

RELATE user:tourist_camille->review->business:mezcaleria_la_condesa SET
    rating = 5,
    body   = 'Le meilleur mezcal de la ville !',
    locale = 'fr';
