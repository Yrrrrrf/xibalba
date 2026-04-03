-- =============================================================================
-- Xibalbá — Event Definitions (Tourism Domain)
-- Events handle audit and notification side effects only.
-- Domain decisions stay in the application (Rust core/domain).
-- The activity table is the observable event log for all side effects.
-- =============================================================================

-- ---------------------------------------------------------------------------
-- on_review_created
-- When a tourist creates a review, notify the business owner.
-- Includes tourist country_code and locale so the owner knows who reviewed.
-- Also serves as the trigger point for the first-review milestone check.
-- ---------------------------------------------------------------------------
DEFINE EVENT on_review_created ON review WHEN $event = 'CREATE' THEN {
    LET $owner = (SELECT VALUE in FROM manages WHERE out = $after.out LIMIT 1)[0];

    -- Notify owner of new review
    IF $owner != NONE {
        CREATE activity SET
            type            = 'review.received',
            target_owner    = $owner,
            target_business = $after.out,
            meta = {
                rating:           $after.rating,
                locale:           $after.locale,
                reviewer_country: $after.in.country_code
            },
            occurred_at = time::now();
    };

    -- First-review milestone: check if this is the very first review for this business
    LET $review_count = (SELECT VALUE count() FROM review WHERE out = $after.out)[0] OR 0;
    IF $review_count = 1 AND $owner != NONE {
        CREATE activity SET
            type            = 'review.first',
            target_owner    = $owner,
            target_business = $after.out,
            meta = { rating: $after.rating },
            occurred_at = time::now();
    };
};

-- ---------------------------------------------------------------------------
-- on_business_verified
-- When a business goes from unverified → verified, it appears on the tourist
-- map for the first time. The owner gets a milestone notification.
-- ---------------------------------------------------------------------------
DEFINE EVENT on_business_verified ON business
    WHEN $event = 'UPDATE' AND $after.is_verified = true AND ($before.is_verified = false OR $before.is_verified = NONE)
THEN {
    LET $owner = (SELECT VALUE in FROM manages WHERE out = $after.id LIMIT 1)[0];
    CREATE activity SET
        type            = 'business.verified',
        target_owner    = $owner,
        target_business = $after.id,
        meta = { name: $after.name },
        occurred_at = time::now();
};

-- ---------------------------------------------------------------------------
-- on_visit_recorded
-- When a tourist visits a business for the first time, give the owner a
-- first-visit milestone. Repeat visits are silently tracked with no event.
-- ---------------------------------------------------------------------------
DEFINE EVENT on_visit_recorded ON visits WHEN $event = 'CREATE' THEN {
    LET $prior = (SELECT VALUE count() FROM visits WHERE in = $after.in AND out = $after.out)[0] OR 0;
    IF $prior <= 1 {
        LET $owner = (SELECT VALUE in FROM manages WHERE out = $after.out LIMIT 1)[0];
        IF $owner != NONE {
            CREATE activity SET
                type            = 'visit.first',
                target_owner    = $owner,
                target_business = $after.out,
                meta = { source: $after.source },
                occurred_at = time::now();
        };
    };
};
