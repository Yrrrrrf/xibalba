# Xibalbá — Explorer Implementation Plan

> **Purpose:** A model reads this document alongside the `inventory-src/`
> directory and the existing Xibalbá SDK/app scaffolding, then migrates each
> inventory component into the correct SDK layer and wires it into the Explorer
> app. Hardcoded mock data lives in `@sdk/state` first; the DB is wired later.

---

## 0. Executive Summary

The `inventory-src/` directory (already inside `src/client/`) contains a working
prototype with tourist, business-owner, and admin experiences. The **Explorer
app** is now the single consumer-facing app — it serves both tourists AND
business owners via a role-based layout. Vision (admin telemetry) can wait. The
SurrealDB backend already passes 27/27 tests covering users, businesses,
reviews, categories, cities, geo queries, FTS, graph traversals, and computed
fields. The implementation strategy is: (1) extract types to `@sdk/core`, (2)
build hardcoded mock stores in `@sdk/state`, (3) migrate components to
`@sdk/ui`, (4) compose routes in Explorer, (5) flip stores from mock to real
SurrealDB. This plan gives exact source→target file paths so a model can execute
each step mechanically.

---

## 1. What Changed Since v2

| Item                       | v2 Spec                          | Now                                                                                                      |
| -------------------------- | -------------------------------- | -------------------------------------------------------------------------------------------------------- |
| **Agent app**              | Separate app for business owners | **Removed.** Explorer handles both tourist + business owner roles.                                       |
| **inventory-src location** | External, separate repo          | **Inside the workspace** at `src/client/inventory-src/`. Direct file references possible.                |
| **Database**               | Not yet tested                   | **27/27 tests passing.** Schema, computed fields, events, graph traversals, FTS, geo search all working. |
| **SDK packages**           | Unknown state                    | **Empty shells.** `core/src/mod.ts`, `state/src/mod.ts`, `ui/src/mod.ts` exist but export nothing.       |
| **Focus**                  | All three apps equally           | **Explorer first.** Vision can wait.                                                                     |

---

## 2. DB Compatibility Matrix

The SurrealDB schema already covers many inventory concepts. This matrix maps
each inventory feature to DB readiness. A model implementing this plan should
check this table before each component — if the DB column says "Ready," the
`@sdk/state` store can be wired to real data immediately. If it says "TODO," use
hardcoded mock data and leave a `// TODO(db): ...` comment.

| Inventory Concept                              | DB Table/Relation             | DB Status   | Notes                                                                                         |
| ---------------------------------------------- | ----------------------------- | ----------- | --------------------------------------------------------------------------------------------- |
| Business profile (name, address, phone, hours) | `business`                    | **Ready**   | Has slug, verified status, coordinates, price_range. Computed `rating` + `review_count`.      |
| Business categories                            | `category`                    | **Ready**   | Hierarchical with computed `path`.                                                            |
| Business owner → business link                 | `manages` relation            | **Ready**   | Graph traversal tested (E1, E2).                                                              |
| User accounts + roles                          | `user`                        | **Ready**   | Roles validated by ASSERT. Unique email index.                                                |
| Tourist visits a business                      | `visits` relation             | **Ready**   | Graph traversal tested (E3).                                                                  |
| Tourist favorites a business                   | `favorites` relation          | **Ready**   | Graph traversal tested (E4).                                                                  |
| Reviews + ratings                              | `review`                      | **Ready**   | Triggers `on_review_created` event. Auto-recomputes `business.rating`.                        |
| City / Zone                                    | `city`                        | **Ready**   | Referenced by business. ON DELETE REJECT tested.                                              |
| Geo proximity search                           | `fn::businesses_near`         | **Ready**   | Tested for CDMX radius and empty results for Tokyo.                                           |
| Full-text search                               | FTS index on `business.name`  | **Ready**   | ASCII normalization tested.                                                                   |
| Recommendations                                | `fn::tourist_recommendations` | **Ready**   | Graph-based recommendation engine.                                                            |
| Activity feed                                  | `activity`                    | **Ready**   | Created by events (review.received, review.first, business.verified).                         |
| **Dishes / Menu items**                        | —                             | **TODO**    | DB has no `dish` or `menu_item` table. Inventory's core food discovery needs this.            |
| **Nutrition data**                             | —                             | **TODO**    | No nutrition fields anywhere in DB.                                                           |
| **Dish categories**                            | —                             | **TODO**    | The existing `category` table is for businesses. Dishes need their own or a shared hierarchy. |
| **Saved dishes**                               | —                             | **TODO**    | `favorites` relation exists but connects user→business, not user→dish.                        |
| **Dish images**                                | —                             | **TODO**    | No image storage or URL fields for dishes.                                                    |
| **Business hours**                             | `business.hours`              | **Partial** | Field exists but structure unknown. Inventory has a simple string.                            |

### Implication for Implementation

The tourist discovery flow (finding dishes near me) is the hero feature, but the
DB doesn't have a `dish` table yet. This means:

