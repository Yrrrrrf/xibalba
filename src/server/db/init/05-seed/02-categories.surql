-- =============================================================================
-- Xibalbá — Seed: Categories (Tourism Taxonomy)
-- Dependency: 01-locale-strings.surql (no cross-file refs needed here)
-- =============================================================================

-- Root categories
CREATE category:gastronomy SET
    slug = 'gastronomy',
    icon = '🍽️',
    name = 'Gastronomía';

CREATE category:lodging SET
    slug = 'lodging',
    icon = '🏨',
    name = 'Hospedaje';

CREATE category:crafts SET
    slug = 'crafts',
    icon = '🎨',
    name = 'Artesanías';

CREATE category:entertainment SET
    slug = 'entertainment',
    icon = '🎭',
    name = 'Entretenimiento';

CREATE category:tourist_services SET
    slug = 'tourist-services',
    icon = '🗺️',
    name = 'Servicios Turísticos';

CREATE category:bar_cantina SET
    slug = 'bar-cantina',
    icon = '🍹',
    name = 'Bar y Cantina';

-- Sub-categories (child of gastronomy)
CREATE category:tacos SET
    slug   = 'tacos',
    icon   = '🌮',
    name   = 'Tacos',
    parent = category:gastronomy;

CREATE category:cafe SET
    slug   = 'cafe',
    icon   = '☕',
    name   = 'Café',
    parent = category:gastronomy;

-- Sub-category (child of tourist_services)
CREATE category:city_tours SET
    slug   = 'city-tours',
    icon   = '🚌',
    name   = 'City Tours',
    parent = category:tourist_services;
