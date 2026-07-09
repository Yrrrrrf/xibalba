-- =============================================================================
-- Xibalbá — Seed: Locale Strings (i18n)
-- Minimum 7 locales: es, en, fr, ja, de, pt, zh
-- Keys: categories, cities, UI labels, Ola México badge
-- =============================================================================

-- Category names
CREATE locale_string SET key='category_gastronomy',          locale='es', value='Gastronomía';
CREATE locale_string SET key='category_gastronomy',          locale='en', value='Gastronomy';
CREATE locale_string SET key='category_gastronomy',          locale='fr', value='Gastronomie';
CREATE locale_string SET key='category_gastronomy',          locale='ja', value='グルメ';
CREATE locale_string SET key='category_gastronomy',          locale='de', value='Gastronomie';
CREATE locale_string SET key='category_gastronomy',          locale='pt', value='Gastronomia';
CREATE locale_string SET key='category_gastronomy',          locale='zh', value='美食';

CREATE locale_string SET key='category_lodging',             locale='es', value='Hospedaje';
CREATE locale_string SET key='category_lodging',             locale='en', value='Lodging';
CREATE locale_string SET key='category_lodging',             locale='fr', value='Hébergement';
CREATE locale_string SET key='category_lodging',             locale='ja', value='宿泊';
CREATE locale_string SET key='category_lodging',             locale='de', value='Unterkunft';
CREATE locale_string SET key='category_lodging',             locale='pt', value='Hospedagem';
CREATE locale_string SET key='category_lodging',             locale='zh', value='住宿';

CREATE locale_string SET key='category_crafts',              locale='es', value='Artesanías';
CREATE locale_string SET key='category_crafts',              locale='en', value='Crafts';
CREATE locale_string SET key='category_crafts',              locale='fr', value='Artisanat';
CREATE locale_string SET key='category_crafts',              locale='ja', value='工芸品';
CREATE locale_string SET key='category_crafts',              locale='de', value='Kunsthandwerk';
CREATE locale_string SET key='category_crafts',              locale='pt', value='Artesanato';
CREATE locale_string SET key='category_crafts',              locale='zh', value='手工艺品';

CREATE locale_string SET key='category_entertainment',       locale='es', value='Entretenimiento';
CREATE locale_string SET key='category_entertainment',       locale='en', value='Entertainment';
CREATE locale_string SET key='category_entertainment',       locale='fr', value='Divertissement';
CREATE locale_string SET key='category_entertainment',       locale='ja', value='エンターテインメント';
CREATE locale_string SET key='category_entertainment',       locale='de', value='Unterhaltung';
CREATE locale_string SET key='category_entertainment',       locale='pt', value='Entretenimento';
CREATE locale_string SET key='category_entertainment',       locale='zh', value='娱乐';

CREATE locale_string SET key='category_tourist_services',   locale='es', value='Servicios Turísticos';
CREATE locale_string SET key='category_tourist_services',   locale='en', value='Tourist Services';
CREATE locale_string SET key='category_tourist_services',   locale='fr', value='Services Touristiques';
CREATE locale_string SET key='category_tourist_services',   locale='ja', value='観光サービス';
CREATE locale_string SET key='category_tourist_services',   locale='de', value='Touristenservices';
CREATE locale_string SET key='category_tourist_services',   locale='pt', value='Serviços Turísticos';
CREATE locale_string SET key='category_tourist_services',   locale='zh', value='旅游服务';

CREATE locale_string SET key='category_bar_cantina',        locale='es', value='Bar y Cantina';
CREATE locale_string SET key='category_bar_cantina',        locale='en', value='Bar & Cantina';
CREATE locale_string SET key='category_bar_cantina',        locale='fr', value='Bar et Cantina';
CREATE locale_string SET key='category_bar_cantina',        locale='ja', value='バー・カンティーナ';
CREATE locale_string SET key='category_bar_cantina',        locale='de', value='Bar und Cantina';
CREATE locale_string SET key='category_bar_cantina',        locale='pt', value='Bar e Cantina';
CREATE locale_string SET key='category_bar_cantina',        locale='zh', value='酒吧';

-- City names
CREATE locale_string SET key='city_cdmx',       locale='es', value='Ciudad de México';
CREATE locale_string SET key='city_cdmx',       locale='en', value='Mexico City';
CREATE locale_string SET key='city_cdmx',       locale='fr', value='Mexico';
CREATE locale_string SET key='city_cdmx',       locale='ja', value='メキシコシティ';
CREATE locale_string SET key='city_cdmx',       locale='de', value='Mexiko-Stadt';
CREATE locale_string SET key='city_cdmx',       locale='pt', value='Cidade do México';
CREATE locale_string SET key='city_cdmx',       locale='zh', value='墨西哥城';