1. `@sdk/state/dishStore` MUST start with hardcoded mock data
2. The business-level features (profile, location, reviews, favorites) CAN be
   wired to real DB data right away since those tables are ready
3. When the backend team adds a `dish` table + `serves` relation
   (business→dish), the state store flips from mock to real with zero UI changes

---

## 3. Source → Target File Map

Every file below uses the actual paths visible in the Xibalbá tree. The
**Source** column points to `inventory-src/`. The **Target** column shows where
the content lands in the SDK or app. The **Action** column describes what
transformation is needed.

### 3.1 Domain Types: inventory-src → `@sdk/core`

These extractions create the type system. No Svelte, no reactivity, no framework
imports. Pure TypeScript.

| Source File                                                         | Interfaces to Extract               | Target File                                                           | Action                                                                                                                                                                            |
| ------------------------------------------------------------------- | ----------------------------------- | --------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `inventory-src/lib/components/cliente/FoodCard.svelte`              | `FoodCardProps`                     | `sdk/core/src/entities/dish.ts`                                       | Extract as `Dish` type. Rename `nombre→name`, `precio→price`, `restaurante→restaurant`, `imagen→image_url`, `categoria→category`. Add `id: string` (SurrealDB record ID format).  |
| `inventory-src/lib/components/cliente/FoodDetailModal.svelte`       | `Nutricion`, `Comercio`, `Platillo` | `sdk/core/src/entities/dish.ts` + `sdk/core/src/entities/business.ts` | `Nutricion` → `Nutrition` (calories, fat, protein, carbs). `Comercio` → merge into `Business`. `Platillo` → merge into `Dish` (add description, ingredients, nutrition fields).   |
| `inventory-src/lib/components/comerciante/BusinessProfile.svelte`   | inline `perfil` object              | `sdk/core/src/entities/business.ts`                                   | Extract as `BusinessProfile`. Fields: name, owner_name, zone, address, phone, email, description, hours, category. Map to existing DB `business` table fields.                    |
| `inventory-src/lib/components/comerciante/MerchantDashboard.svelte` | `Producto`                          | `sdk/core/src/entities/dish.ts`                                       | Merge into `Dish`. Add `available: boolean`, `sales_count: number`.                                                                                                               |
| `inventory-src/lib/components/comerciante/ProductForm.svelte`       | `ProductoData`                      | `sdk/core/src/entities/dish.ts`                                       | Extract as `DishFormData` (the create/edit payload shape).                                                                                                                        |
| `inventory-src/lib/components/admin/DataTable.svelte`               | `Comerciante`                       | `sdk/core/src/entities/business.ts`                                   | Extract as `BusinessSummary` (id, name, owner, zone, category, dish_count, sales, status).                                                                                        |
| `inventory-src/lib/components/admin/StatsCard.svelte`               | inline props                        | `sdk/core/src/entities/analytics.ts`                                  | Extract as `StatSnapshot` (icon, title, value, variant, trend, trendValue, desc).                                                                                                 |
| `inventory-src/lib/components/comerciante/LocationPicker.svelte`    | inline coords                       | `sdk/core/src/entities/geo.ts`                                        | Extract as `GeoPoint` { lat, lng } and `GeoAddress` { lat, lng, address }.                                                                                                        |
| `inventory-src/lib/components/cliente/LocationSelector.svelte`      | `Zona` concept                      | `sdk/core/src/entities/geo.ts`                                        | Extract as `Zone` { id, name }. Maps to DB `city` table.                                                                                                                          |
| — (new)                                                             | —                                   | `sdk/core/src/entities/visitor.ts`                                    | `VisitorPreferences` { locale, currency }, `SavedItem` { dish_id, saved_at }.                                                                                                     |
| — (new)                                                             | —                                   | `sdk/core/src/entities/review.ts`                                     | `Review` { id, business_id, user_id, rating, comment, created_at }. Maps to DB `review` table.                                                                                    |
| — (new)                                                             | —                                   | `sdk/core/src/constants/categories.ts`                                | `DISH_CATEGORIES` array. Keys: `mexican`, `seafood`, `street_food`, `drinks`, `desserts`, `international`, `vegetarian`, `fast_food`. Each key maps to an i18n token and a color. |

**Final `sdk/core/src/mod.ts` exports everything:**

```
sdk/core/src/
  ├── mod.ts                 ← re-exports all entities + constants
  ├── entities/
  │   ├── dish.ts            ← Dish, DishFormData, Nutrition
  │   ├── business.ts        ← Business, BusinessProfile, BusinessSummary
  │   ├── geo.ts             ← GeoPoint, GeoAddress, Zone
  │   ├── analytics.ts       ← StatSnapshot
  │   ├── visitor.ts         ← VisitorPreferences, SavedItem
  │   └── review.ts          ← Review
  └── constants/
      └── categories.ts      ← DISH_CATEGORIES
```

---

