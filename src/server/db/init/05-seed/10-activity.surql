-- =============================================================================
-- Xibalbá — Seed: Activity Log
-- Dependency: 04-users.surql, 05-businesses.surql
-- Historical activities to populate dashboards on demo day.
-- =============================================================================

CREATE activity SET
    type            = 'business_verified',
    target_owner    = user:owner_carlos,
    target_business = business:tacos_el_memo,
    meta            = { message: 'Your business is now live on Xibalbá!' },
    occurred_at     = time::now() - 10d;

CREATE activity SET
    type            = 'first_review',
    target_owner    = user:owner_lucia,
    target_business = business:artesanias_xochimilco,
    meta            = { rating: 5, tourist: 'Akiko Tanaka' },
    occurred_at     = time::now() - 2d;

CREATE activity SET
    type            = 'milestone_reached',
    target_owner    = user:owner_roberto,
    target_business = business:mezcaleria_la_condesa,
    meta            = { milestone: '10 favorites', reward: 'Ola México Badge' },
    occurred_at     = time::now() - 1d;

CREATE activity SET
    type            = 'system_announcement',
    target_owner    = user:admin,
    meta            = { title: 'Welcome to Xibalbá!', version: 'v1.0.0-hackathon' },
    occurred_at     = time::now() - 15d;
