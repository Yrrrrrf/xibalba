-- =============================================================================
-- Xibalbá — Seed: Businesses (7 in CDMX)
-- Dependency: 04-users.surql, 03-cities.surql, 02-categories.surql
-- All are Ola México certified and verified — they appear on the tourist map.
-- Real CDMX neighborhood coordinates (GeoJSON: [longitude, latitude])
-- =============================================================================

-- 1. Taquería El Memo — Centro Histórico, budget gastronomy
CREATE business:tacos_el_memo SET
    name             = 'Taquería El Memo (Tacos)',
    slug             = 'tacos-el-memo',
    description      = 'Tacos de canasta y carnitas desde 1987 en el corazón del Centro Histórico. Los mejores tacos del centro.',
    category         = category:gastronomy,
    city             = city:cdmx,
    coordinates      = { type: 'Point', coordinates: [-99.1340, 19.4330] },
    address          = 'Calle Uruguay 78, Centro Histórico',
    neighborhood     = 'Centro Histórico',
    price_range      = '$',
    languages_spoken = ['es'],
    phone            = '+52 55 5512 3456',
    opening_hours    = 'Lun–Sáb 7:00–16:00',
    is_active        = true,
    is_verified      = true,
    is_ola_mexico    = true;

-- 2. Hostal Mundo Libre — Roma Norte, mid-range lodging
CREATE business:hostal_mundo_libre SET
    name             = 'Hostal Mundo Libre',
    slug             = 'hostal-mundo-libre',
    description      = 'Boutique hostel in the heart of Roma Norte. Rooftop terrace with city views.',
    category         = category:lodging,
    city             = city:cdmx,
    coordinates      = { type: 'Point', coordinates: [-99.1620, 19.4200] },
    address          = 'Orizaba 145, Roma Norte',
    neighborhood     = 'Roma Norte',
    price_range      = '$$',
    languages_spoken = ['es', 'en', 'fr'],
    phone            = '+52 55 5584 9900',
    website          = 'https://munsolibre.demo',
    opening_hours    = '24 horas',
    is_active        = true,
    is_verified      = true,
    is_ola_mexico    = true;

-- 3. Artesanías Xochimilco — Coyoacán, mid-range crafts
CREATE business:artesanias_xochimilco SET
    name             = 'Artesanías Xochimilco',
    slug             = 'artesanias-xochimilco',
    description      = 'Artesanías mexicanas auténticas: talavera, textiles oaxaqueños y barro negro.',
    category         = category:crafts,
    city             = city:cdmx,
    coordinates      = { type: 'Point', coordinates: [-99.1625, 19.3500] },
    address          = 'Francisco Sosa 12, Coyoacán',
    neighborhood     = 'Coyoacán',
    price_range      = '$$',
    languages_spoken = ['es', 'en'],
    phone            = '+52 55 5658 7812',
    opening_hours    = 'Mar–Dom 10:00–19:00',
    is_active        = true,
    is_verified      = true,
    is_ola_mexico    = true;

-- 4. Mezcalería La Condesa — Condesa, premium bar
CREATE business:mezcaleria_la_condesa SET
    name             = 'Mezcalería La Condesa',
    slug             = 'mezcaleria-la-condesa',
    description      = 'Over 200 artisan mezcals from Oaxaca, Guerrero and Durango. Live jazz on Fridays.',
    category         = category:bar_cantina,
    city             = city:cdmx,
    coordinates      = { type: 'Point', coordinates: [-99.1729, 19.4133] },
    address          = 'Tamaulipas 66, Condesa',
    neighborhood     = 'Condesa',
    price_range      = '$$$',
    languages_spoken = ['es', 'en'],
    phone            = '+52 55 5286 4455',
    website          = 'https://lacondesa-mezcal.demo',
    opening_hours    = 'Mié–Dom 17:00–02:00',
    is_active        = true,
    is_verified      = true,
    is_ola_mexico    = true;

-- 5. Tours CDMX — Zócalo, mid-range tourist services
CREATE business:tours_cdmx SET
    name             = 'Tours CDMX',
    slug             = 'tours-cdmx',
    description      = 'Guided tours of Teotihuacán, Xochimilco, and historic downtown CDMX. QR vouchers accepted.',
    category         = category:tourist_services,
    city             = city:cdmx,
    coordinates      = { type: 'Point', coordinates: [-99.1332, 19.4326] },
    address          = 'Plaza de la Constitución 1, Centro',
    neighborhood     = 'Zócalo',
    price_range      = '$$',
    languages_spoken = ['es', 'en', 'fr', 'de'],
    phone            = '+52 55 5522 7788',
    website          = 'https://tourscdmx.demo',
    opening_hours    = 'Todos los días 8:00–18:00',
    is_active        = true,
    is_verified      = true,
    is_ola_mexico    = true;

-- 6. Café de Olla — Coyoacán, budget gastronomy
CREATE business:cafe_de_olla SET
    name             = 'Café de Olla',
    slug             = 'cafe-de-olla',
    description      = 'Café de olla tradicional, pan dulce y tlayudas. Jardín interior frente al parque.',
    category         = category:gastronomy,
    city             = city:cdmx,
    coordinates      = { type: 'Point', coordinates: [-99.1618, 19.3488] },
    address          = 'Jardín del Centenario 9, Coyoacán',
    neighborhood     = 'Coyoacán',
    price_range      = '$',
    languages_spoken = ['es'],
    phone            = '+52 55 5658 3344',
    opening_hours    = 'Lun–Dom 8:00–21:00',
    is_active        = true,
    is_verified      = true,
    is_ola_mexico    = true;

-- 7. Cantina La Perla — Centro Histórico, mid-range bar
CREATE business:cantina_la_perla SET
    name             = 'Cantina La Perla',
    slug             = 'cantina-la-perla',
    description      = 'Cantina tradicional desde 1942. Botanas clásicas, pulque y música de mariachi.',
    category         = category:bar_cantina,
    city             = city:cdmx,
    coordinates      = { type: 'Point', coordinates: [-99.1335, 19.4310] },
    address          = 'Uruguay 51, Centro Histórico',
    neighborhood     = 'Centro Histórico',
    price_range      = '$$',
    languages_spoken = ['es'],
    phone            = '+52 55 5512 6677',
    opening_hours    = 'Lun–Sáb 12:00–22:00',
    is_active        = true,
    is_verified      = true,
    is_ola_mexico    = true;