### 3.2 State Stores: hardcoded mock data → `@sdk/state`

Each store uses `$state` and `$derived` from Svelte 5. Stores export a factory
function that returns the reactive object. Data starts hardcoded; each store has
a clearly marked internal `_adapter` section that switches from mock to real.

| Store            | Target File                         | Mock Data Source                                                                                                                                                                       | DB Wiring Status                                                                                                                                |
| ---------------- | ----------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| `businessStore`  | `sdk/state/src/stores/business.ts`  | Copy the mock `comerciantes` array from `inventory-src/routes/mundial/admin/+page.svelte` and the mock `perfil` from `inventory-src/lib/components/comerciante/BusinessProfile.svelte` | **Can wire NOW** — DB `business` table is ready. `fn::businesses_near` for geo.                                                                 |
| `dishStore`      | `sdk/state/src/stores/dish.ts`      | Copy the mock `platillos` array from `inventory-src/routes/mundial/cliente/+page.svelte` and the mock `productos` from `inventory-src/routes/mundial/comerciante/+page.svelte`         | **TODO(db): No `dish` table yet.** Use hardcoded mock data. Leave comment: `// TODO(db): Replace with SurrealQL query when dish table is added` |
| `visitorStore`   | `sdk/state/src/stores/visitor.ts`   | Copy the mock `guardados` array from `inventory-src/routes/mundial/cliente/+page.svelte`                                                                                               | **Partial** — `favorites` relation exists for businesses. `// TODO(db): Add user→dish favorites when dish table exists`                         |
| `geoStore`       | `sdk/state/src/stores/geo.ts`       | Copy the mock `zonas` array from `inventory-src/routes/mundial/cliente/+page.svelte`                                                                                                   | **Can wire NOW** — DB `city` table + `fn::businesses_near`.                                                                                     |
| `analyticsStore` | `sdk/state/src/stores/analytics.ts` | Copy the mock stats from `inventory-src/routes/mundial/admin/+page.svelte`                                                                                                             | **Can wire NOW** — DB computed `business.rating`, `business.review_count`. `// TODO(db): Add aggregate queries for global stats`                |
| `reviewStore`    | `sdk/state/src/stores/review.ts`    | Generate 5-10 mock reviews                                                                                                                                                             | **Can wire NOW** — DB `review` table + events + computed rating.                                                                                |
| `authStore`      | `sdk/state/src/stores/auth.ts`      | Simple role state: `{ role: 'tourist'                                                                                                                                                  | 'business'                                                                                                                                      |

**Final `sdk/state/src/mod.ts` exports all stores:**

```
sdk/state/src/
  ├── mod.ts                 ← re-exports all stores
  └── stores/
      ├── business.ts
      ├── dish.ts            ← // TODO(db): hardcoded until dish table exists
      ├── visitor.ts
      ├── geo.ts
      ├── analytics.ts
      ├── review.ts
      └── auth.ts
