-- =============================================================================
-- Xibalbá — Seed: Graph — Manages
-- Dependency: 04-users.surql, 05-businesses.surql
-- Wiring owners to the businesses they operate.
-- =============================================================================

RELATE user:owner_carlos->manages->business:tacos_el_memo;
RELATE user:owner_carlos->manages->business:hostal_mundo_libre;
RELATE user:owner_carlos->manages->business:tours_cdmx;

RELATE user:owner_lucia->manages->business:artesanias_xochimilco;
RELATE user:owner_lucia->manages->business:cafe_de_olla;

RELATE user:owner_roberto->manages->business:mezcaleria_la_condesa;
RELATE user:owner_roberto->manages->business:cantina_la_perla;
