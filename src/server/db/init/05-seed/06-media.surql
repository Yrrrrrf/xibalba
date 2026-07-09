-- =============================================================================
-- Xibalbá — Seed: Media (Photos)
-- Dependency: 05-businesses.surql
-- 2–3 photos per business pointing to placeholder Cloudinary-style URLs.
-- =============================================================================

-- Taquería El Memo
CREATE media SET business=business:tacos_el_memo,           url='https://res.cloudinary.com/xibalba/image/upload/demo/tacos-el-memo-01.jpg',          caption_es='Vista exterior del local',             caption_en='Exterior view',              sort_order=0;
CREATE media SET business=business:tacos_el_memo,           url='https://res.cloudinary.com/xibalba/image/upload/demo/tacos-el-memo-02.jpg',          caption_es='Tacos de canasta frescos',             caption_en='Fresh basket tacos',         sort_order=1;
CREATE media SET business=business:tacos_el_memo,           url='https://res.cloudinary.com/xibalba/image/upload/demo/tacos-el-memo-03.jpg',          caption_es='Don Memo en la cocina',                caption_en='Don Memo in the kitchen',    sort_order=2;

-- Hostal Mundo Libre
CREATE media SET business=business:hostal_mundo_libre,      url='https://res.cloudinary.com/xibalba/image/upload/demo/hostal-mundo-libre-01.jpg',     caption_es='Terraza con vista a Roma Norte',       caption_en='Rooftop terrace view',       sort_order=0;
CREATE media SET business=business:hostal_mundo_libre,      url='https://res.cloudinary.com/xibalba/image/upload/demo/hostal-mundo-libre-02.jpg',     caption_es='Habitación compartida luminosa',       caption_en='Bright shared dorm',         sort_order=1;
CREATE media SET business=business:hostal_mundo_libre,      url='https://res.cloudinary.com/xibalba/image/upload/demo/hostal-mundo-libre-03.jpg',     caption_es='Área común con murales',               caption_en='Common area with murals',    sort_order=2;

-- Artesanías Xochimilco
CREATE media SET business=business:artesanias_xochimilco,   url='https://res.cloudinary.com/xibalba/image/upload/demo/artesanias-xochimilco-01.jpg',  caption_es='Talavera de colores',                  caption_en='Colorful talavera ceramics', sort_order=0;
CREATE media SET business=business:artesanias_xochimilco,   url='https://res.cloudinary.com/xibalba/image/upload/demo/artesanias-xochimilco-02.jpg',  caption_es='Textiles oaxaqueños bordados',          caption_en='Embroidered Oaxacan textiles', sort_order=1;

-- Mezcalería La Condesa
CREATE media SET business=business:mezcaleria_la_condesa,   url='https://res.cloudinary.com/xibalba/image/upload/demo/mezcaleria-condesa-01.jpg',     caption_es='Barra con 200 mezcales',               caption_en='Bar with 200 mezcals',       sort_order=0;
CREATE media SET business=business:mezcaleria_la_condesa,   url='https://res.cloudinary.com/xibalba/image/upload/demo/mezcaleria-condesa-02.jpg',     caption_es='Jazz en vivo los viernes',             caption_en='Live jazz on Fridays',       sort_order=1;
CREATE media SET business=business:mezcaleria_la_condesa,   url='https://res.cloudinary.com/xibalba/image/upload/demo/mezcaleria-condesa-03.jpg',     caption_es='Degustación de mezcal artesanal',      caption_en='Artisan mezcal tasting',     sort_order=2;

-- Tours CDMX
CREATE media SET business=business:tours_cdmx,              url='https://res.cloudinary.com/xibalba/image/upload/demo/tours-cdmx-01.jpg',            caption_es='Tour a Teotihuacán al amanecer',       caption_en='Sunrise tour at Teotihuacan', sort_order=0;
CREATE media SET business=business:tours_cdmx,              url='https://res.cloudinary.com/xibalba/image/upload/demo/tours-cdmx-02.jpg',            caption_es='Trajineras en Xochimilco',             caption_en='Xochimilco trajineras',      sort_order=1;

-- Café de Olla
CREATE media SET business=business:cafe_de_olla,            url='https://res.cloudinary.com/xibalba/image/upload/demo/cafe-de-olla-01.jpg',          caption_es='Café de olla en jarrito de barro',     caption_en='Traditional clay pot coffee', sort_order=0;
CREATE media SET business=business:cafe_de_olla,            url='https://res.cloudinary.com/xibalba/image/upload/demo/cafe-de-olla-02.jpg',          caption_es='Jardín interior con buganvilias',      caption_en='Interior garden with bougainvillea', sort_order=1;

-- Cantina La Perla
CREATE media SET business=business:cantina_la_perla,        url='https://res.cloudinary.com/xibalba/image/upload/demo/cantina-la-perla-01.jpg',      caption_es='Interior clásico de cantina mexicana', caption_en='Classic Mexican cantina interior', sort_order=0;
CREATE media SET business=business:cantina_la_perla,        url='https://res.cloudinary.com/xibalba/image/upload/demo/cantina-la-perla-02.jpg',      caption_es='Botanas tradicionales',                caption_en='Traditional bar snacks',     sort_order=1;