```

---

### 3.3 UI Components: inventory-src → `@sdk/ui`

Every component below moves from `inventory-src/lib/components/` into
`sdk/ui/src/components/`. The existing `sdk/ui/src/mod.ts` already has property/
map/CRM exports — the new food/business/analytics exports are ADDED alongside
them.

#### Shared Primitives (extract FIRST — used by everything else)

These don't have a 1:1 inventory source file. They're patterns EXTRACTED from
multiple inventory components to avoid repeating code.

| Primitive           | Target File                                                 | Extracted From                                                                                                                                                                   | What It Does                                                                                   |
| ------------------- | ----------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------- |
| `GlassCard`         | `sdk/ui/src/components/primitives/GlassCard.svelte`         | The `bg-neutral-900/60 backdrop-blur-xl border border-white/10 rounded-2xl` pattern repeated in `FoodCard`, `StatsCard`, `MerchantDashboard`, `BusinessProfile`, `SavedFoodCard` | Single visual container with variant-driven gradient accent, hover lift, and glow.             |
| `CategoryBadge`     | `sdk/ui/src/components/primitives/CategoryBadge.svelte`     | The `categoryColor` maps duplicated in `FoodCard.svelte` (line ~1096) AND `FoodDetailModal.svelte` (line ~1265)                                                                  | One color→gradient map. Accepts a category key, renders the pill badge.                        |
| `RatingDisplay`     | `sdk/ui/src/components/primitives/RatingDisplay.svelte`     | The `★ {rating}` amber pill repeated in `FoodCard`, `FoodDetailModal`, `PlaceCard`                                                                                               | Star + number in a pill. Accepts `value: number`.                                              |
| `StatusBadge`       | `sdk/ui/src/components/primitives/StatusBadge.svelte`       | The `estadoBadge` map in `DataTable.svelte` (line ~793) and availability badge in `MerchantDashboard`                                                                            | Status key → colored DaisyUI badge.                                                            |
| `PriceTag`          | `sdk/ui/src/components/primitives/PriceTag.svelte`          | Every `${precio.toFixed(2)}` in `FoodCard`, `FoodDetailModal`, `SavedFoodCard`, `MerchantDashboard`                                                                              | Wraps `MoneyDisplay` (already in `@sdk/ui`) with size/color variants. Enforces Dinero.js rule. |
| `ImageWithFallback` | `sdk/ui/src/components/primitives/ImageWithFallback.svelte` | The identical `onerror` → DiceBear handler in `FoodCard` (line ~1136) and `FoodDetailModal` (line ~1310)                                                                         | `<img>` with automatic DiceBear fallback on error.                                             |
| `EmptyState`        | `sdk/ui/src/components/primitives/EmptyState.svelte`        | The empty state in `MerchantDashboard` (line ~2155: "No tienes platillos registrados")                                                                                           | Emoji + title + subtitle + optional action button.                                             |

| Action/Utility   | Target File                     | Extracted From                                                               |
| ---------------- | ------------------------------- | ---------------------------------------------------------------------------- |
| `tilt` action    | `sdk/ui/src/actions/tilt.ts`    | The `function tilt(node)` in `FoodCard.svelte` (lines ~1061-1093)            |
| `map-icons` util | `sdk/ui/src/utils/map-icons.ts` | The `function makeIcon(color)` in `LocationPicker.svelte` (lines ~1903-1912) |

---

#### Domain Components — Food (`components/food/`)

| Source                                                        | Target                                              | Component Name    | What Changes                                                                                                                                                                                                                                                                                                                           |
| ------------------------------------------------------------- | --------------------------------------------------- | ----------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `inventory-src/lib/components/cliente/FoodCard.svelte`        | `sdk/ui/src/components/food/DishCard.svelte`        | `DishCard`        | Remove inline `tilt` function → `use:tilt` from `actions/tilt.ts`. Remove `categoryColor` map → use `CategoryBadge`. Remove `$` formatting → use `PriceTag`. Remove `onerror` handler → use `ImageWithFallback`. Wrap in `GlassCard`. Accept `dish: Dish` prop (from `@sdk/core`) instead of flat props. Tokenize all visible strings. |
| `inventory-src/lib/components/cliente/FoodDetailModal.svelte` | `sdk/ui/src/components/food/DishDetailModal.svelte` | `DishDetailModal` | Remove inline interfaces → import from `@sdk/core`. Remove `categoryColor` duplication → use `CategoryBadge`. Delegate map to existing `@sdk/ui` `MapView`. Use `PriceTag` for price. Use `ImageWithFallback` for hero image. Accept `dish: Dish                                                                                       |
| `inventory-src/lib/components/cliente/SavedFoodCard.svelte`   | `sdk/ui/src/components/food/SavedDishCard.svelte`   | `SavedDishCard`   | Same refactors as `DishCard` but in compact horizontal layout. Add `onremove` callback.                                                                                                                                                                                                                                                |
| `inventory-src/lib/components/cliente/PlaceCard.svelte`       | `sdk/ui/src/components/food/PlaceCard.svelte`       | `PlaceCard`       | Refactor to use `GlassCard`, `RatingDisplay`. Accept `business: Business` prop. This card shows a business (not a dish) in the discovery context.                                                                                                                                                                                      |

#### Domain Components — Business (`components/business/`)

