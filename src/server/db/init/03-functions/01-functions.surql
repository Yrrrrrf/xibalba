-- =============================================================================
-- Xibalbá — Function Definitions (Tourism Domain)
-- Functions are read-only helpers. Mutations belong to events or queries.
-- Return shapes are client contracts — coordinate with Frontend before changing.
-- =============================================================================

-- ---------------------------------------------------------------------------
-- fn::t — i18n lookup with English fallback
-- Used everywhere a display string needs locale-aware resolution.
-- ---------------------------------------------------------------------------
DEFINE FUNCTION fn::t($key: string, $locale: string) {
    LET $trans = (SELECT VALUE value FROM locale_string WHERE key = $key AND locale = $locale LIMIT 1);
    IF array::len($trans) > 0 {
        RETURN $trans[0];
    } ELSE {
        LET $fallback = (SELECT VALUE value FROM locale_string WHERE key = $key AND locale = 'en' LIMIT 1);
        RETURN array::first($fallback) OR NONE;
    };
};

-- ---------------------------------------------------------------------------
-- fn::businesses_near — geo radius search
-- Primary data source for the Explorer map view.
-- Returns active+verified businesses within $radius_km, ordered by distance.
-- Each record is augmented with a computed distance_km field.
-- geo::distance returns meters; divide by 1000 for km.
-- ---------------------------------------------------------------------------
DEFINE FUNCTION fn::businesses_near($point: geometry<point>, $radius_km: decimal) {
    LET $radius_m = $radius_km * 1000.0dec;
    LET $businesses = (
        SELECT
            *,
            geo::distance(coordinates, $point) / 1000.0 AS distance_km
        FROM business
        WHERE is_active = true
          AND is_verified = true
          AND geo::distance(coordinates, $point) <= $radius_m
        ORDER BY distance_km ASC
    );
    RETURN $businesses;
};

-- ---------------------------------------------------------------------------
-- fn::search_businesses — BM25 full-text search with filters
-- $city_id and $category_id are optional filters (pass NONE to skip).
-- Results ordered by review_count DESC as a relevance proxy.
-- ---------------------------------------------------------------------------
DEFINE FUNCTION fn::search_businesses(
    $query:       string,
    $locale:      string,
    $city_id:     option<record<city>>,
    $category_id: option<record<category>>
) {
    LET $results = (
        SELECT * FROM business
        WHERE is_active = true
          AND is_verified = true
          AND (name @@ $query OR description @@ $query)
          AND ($city_id     = NONE OR city     = $city_id)
          AND ($category_id = NONE OR category = $category_id)
        ORDER BY review_count DESC
    );
    RETURN $results;
};

-- ---------------------------------------------------------------------------
-- fn::tourist_recommendations — collaborative filtering via graph traversal
-- 1. Find businesses this tourist has visited
-- 2. Find other tourists who visited those same businesses
-- 3. Find what else those similar tourists visited (excluding already-known)
-- 4. Rank by overlap count and return top $limit business IDs
-- This is the hackathon's strongest demo moment — pure graph, zero app logic.
-- ---------------------------------------------------------------------------
DEFINE FUNCTION fn::tourist_recommendations($user_id: record<user>, $limit: int) {
    -- Step 1: businesses this tourist has already visited
    LET $visited = SELECT VALUE ->visits->business FROM only $user_id;

    -- Step 2: all tourists who visited any of those businesses (flattened)
    LET $similar_raw = SELECT VALUE <-visits<-user FROM business WHERE id IN $visited;
    LET $similar_tourists = array::flatten($similar_raw);

    -- Step 3: what those tourists visited, excluding what our tourist already knows
    LET $recommendations = (
        SELECT out AS business, count() AS overlap
        FROM visits
        WHERE in IN $similar_tourists
          AND in  != $user_id
          AND out NOT IN $visited
        GROUP BY out
        ORDER BY overlap DESC
        LIMIT $limit
    );
    RETURN $recommendations.business;
};

-- ---------------------------------------------------------------------------
-- fn::popular_in_city — top businesses by engagement score
-- Score = review_count × rating. Feeds "trending" UI sections.
-- ---------------------------------------------------------------------------
DEFINE FUNCTION fn::popular_in_city($city_id: record<city>, $limit: int) {
    LET $businesses = (
        SELECT *, (review_count * (rating OR 0.0dec)) AS score
        FROM business
        WHERE city = $city_id
          AND is_active   = true
          AND is_verified = true
        ORDER BY score DESC
        LIMIT $limit
    );
    RETURN $businesses;
};

-- ---------------------------------------------------------------------------
-- fn::city_snapshot — point-in-time telemetry for a city
-- Used by the Vision dashboard and the fn::city_snapshot integration test.
-- ---------------------------------------------------------------------------
DEFINE FUNCTION fn::city_snapshot($city_id: record<city>) {
    LET $biz       = (SELECT id FROM business WHERE city = $city_id AND is_active = true AND is_verified = true);
    LET $biz_ids   = $biz.id;
    LET $week_ago  = time::now() - 7d;

    LET $total_reviews = (SELECT VALUE count() FROM review WHERE out IN $biz_ids)[0] OR 0;
    LET $visits_week   = (SELECT VALUE count() FROM visits WHERE out IN $biz_ids AND visited_at >= $week_ago)[0] OR 0;
    LET $top_cat_row   = (
        SELECT out.category AS cat, count() AS cnt
        FROM visits
        WHERE out IN $biz_ids
        GROUP BY out.category
        ORDER BY cnt DESC
        LIMIT 1
    )[0];

    RETURN {
        city:              $city_id,
        active_businesses: array::len($biz_ids),
        total_reviews:     $total_reviews,
        visits_this_week:  $visits_week,
        top_category:      $top_cat_row.cat OR NONE
    };
};
