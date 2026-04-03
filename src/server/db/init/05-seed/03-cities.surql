-- =============================================================================
-- Xibalbá — Seed: Cities
-- Dependency: 02-categories.surql
-- Venue cities: CDMX, Guadalajara, Monterrey (FIFA World Cup 2026 hosts)
-- Context cities: New York, Toronto (tourist origin markets)
-- Coordinates: GeoJSON format [longitude, latitude]
-- =============================================================================

-- FIFA World Cup 2026 venue cities (Mexico)
CREATE city:cdmx SET
    name          = 'Ciudad de México',
    slug          = 'cdmx',
    country_code  = 'MX',
    coordinates   = { type: 'Point', coordinates: [-99.1332, 19.4326] },
    is_venue_city = true;

CREATE city:guadalajara SET
    name          = 'Guadalajara',
    slug          = 'guadalajara',
    country_code  = 'MX',
    coordinates   = { type: 'Point', coordinates: [-103.3496, 20.6597] },
    is_venue_city = true;

CREATE city:monterrey SET
    name          = 'Monterrey',
    slug          = 'monterrey',
    country_code  = 'MX',
    coordinates   = { type: 'Point', coordinates: [-100.3161, 25.6866] },
    is_venue_city = true;

-- Tourist origin context cities
CREATE city:new_york SET
    name          = 'New York',
    slug          = 'new-york',
    country_code  = 'US',
    coordinates   = { type: 'Point', coordinates: [-74.0060, 40.7128] },
    is_venue_city = false;

CREATE city:toronto SET
    name          = 'Toronto',
    slug          = 'toronto',
    country_code  = 'CA',
    coordinates   = { type: 'Point', coordinates: [-79.3832, 43.6532] },
    is_venue_city = false;