| Source                                                              | Target                                                        | Component Name          | What Changes                                                                                                                                             |
| ------------------------------------------------------------------- | ------------------------------------------------------------- | ----------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `inventory-src/lib/components/comerciante/BusinessProfile.svelte`   | `sdk/ui/src/components/business/BusinessProfileEditor.svelte` | `BusinessProfileEditor` | Remove inline mock `perfil` → accept `profile: BusinessProfile` prop. Tokenize all field labels. Emit `onsave(updated)` instead of mutating local state. |
| `inventory-src/lib/components/comerciante/MerchantDashboard.svelte` | `sdk/ui/src/components/business/MerchantDashboard.svelte`     | `MerchantDashboard`     | Remove `Producto` interface → use `Dish` from `@sdk/core`. Use `PriceTag`. Use `StatusBadge`. Use `EmptyState`. Use `StatsCard` for the stats bar.       |
| `inventory-src/lib/components/comerciante/ProductForm.svelte`       | `sdk/ui/src/components/business/DishForm.svelte`              | `DishForm`              | Remove hardcoded `categorias` array → import from `@sdk/core/constants/categories.ts`. Tokenize labels. Accept `initial: DishFormData                    |
| `inventory-src/lib/components/comerciante/LocationPicker.svelte`    | `sdk/ui/src/components/business/LocationPicker.svelte`        | `LocationPicker`        | Already well-isolated. Tokenize UI strings. Extract `makeIcon` to `utils/map-icons.ts`. Delegate Leaflet init to `LeafletContainer` if possible.         |

#### Domain Components — Geo (`components/geo/`)

| Source                                                         | Target                                          | Component Name | What Changes                                                                                        |
| -------------------------------------------------------------- | ----------------------------------------------- | -------------- | --------------------------------------------------------------------------------------------------- |
| `inventory-src/lib/components/cliente/LocationSelector.svelte` | `sdk/ui/src/components/geo/ZoneSelector.svelte` | `ZoneSelector` | Accept `zones: Zone[]` from props (fed by `geoStore`). Tokenize labels. Remove hardcoded zone data. |

#### Domain Components — Analytics (`components/analytics/`)

| Source                                                | Target                                                     | Component Name      | What Changes                                                                                        |
| ----------------------------------------------------- | ---------------------------------------------------------- | ------------------- | --------------------------------------------------------------------------------------------------- |
| `inventory-src/lib/components/admin/StatsCard.svelte` | `sdk/ui/src/components/analytics/StatsCard.svelte`         | `StatsCard`         | Already clean. Wrap in `GlassCard`. Tokenize `title` and `desc`.                                    |
| `inventory-src/lib/components/admin/DataTable.svelte` | `sdk/ui/src/components/analytics/BusinessDataTable.svelte` | `BusinessDataTable` | Rename `Comerciante` → `BusinessSummary`. Use `StatusBadge`. Tokenize headers. Emit `onselect(id)`. |

#### Dropped Components (not migrated)

| Source                                           | Why Dropped                                                     |
| ------------------------------------------------ | --------------------------------------------------------------- |
| `inventory-src/lib/components/ui/Button.svelte`  | DaisyUI `btn` classes cover this.                               |
| `inventory-src/lib/components/ui/Footer.svelte`  | Not needed for Explorer MVP.                                    |
| `inventory-src/lib/components/ui/Modal.svelte`   | Use rune-lab modal or DaisyUI dialog.                           |
| `inventory-src/lib/components/ui/Navbar.svelte`  | Each app has its own layout via rune-lab `WorkspaceLayout`.     |
| `inventory-src/lib/components/ui/MapView.svelte` | `@sdk/ui` already exports `MapView`. Merge any useful patterns. |
| `inventory-src/routes/lab/*`                     | Dev tooling. rune-lab already provides this.                    |
| `inventory-src/routes/+page.svelte`              | Inventory admin dashboard. Replaced by Explorer dashboard.      |
| `inventory-src/routes/AppLayout.svelte`          | rune-lab `WorkspaceLayout` replaces this.                       |

---

### 3.4 Explorer App Routes: inventory-src pages → `apps/explorer/`

The Explorer now serves TWO roles. The root layout detects the user's role from
`authStore` and adjusts the navigation/shell accordingly. Tourist sees
discovery-focused nav. Business owner sees management-focused nav. Both share
the same app, same deployment, same URL.

#### Source Page → Target Route Mapping

| Source Page                                             | Target Route                                      | Role     | What It Renders                                                                                                                                                                               |
| ------------------------------------------------------- | ------------------------------------------------- | -------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `inventory-src/routes/mundial/login/+page.svelte`       | `apps/explorer/src/routes/login/+page.svelte`     | Both     | Role selector (tourist / business). Uses `AuthPortal` from `@sdk/ui`. The inventory login page already shows the "Xibalbá" brand with role buttons — this is reused almost 1:1 but tokenized. |
| `inventory-src/routes/mundial/cliente/+page.svelte`     | `apps/explorer/src/routes/discover/+page.svelte`  | Tourist  | Map + dish card grid + zone filter + search. Composes `MapView`, `DishCard`, `ZoneSelector`. Data from `dishStore` + `geoStore`.                                                              |
| — (new)                                                 | `apps/explorer/src/routes/food/[id]/+page.svelte` | Tourist  | Dish detail. Wraps `DishDetailModal` as a full page. Data from `dishStore.findById()`.                                                                                                        |
| — (new)                                                 | `apps/explorer/src/routes/saved/+page.svelte`     | Tourist  | Saved dishes grid. `SavedDishCard` list. Data from `visitorStore.saved`.                                                                                                                      |
| `inventory-src/routes/mundial/comerciante/+page.svelte` | `apps/explorer/src/routes/dashboard/+page.svelte` | Business | Business owner dashboard. `MerchantDashboard` + `StatsCard` header. Data from `dishStore` (filtered by owner).                                                                                |
| — (new)                                                 | `apps/explorer/src/routes/profile/+page.svelte`   | Business | Business profile editing. `BusinessProfileEditor` + `LocationPicker`. Data from `businessStore`.                                                                                              |
| — (new)                                                 | `apps/explorer/src/routes/menu/+page.svelte`      | Business | Menu management. Dish list + add button.                                                                                                                                                      |
| — (new)                                                 | `apps/explorer/src/routes/menu/new/+page.svelte`  | Business | Add new dish. `DishForm` in create mode.                                                                                                                                                      |
| `inventory-src/routes/mundial/admin/+page.svelte`       | —                                                 | —        | **NOT in Explorer.** Admin features go to Vision app later. The mock data arrays from this page are extracted to `@sdk/state` stores.                                                         |

#### Explorer Route Tree (final)

```
apps/explorer/src/routes/
  ├── +layout.svelte         ← RuneProvider + role-aware shell
  ├── +page.svelte           ← Landing / redirect based on role
  ├── layout.css             ← Tailwind v4 + DaisyUI + @source sdk/ui
  ├── login/
  │   └── +page.svelte       ← Role selector (tourist / business)
  ├── discover/
  │   └── +page.svelte       ← Map + food discovery (tourist)
  ├── food/
  │   └── [id]/
  │       └── +page.svelte   ← Dish detail (tourist)
  ├── saved/
  │   └── +page.svelte       ← Saved dishes (tourist)
  ├── dashboard/
  │   └── +page.svelte       ← Business owner overview
  ├── profile/
  │   └── +page.svelte       ← Business profile editor
  └── menu/
      ├── +page.svelte       ← Menu item list (business)
      └── new/
          └── +page.svelte   ← Add new dish form (business)
```

#### Root Layout: Role-Aware Shell

The `+layout.svelte` imports `authStore` from `@sdk/state`. Based on the current
role, it renders different navigation:

- `role === null` → redirect to `/login`
- `role === 'tourist'` → nav items: Discover, Saved, (profile icon for
  locale/currency settings)
- `role === 'business'` → nav items: Dashboard, Menu, Profile, (switch to
  tourist view)

Both roles share the same `RuneProvider` config, theme, and locale system. The
shell is `rune-lab`'s `WorkspaceLayout` for business role (master-detail), or a
simpler full-width layout for tourist role.

---

## 4. Phased Implementation Plan

### Phase 1 — SDK Foundation (do FIRST, before touching Explorer)

**Goal:** All types, constants, shared primitives, and mock stores exist. Any
component or page can import from `@sdk/core`, `@sdk/state`, and `@sdk/ui`
without errors.

**Tasks:**

1. **`@sdk/core` entities** — Create `dish.ts`, `business.ts`, `geo.ts`,
   `analytics.ts`, `visitor.ts`, `review.ts` by extracting interfaces from
   inventory-src files listed in Section 3.1. Create `constants/categories.ts`.
   Update `mod.ts` to re-export everything.

2. **`@sdk/state` stores** — Create all 7 stores listed in Section 3.2. Each
   store starts with hardcoded mock data copied from the inventory-src page
   files. Each store that CAN wire to DB gets a `// READY(db)` comment. Each
   that can't gets `// TODO(db): ...` with a description of what's missing.

3. **`@sdk/ui` primitives** — Create all 7 primitives listed in Section 3.3
   (GlassCard, CategoryBadge, RatingDisplay, StatusBadge, PriceTag,
   ImageWithFallback, EmptyState). Create `actions/tilt.ts` and
   `utils/map-icons.ts`. Update `mod.ts` with new exports.

4. **i18n keys** — Add food/business/analytics keys to all 13 locale JSON files
   in `sdk/ui/src/i18n/messages/`. At minimum complete en + es. Other 11 get
   placeholder values.

**Exit criteria:**

- `deno check .` passes from `src/client/` root
- `deno task --cwd sdk/ui prepare` succeeds
- Each primitive can be imported and has no missing dependencies
- Mock stores return data when accessed

**Risk flags:**

- [REVISIT] If `MoneyDisplay` (already in `@sdk/ui`) doesn't exist yet as a real
  implementation, `PriceTag` must implement Dinero.js formatting directly.

---

### Phase 2 — Domain Components (migrate inventory UI into SDK)

**Goal:** All 10 domain components are migrated and export from `@sdk/ui`. They
compose from Phase 1 primitives and consume Phase 1 types.

**Tasks:**

1. **Food components** — Migrate `DishCard`, `DishDetailModal`, `SavedDishCard`,
   `PlaceCard` following the transformation rules in Section 3.3. Each component
   uses `GlassCard`, `CategoryBadge`, `PriceTag`, `ImageWithFallback`,
   `RatingDisplay` from primitives.

2. **Business components** — Migrate `BusinessProfileEditor`,
   `MerchantDashboard`, `DishForm`, `LocationPicker`.

3. **Geo + Analytics components** — Migrate `ZoneSelector`, `StatsCard`,
   `BusinessDataTable`.

4. **Update `sdk/ui/src/mod.ts`** — Add all new exports alongside the existing
   property/map/CRM exports.

**Exit criteria:**

- Every component renders when given valid props (smoke test)
- No component contains hardcoded Spanish strings (all `m.key()`)
- No component contains `$` price formatting (all `PriceTag`)
- No component contains inline `bg-neutral-900/60 backdrop-blur` (all
  `GlassCard`)
- No component calls `fetch()` or any store directly — pure presentation
- `just quality` passes

---

### Phase 3 — Explorer App Routes

**Goal:** The Explorer app has all routes from Section 3.4, consuming SDK
components and state stores. Navigation works for both tourist and business
roles.

**Tasks:**

1. **Login page** — Adapt the inventory `mundial/login/+page.svelte`. Keep the
   Xibalbá branding, role selector buttons, glass aesthetic. Wire to
   `authStore.setRole()`. Tokenize all text.

2. **Tourist routes** — `/discover`, `/food/[id]`, `/saved`. Each page imports
   components from `@sdk/ui` and data from `@sdk/state`.

3. **Business routes** — `/dashboard`, `/profile`, `/menu`, `/menu/new`. Same
   pattern.

4. **Root layout** — Role-aware `+layout.svelte` with `RuneProvider`,
   conditional navigation, theme/locale support.

5. **`layout.css`** — Copy from inventory-src `layout.css` and add
   `@source "../../sdk/ui/dist"` for Tailwind to scan SDK components.

**Exit criteria:**

- `deno task explorer` launches and renders the login page
- Tourist flow: login → discover (map + cards) → tap card → detail → back → save
  → saved page shows it
- Business flow: login → dashboard (stats + products) → profile edit → menu →
  add dish form
- Language switcher works (at least en/es)
- Theme switcher works

---

### Phase 4 — DB Wiring (when ready)

**Goal:** Flip `@sdk/state` stores from hardcoded mock data to real SurrealDB
queries. Zero UI changes.

**Tasks (per store):**

| Store            | Action                                                                                        | DB Dependency                                                         |
| ---------------- | --------------------------------------------------------------------------------------------- | --------------------------------------------------------------------- |
| `authStore`      | Wire to API `/auth` (login, refresh). JWT in memory.                                          | Ready now.                                                            |
| `businessStore`  | Wire to SurrealDB npm client or API `/businesses`. Use `fn::businesses_near` for geo queries. | Ready now.                                                            |
| `geoStore`       | Wire to API `/zones` or direct SurrealDB query on `city` table.                               | Ready now.                                                            |
| `reviewStore`    | Wire to SurrealDB `review` table.                                                             | Ready now.                                                            |
| `analyticsStore` | Wire to DB computed fields (`business.rating`, `business.review_count`) + aggregate queries.  | Ready now for per-business. `// TODO(db): global aggregate queries`.  |
| `dishStore`      | Wire to new `dish` table when backend adds it.                                                | **Blocked.** `// TODO(db): Waiting for dish table + serves relation.` |
| `visitorStore`   | Wire `favorites` for businesses now. Wire dish saves when dish table exists.                  | **Partial.**                                                          |

---

## 5. Trade-off Analysis

### DECISION: Explorer as single app for tourist + business (vs. separate apps)

```
OPTIONS CONSIDERED:
  A. Keep Agent app separate for business owners — pros: clean separation,
     independent deploy / cons: agent app was removed from repo, would need
     to recreate it, doubles the deployment surface
  B. Merge both roles into Explorer — pros: matches current repo state
     (agent deleted), single deploy, shared auth flow, business owner can
     also "see as tourist" / cons: role-conditional layout adds complexity
CHOSEN: B — single Explorer app
REASON: The repo already reflects this decision (agent app folder is gone).
  A business owner who manages their dishes should also be able to switch
  to tourist view and see how their business appears to visitors. One app
  makes this seamless. The role-aware layout is simple: check authStore.role
  in +layout.svelte, render different nav items.
REVISIT IF: The business management features grow complex enough to warrant
  a separate deployment (e.g., document generation, PDF reports, Tauri
  desktop packaging for business-only use).
```

### DECISION: Hardcoded mock data first vs. DB wiring first

```
OPTIONS CONSIDERED:
  A. Wire to real DB immediately — pros: proves full stack / cons: dish
     table doesn't exist yet, blocks the hero feature
  B. Hardcoded mock data in @sdk/state, DB wiring later — pros: unblocks
     UI development, frontend team not blocked by backend / cons: mock
     data may diverge from real schema
  C. Hybrid: wire what's ready (business, review, geo), mock what's not
     (dish) — pros: best of both / cons: more complexity in stores
CHOSEN: C — hybrid approach
REASON: The DB already passes 27/27 tests. Business, review, city, geo,
  favorites, and user tables are all ready. Only the dish/menu domain is
  missing. Using real data where available makes the demo stronger and
  tests the SurrealDB integration path. Dishes get mock data with clear
  TODO comments.
REVISIT IF: Time pressure forces falling back to option B (all mock).
```

### DECISION: Where inventory-src lives long term

```
OPTIONS CONSIDERED:
  A. Keep inventory-src permanently as reference — pros: always available /
     cons: dead code in the repo
  B. Delete inventory-src after migration is complete — pros: clean repo /
     cons: loses reference
  C. Move to a docs/archive/ folder — pros: available but not in the build
     path / cons: minor effort
CHOSEN: B — delete after migration
REASON: Every useful piece will be in @sdk/ui or @sdk/state after
  migration. inventory-src is dead weight. Git history preserves it.
  Delete it once Phase 3 exit criteria are met.
REVISIT IF: Never — git history is sufficient.
```

---

## 6. Implementation Management

### Critical Path

```
@sdk/core types → @sdk/state stores (mock) → @sdk/ui primitives →
@sdk/ui DishCard + DishDetailModal → Explorer /discover route →
Explorer /login route → Demo
```

Everything else (business routes, profile editor, analytics) can be built in
parallel once the critical path is unblocked.

### Sequencing Rules

1. **Never** start a domain component before its types exist in `@sdk/core`
2. **Never** start an Explorer route before its components exist in `@sdk/ui`
3. **Always** create the primitive before the domain component that uses it
4. The `GlassCard` primitive is the very first thing to build — everything
   depends on it

### Ownership During Hackathon

| Task                                                                                               | Who                  | Hours Est. |
| -------------------------------------------------------------------------------------------------- | -------------------- | ---------- |
| `@sdk/core` all entities + constants                                                               | Lead                 | 2h         |
| `@sdk/ui` 7 primitives + tilt action + map-icons                                                   | Lead                 | 3h         |
| `@sdk/state` 7 stores with mock data                                                               | Lead                 | 2h         |
| `@sdk/ui` food components (DishCard, DishDetailModal, SavedDishCard, PlaceCard)                    | Frontend 1           | 4h         |
| `@sdk/ui` business components (BusinessProfileEditor, MerchantDashboard, DishForm, LocationPicker) | Frontend 2           | 4h         |
| `@sdk/ui` analytics + geo (StatsCard, BusinessDataTable, ZoneSelector)                             | Frontend 1 or 2      | 2h         |
| Explorer routes + layout                                                                           | Lead + both frontend | 4h         |
| i18n (en + es complete, 11 placeholders)                                                           | Split across team    | 1h         |
| DB: add `dish` table + `serves` relation + seed data                                               | Backend team         | 3h         |
| DB: wire ready stores (business, review, geo)                                                      | Lead                 | 2h         |

**Total estimated: ~27 person-hours.** With 5 people and 2 hackathon days (~10h
each), this is feasible with margin.

---

## 7. Validation

### Smoke Test Checklist (per component)

After each component is migrated, verify:

- [ ] Renders without console errors
- [ ] No Spanish hardcoded strings visible (all from `m.key()`)
- [ ] No `$` price formatting (uses `PriceTag` / `MoneyDisplay`)
- [ ] No inline glass classes (uses `GlassCard`)
- [ ] No duplicate category color maps (uses `CategoryBadge`)
- [ ] Props match `@sdk/core` types (not inline interfaces)
- [ ] No `fetch()` calls inside the component

### Explorer Flow Test (Phase 3)

- [ ] Login → select tourist → see discover page with map + cards
- [ ] Tap a card → see dish detail with nutrition + map
- [ ] Save a dish → see it in `/saved`
- [ ] Switch language → all UI updates
- [ ] Switch currency → prices update in `PriceTag`
- [ ] Login → select business → see dashboard with stats + dish grid
- [ ] Edit business profile → save → see updated data
- [ ] Add new dish → see it in the grid
- [ ] Toggle dish visibility → badge updates

### Architecture Fitness

- [ ] `grep -r "bg-neutral-900/60" sdk/ui/src/components/food/` returns 0 hits
- [ ] `grep -r "bg-neutral-900/60" sdk/ui/src/components/business/` returns 0
      hits
- [ ] `grep -r "\.toFixed" sdk/ui/src/` returns 0 hits
- [ ] `grep -r "from.*@sdk/state" sdk/core/src/` returns 0 hits
- [ ] `grep -r "from.*@sdk/ui" sdk/core/src/` returns 0 hits
- [ ] `grep -r "from.*@sdk/ui" sdk/state/src/` returns 0 hits

---

## 8. Open Questions

1. **Dish table schema:** The backend team needs to design the `dish` table for
   SurrealDB. Suggested fields to match the inventory data: `name`, `price`
   (integer cents), `category` (FK→category or string enum), `description`,
   `image_url`, `available` (bool), `ingredients` (array of strings),
   `nutrition` (embedded object: calories, fat, protein, carbs). Relation:
   `business -serves-> dish`. Should have FTS on `dish.name`.

2. **MoneyDisplay status:** Does the existing `@sdk/ui` `MoneyDisplay` component
   actually work, or is it a shell? If it's a shell, `PriceTag` must implement
   Dinero.js directly.

3. **rune-lab version compatibility:** inventory-src uses `rune-lab` 0.3.1 via
   npm/Bun. The Xibalbá client injects it locally via `inject-pkg.just`. Are the
   APIs (`RuneProvider`, `WorkspaceLayout`, `getLayoutStore`) identical?

4. **Image hosting for demo:** Inventory uses random food image URLs that may
   404. For a stable demo, either bundle 20-30 food photos as static assets in
   `apps/explorer/static/food/` or use a reliable placeholder service.