CREATE locale_string SET key='city_guadalajara', locale='es', value='Guadalajara';
CREATE locale_string SET key='city_guadalajara', locale='en', value='Guadalajara';
CREATE locale_string SET key='city_guadalajara', locale='ja', value='グアダラハラ';
CREATE locale_string SET key='city_guadalajara', locale='zh', value='瓜达拉哈拉';

CREATE locale_string SET key='city_monterrey',   locale='es', value='Monterrey';
CREATE locale_string SET key='city_monterrey',   locale='en', value='Monterrey';
CREATE locale_string SET key='city_monterrey',   locale='ja', value='モンテレイ';
CREATE locale_string SET key='city_monterrey',   locale='zh', value='蒙特雷';

-- Price range labels
CREATE locale_string SET key='price_budget',    locale='es', value='Económico';
CREATE locale_string SET key='price_budget',    locale='en', value='Budget';
CREATE locale_string SET key='price_budget',    locale='fr', value='Économique';
CREATE locale_string SET key='price_budget',    locale='ja', value='リーズナブル';
CREATE locale_string SET key='price_budget',    locale='de', value='Günstig';
CREATE locale_string SET key='price_budget',    locale='pt', value='Econômico';
CREATE locale_string SET key='price_budget',    locale='zh', value='经济';

CREATE locale_string SET key='price_mid',       locale='es', value='Moderado';
CREATE locale_string SET key='price_mid',       locale='en', value='Moderate';
CREATE locale_string SET key='price_mid',       locale='fr', value='Modéré';
CREATE locale_string SET key='price_mid',       locale='ja', value='普通';
CREATE locale_string SET key='price_mid',       locale='de', value='Mittelklasse';
CREATE locale_string SET key='price_mid',       locale='pt', value='Moderado';
CREATE locale_string SET key='price_mid',       locale='zh', value='适中';

CREATE locale_string SET key='price_premium',   locale='es', value='Premium';
CREATE locale_string SET key='price_premium',   locale='en', value='Premium';
CREATE locale_string SET key='price_premium',   locale='fr', value='Haut de gamme';
CREATE locale_string SET key='price_premium',   locale='ja', value='プレミアム';
CREATE locale_string SET key='price_premium',   locale='de', value='Premium';
CREATE locale_string SET key='price_premium',   locale='pt', value='Premium';
CREATE locale_string SET key='price_premium',   locale='zh', value='高端';

-- Ola México certified badge
CREATE locale_string SET key='ola_mexico_badge', locale='es', value='Certificado Ola México';
CREATE locale_string SET key='ola_mexico_badge', locale='en', value='Ola México Certified';
CREATE locale_string SET key='ola_mexico_badge', locale='fr', value='Certifié Ola México';
CREATE locale_string SET key='ola_mexico_badge', locale='ja', value='オラ・メヒコ認定';
CREATE locale_string SET key='ola_mexico_badge', locale='de', value='Ola México Zertifiziert';
CREATE locale_string SET key='ola_mexico_badge', locale='pt', value='Certificado Ola México';
CREATE locale_string SET key='ola_mexico_badge', locale='zh', value='墨西哥浪潮认证';

-- UI labels
CREATE locale_string SET key='ui_discover',     locale='es', value='Descubrir';
CREATE locale_string SET key='ui_discover',     locale='en', value='Discover';
CREATE locale_string SET key='ui_discover',     locale='fr', value='Découvrir';
CREATE locale_string SET key='ui_discover',     locale='ja', value='発見する';
CREATE locale_string SET key='ui_discover',     locale='de', value='Entdecken';
CREATE locale_string SET key='ui_discover',     locale='pt', value='Descobrir';
CREATE locale_string SET key='ui_discover',     locale='zh', value='探索';

CREATE locale_string SET key='ui_near_me',      locale='es', value='Cerca de mí';
CREATE locale_string SET key='ui_near_me',      locale='en', value='Near me';
CREATE locale_string SET key='ui_near_me',      locale='fr', value='Près de moi';
CREATE locale_string SET key='ui_near_me',      locale='ja', value='近くのスポット';
CREATE locale_string SET key='ui_near_me',      locale='de', value='In meiner Nähe';
CREATE locale_string SET key='ui_near_me',      locale='pt', value='Perto de mim';
CREATE locale_string SET key='ui_near_me',      locale='zh', value='附近';
