# XIBALBÁ — Route Collapse & Deduplication Refactor Spec

> **Codename:** Ketzal Compact **Goal:** Collapse 12+ routes into 3 core views,
> eliminate every duplicated component, and establish a scalable
> horizontal/vertical directory structure where every piece lives in exactly one
> place.

---

## 0. Executive Summary

The current explorer app has 12 routes that fragment what are essentially 3 user
experiences: a public landing, a consumer (tourist) workspace, and an owner
(merchant/admin) workspace. Components are scattered across three layers —
`explorer/src/lib/components/`, `sdk/ui/src/components/`, and inline within
route files — with overlapping responsibilities. This refactor collapses the
routes into 3 shell views that swap content via components and `$state`, moves
all reusable UI into the SDK where it belongs, and establishes a rule: **routes
own layout composition, components own rendering, stores own data**. Nothing is
declared twice.

---

## 1. Context & Constraints

**Monorepo structure (current):**

```
src/client/
├── apps/
│   ├── explorer/     ← Main consumer app (SvelteKit)
│   └── vision/       ← Dev/showcase app (SvelteKit)
├── sdk/
│   ├── core/         ← Types, constants, entities
│   ├── state/        ← Svelte 5 rune stores
│   └── ui/           ← Shared components
└── scripts/
```

**Existing SDK UI component groups:**

- `analytics/` — StatsCard, BusinessDataTable
- `business/` — AdminDashboard, BusinessDetailModal, BusinessProfileEditor,
  DishForm, LocationPicker, MerchantCard, MerchantDashboard
- `food/` — DishCard, DishDetailModal, PlaceCard, SavedDishCard
- `geo/` — ZoneSelector
- `landing/` — HeroCarousel, RoleCards
- `layout/` — DynamicBackground, Footer, Navbar
- `map/` — MapView
- `primitives/` — BottomNav, CategoryBadge, EmptyState, FormInput, FormSelect,
  GlassCard, GlassContainer, ImageWithFallback, Navigation, PriceTag, QRCode,
  RatingDisplay, StatusBadge, SubmitButton

**rune-lab provides (DO NOT recreate):**

- `ThemeSelector`, `LanguageSelector`, `CurrencySelector`
- `Toaster` (notification toasts) — in `runes/palettes/notifications/`
- `CommandPalette` — in `runes/palettes/commands/`
- `ShortcutPalette` — in `runes/palettes/shortcuts/`
- `WorkspaceLayout`, `NavigationPanel`, `ContentArea`, `DetailPanel` — in
  `runes/layout/`
- `MoneyDisplay`, `MoneyInput` — in `runes/plugins/money/`
- Persistence layer, context system, registry

**Rules:**

- NO new npm packages
- If rune-lab already exposes it, use it — never wrap it, never reimplement it
- If daisyUI has a component class (`collapse`, `timeline`, `countdown`,
  `skeleton`, `toast`, etc.), use the class — never build a Svelte wrapper that
  just applies CSS classes
- The pretext code / mini-game is untouched

---

## 2. What's Wrong Right Now (Duplication Audit)

### 2.1 — Route Sprawl

| Current Route        | Actual Purpose                                 | Could Be                                       |
| -------------------- | ---------------------------------------------- | ---------------------------------------------- |
| `/`                  | Public landing                                 | **Keep as route** — homepage                   |
| `/discover`          | Consumer browse/search                         | **Tab inside consumer view**                   |
| `/saved`             | Consumer saved dishes                          | **Tab inside consumer view**                   |
| `/food/[id]`         | Dish detail (opens DishDetailModal fullscreen) | **Modal from any context** — not a route       |
| `/merchant/[id]`     | Merchant storefront                            | **Modal or panel from discover** — not a route |
| `/profile`           | Profile (switches by role)                     | **Tab inside consumer OR owner view**          |
| `/dashboard`         | Merchant dashboard                             | **Tab inside owner view**                      |
| `/menu`              | Merchant dish list                             | **Tab inside owner view**                      |
| `/menu/new`          | Add dish form                                  | **Modal or panel inside owner view**           |
| `/admin`             | Admin panel                                    | **Tab inside owner view** (role-gated)         |
| `/share`             | QR share page                                  | **Modal or panel inside owner view**           |
| `/login`             | Auth                                           | **Keep as route** — auth layout                |
| `/register`          | Auth                                           | **Keep as route** — auth layout                |
| `/merchant/register` | Merchant onboarding                            | **Keep as route** — auth layout group          |

**Verdict:** 14 routes → 5 routes (homepage, consumer, owner, auth/login,
auth/register+merchant-register)

### 2.2 — Component Duplication

| Component in Explorer                       | Already Exists In                     | Action                                                                   |
| ------------------------------------------- | ------------------------------------- | ------------------------------------------------------------------------ |
| `lib/components/AnimatedCounter.svelte`     | Nowhere — new                         | **Move to `sdk/ui/primitives/`**                                         |
| `lib/components/CountdownTimer.svelte`      | Nowhere — new                         | **Move to `sdk/ui/primitives/`**                                         |
| `lib/components/MerchantPreviewCard.svelte` | `sdk/ui/business/MerchantCard.svelte` | **DELETE** — extend MerchantCard with a `variant="preview"` prop instead |
| `routes/profile/AdminProfile.svelte`        | Nowhere — inline in route             | **Move to `sdk/ui/business/AdminProfile.svelte`**                        |
| `routes/profile/MerchantProfile.svelte`     | Nowhere — inline in route             | **Move to `sdk/ui/business/MerchantProfile.svelte`**                     |
| `routes/profile/TouristProfile.svelte`      | Nowhere — inline in route             | **Move to `sdk/ui/components/visitor/TouristProfile.svelte`**            |

### 2.3 — Things Already in rune-lab or daisyUI That Should NOT Be Re-built

| Feature the Steroids Spec Proposed | Already Exists                             | Use Instead                                                            |
| ---------------------------------- | ------------------------------------------ | ---------------------------------------------------------------------- |
| ToastManager                       | `rune-lab → Toaster.svelte`                | Import from `rune-lab`                                                 |
| Toast notification system          | `rune-lab → notifications/store.svelte.ts` | Use `notify()` from the store                                          |
| Skeleton loaders                   | daisyUI `skeleton` class                   | Just use `<div class="skeleton h-32 w-full">`                          |
| Countdown display                  | daisyUI `countdown` component              | Use `<span class="countdown"><span style="--value:{n}"></span></span>` |
| Timeline                           | daisyUI `timeline` component               | Use the timeline markup directly                                       |
| Progress indicators                | daisyUI `radial-progress` + `progress`     | Use the class directly                                                 |
| Collapse/accordion                 | daisyUI `collapse` component               | Use `<div class="collapse">`                                           |
| Steps indicator                    | daisyUI `steps` component                  | Use `<ul class="steps">`                                               |
| Tab navigation                     | daisyUI `tab` component                    | Use `<div role="tablist" class="tabs">`                                |
| Rating display                     | `sdk/ui/primitives/RatingDisplay.svelte`   | Already exists                                                         |
| Empty states                       | `sdk/ui/primitives/EmptyState.svelte`      | Already exists                                                         |
| Category badges                    | `sdk/ui/primitives/CategoryBadge.svelte`   | Already exists                                                         |

[HIGH RISK] The steroids spec proposed 16 new components. After this audit, only
**3 are genuinely new** (AnimatedCounter, CountdownTimer, and the ScrollToTop
button — the rest either exist already or are daisyUI CSS classes). Building
wrappers around daisyUI classes creates a maintenance trap where you're fighting
the framework instead of using it.

---

## 3. Target Architecture

### 3.1 — The 3 Core Views

**View 1: Homepage** (`/`) Public landing. No auth required. Composition of:
Navbar → HeroCarousel → RoleCards → new sections (stats, how-it-works,
countdown, featured merchants, testimonials) → Footer. All content is in
components imported from `@sdk/ui` and `explorer/lib/components/` (for
explorer-specific compositions). The BottomNav appears here and everywhere.

**View 2: Consumer** (`/explore`) The tourist workspace. A single route with
tabbed navigation (daisyUI `tabs` or BottomNav-driven `$state`). Tabs:

| Tab      | Content (component)                          | Replaces Route            |
| -------- | -------------------------------------------- | ------------------------- |
| Discover | DiscoverView (map + filters + business grid) | `/discover`               |
| Saved    | SavedView (saved dishes grouped by merchant) | `/saved`                  |
| Profile  | TouristProfile                               | `/profile` (tourist role) |

The dish detail (`/food/[id]`) becomes a **modal** opened from any tab via
`DishDetailModal`. The merchant storefront (`/merchant/[id]`) becomes a
**modal** opened from discover via `BusinessDetailModal`. No dedicated routes
for these — they're overlay states managed by `$state` variables in the consumer
layout.

**View 3: Owner** (`/owner`) The merchant/admin workspace. A single route with
sidebar or tab navigation. Tabs:

| Tab       | Content (component)                        | Replaces Route                   |
| --------- | ------------------------------------------ | -------------------------------- |
| Dashboard | DashboardView (stats + activity + revenue) | `/dashboard`                     |
| Menu      | MenuView (dish list + add/edit modals)     | `/menu` + `/menu/new`            |
| Profile   | MerchantProfile or AdminProfile            | `/profile` (business/admin role) |
| Share     | ShareView (QR + social buttons)            | `/share`                         |
| Admin     | AdminView (merchant management + logs)     | `/admin` (role-gated)            |

The "add new dish" (`/menu/new`) becomes a **modal** inside the Menu tab, not a
route.

**Auth routes stay as routes** — they have a different layout (no navbar, no
bottom nav), so SvelteKit's layout groups make sense:

- `/(auth)/login`
- `/(auth)/register`
- `/(auth)/merchant-register` (move from `/merchant/register`)

### 3.2 — Route Structure (After)

```
routes/
├── +layout.svelte              ← RuneProvider + global providers
├── +layout.ts                  ← prerender, ssr config
├── +page.svelte                ← Homepage (public landing)
├── layout.css                  ← Tailwind + daisyUI + team-styles
├── (auth)/
│   ├── +layout.svelte          ← Minimal auth layout (no navbar)
│   ├── login/+page.svelte
│   ├── register/+page.svelte
│   └── merchant-register/+page.svelte
├── explore/
│   └── +page.svelte            ← Consumer shell (tabs: discover, saved, profile)
├── owner/
│   └── +page.svelte            ← Owner shell (tabs: dashboard, menu, profile, share, admin)
└── team-styles/                ← CSS files (unchanged)
```

**That's 6 route files** (homepage, login, register, merchant-register, explore,
owner) **down from 14**. And 4 of those are tiny auth pages.

### 3.3 — Why Tabs Instead of Routes

**Pattern:** Svelte 5 Runes make component-driven views trivial. A `$state`
variable like `activeTab` swapping which component renders is cheaper, faster,
and more composable than a route change. The URL can still reflect the active
tab via `replaceState` + `$effect` (e.g., `/explore?tab=saved`) without
requiring SvelteKit's full route lifecycle.

**Why this wins at year 3:** Adding a new tab (e.g., "Orders", "Analytics",
"Chat") means adding one component file and one entry in the tab array — zero
new routes, zero new layout files, zero new `+page.ts` files.

**Why this wins at year 5:** The consumer and owner shells become pluggable — a
different app (e.g., a Tauri native wrapper) can import the same tab components
without SvelteKit at all, because the components don't depend on `$page`,
`goto()`, or any SvelteKit-specific API.

**Why this wins at year 10:** The tab components are portable across any Svelte
rendering host — SSR, CSR, native, embedded — because they're pure components
with props and stores, not route-coupled pages.

[ASSUMPTION] SvelteKit's static adapter + `ssr: false` means the app is already
a client-side SPA — route changes are already client-side navigations, so the
perf difference between routes and `$state` tabs is negligible. Tabs win on DX
and portability.

---

## 4. Component Ownership Rules

Every component lives in **exactly one** of these layers. If you're about to
create a component, ask which layer it belongs to:

### Layer 1: `sdk/core/` — Types and constants only

- Entity types (Dish, Business, Visitor, etc.)
- Constants (DISH_CATEGORIES, etc.)
- **NEVER** contains Svelte components, stores, or UI

### Layer 2: `sdk/state/` — Stores only

- Svelte 5 rune-based stores (`$state`, `$derived`, `$effect`)
- One store file per entity domain
- **NEVER** imports from `sdk/ui` — state flows downward
- **NEVER** contains UI logic, formatting, or rendering

### Layer 3: `sdk/ui/` — Reusable components

- **Rule:** A component belongs here if it could be used by BOTH `explorer` and
  `vision` (or any future app)
- **Rule:** Must accept data via props, never via direct store access — the
  consuming app passes store data in
- **Rule:** Never imports from `rune-lab` — if it needs theme/i18n, it receives
  it via props or Svelte context
- **Rule:** Never wraps a daisyUI component that only applies CSS classes — just
  use the class directly in the consuming component

### Layer 4: `explorer/src/lib/components/` — App-specific compositions

- Components that are specific to the explorer app's UX (e.g., AnimatedCounter
  for the landing page)
- **Rule:** If you find yourself importing this component in `vision/` or
  another app, it belongs in `sdk/ui/` instead
- **Rule:** These components MAY access stores directly and MAY import from
  `rune-lab`
- Keep this layer as thin as possible — most things should be in `sdk/ui/`

### Layer 5: `explorer/src/routes/` — Route shells only

- Route files (`+page.svelte`) are **pure composition** — they import components
  and wire them together
- **Rule:** A route file should be under 80 lines. If it's longer, extract a
  component
- **Rule:** No business logic in routes. No data transformations. No complex
  markup
- **Rule:** Route files are the only place that uses SvelteKit-specific APIs
  (`$page`, `goto`, `$app/*`)

### Layer 6: `rune-lab` — Framework utilities (READ-ONLY)

- Toaster, CommandPalette, ThemeSelector, LanguageSelector, CurrencySelector,
  MoneyDisplay, etc.
- **NEVER** recreate, wrap, or extend these — import and use directly
- If you need behavior rune-lab doesn't have, contribute upstream — don't fork
  locally

---

## 5. SDK UI Directory Restructure

### Current:

```
sdk/ui/src/components/
├── analytics/     → StatsCard, BusinessDataTable
├── business/      → AdminDashboard, BusinessDetailModal, BusinessProfileEditor,
│                    DishForm, LocationPicker, MerchantCard, MerchantDashboard
├── food/          → DishCard, DishDetailModal, PlaceCard, SavedDishCard
├── geo/           → ZoneSelector
├── landing/       → HeroCarousel, RoleCards
├── layout/        → DynamicBackground, Footer, Navbar
├── map/           → MapView
└── primitives/    → BottomNav, CategoryBadge, EmptyState, FormInput, FormSelect,
                     GlassCard, GlassContainer, ImageWithFallback, Navigation,
                     PriceTag, QRCode, RatingDisplay, StatusBadge, SubmitButton
```

### Problems:

1. **`business/` is a dumping ground** — it has admin UI, merchant UI, dish
   forms, and location pickers all in one folder
2. **`primitives/` mixes concerns** — BottomNav and Navigation are layout
   components, not primitives; QRCode is a utility, not a primitive alongside
   FormInput
3. **No `visitor/` domain** — tourist-specific components (TouristProfile,
   SavedDishCard) are scattered
4. **Profile components live in routes** instead of the SDK

### Target:

```
sdk/ui/src/components/
├── primitives/          ← Pure UI atoms. No domain logic. No store access.
│   ├── GlassCard.svelte
│   ├── GlassContainer.svelte
│   ├── FormInput.svelte
│   ├── FormSelect.svelte
│   ├── SubmitButton.svelte
│   ├── PriceTag.svelte
│   ├── StatusBadge.svelte
│   ├── CategoryBadge.svelte
│   ├── RatingDisplay.svelte
│   ├── ImageWithFallback.svelte
│   ├── EmptyState.svelte
│   ├── AnimatedCounter.svelte    ← MOVE from explorer/lib/components/
│   ├── CountdownTimer.svelte     ← MOVE from explorer/lib/components/
│   └── mod.ts
│
├── layout/              ← App-level structural components
│   ├── Navbar.svelte
│   ├── Footer.svelte
│   ├── BottomNav.svelte          ← MOVE from primitives/
│   ├── Navigation.svelte         ← MOVE from primitives/
│   ├── DynamicBackground.svelte
│   └── mod.ts
│
├── landing/             ← Public homepage sections (no auth)
│   ├── HeroCarousel.svelte
│   ├── RoleCards.svelte
│   └── mod.ts
│
├── discover/            ← Consumer discovery experience
│   ├── MapView.svelte            ← MOVE from map/
│   ├── ZoneSelector.svelte       ← MOVE from geo/
│   ├── DishCard.svelte           ← MOVE from food/
│   ├── DishDetailModal.svelte    ← MOVE from food/
│   ├── PlaceCard.svelte          ← MOVE from food/
│   ├── BusinessDetailModal.svelte ← MOVE from business/
│   ├── MerchantCard.svelte       ← MOVE from business/ (absorbs MerchantPreviewCard)
│   └── mod.ts
│
├── visitor/             ← NEW: Tourist/consumer-specific
│   ├── SavedDishCard.svelte      ← MOVE from food/
│   ├── TouristProfile.svelte     ← MOVE from explorer routes/profile/
│   └── mod.ts
│
├── merchant/            ← Merchant/owner workspace
│   ├── MerchantDashboard.svelte  ← MOVE from business/
│   ├── BusinessProfileEditor.svelte ← MOVE from business/
│   ├── MerchantProfile.svelte    ← MOVE from explorer routes/profile/
│   ├── DishForm.svelte           ← MOVE from business/
│   ├── LocationPicker.svelte     ← MOVE from business/
│   └── mod.ts
│
├── admin/               ← Admin-specific (role-gated)
│   ├── AdminDashboard.svelte     ← MOVE from business/
│   ├── AdminProfile.svelte       ← MOVE from explorer routes/profile/
│   └── mod.ts
│
├── analytics/           ← Data display components
│   ├── StatsCard.svelte
│   ├── BusinessDataTable.svelte
│   └── mod.ts
│
├── share/               ← QR + social share
│   ├── QRCode.svelte             ← MOVE from primitives/
│   └── mod.ts
│
└── mod.ts               ← Root barrel, re-exports all sub-modules
```

### What Changed:

- **Deleted `business/`** — it was a god-folder. Components now live in
  domain-specific folders (`discover/`, `merchant/`, `admin/`)
- **Deleted `food/`** — dish-related components moved to `discover/` (where
  they're consumed) or `visitor/` (saved dishes)
- **Deleted `geo/`** and **`map/`** — merged into `discover/` because
  ZoneSelector and MapView are only used in the discovery context
- **Moved BottomNav + Navigation** from `primitives/` to `layout/` — they're
  structural, not atomic
- **Moved QRCode** from `primitives/` to `share/` — it's a feature component,
  not a form primitive
- **Created `visitor/`** — tourist-specific components have a home
- **Created `admin/`** — admin components separated from merchant components
- **Moved AnimatedCounter + CountdownTimer** from explorer into
  `sdk/ui/primitives/` — they're reusable atoms

---

## 6. Explorer App Directory (After)

```
explorer/src/
├── app.d.ts
├── app.html
├── hooks.server.ts
├── hooks.ts
├── service-worker.ts
├── lib/
│   ├── index.ts
│   ├── pwa.svelte.ts
│   ├── teams.json
│   ├── components/            ← App-specific compositions ONLY
│   │   ├── HomepageStats.svelte      ← Stats bar for landing page
│   │   ├── HowItWorks.svelte         ← Three-step section
│   │   ├── FeaturedMerchants.svelte   ← Horizontal carousel
│   │   ├── CulturalShowcase.svelte    ← Theme adaptation showcase
│   │   ├── ConsumerShell.svelte       ← Tab manager for /explore
│   │   ├── OwnerShell.svelte          ← Tab manager for /owner
│   │   └── ScrollToTop.svelte         ← Floating button
│   ├── views/                 ← Tab content panels (one per tab)
│   │   ├── DiscoverView.svelte        ← Was /discover/+page.svelte
│   │   ├── SavedView.svelte           ← Was /saved/+page.svelte
│   │   ├── DashboardView.svelte       ← Was /dashboard/+page.svelte
│   │   ├── MenuView.svelte            ← Was /menu/+page.svelte (includes add modal)
│   │   ├── AdminView.svelte           ← Was /admin/+page.svelte
│   │   └── ShareView.svelte           ← Was /share/+page.svelte
│   └── i18n/
│       └── messages/ (unchanged)
└── routes/
    ├── +layout.svelte
    ├── +layout.ts
    ├── +page.svelte            ← Homepage: imports from lib/components/
    ├── layout.css
    ├── (auth)/
    │   ├── +layout.svelte
    │   ├── login/+page.svelte
    │   ├── register/+page.svelte
    │   └── merchant-register/+page.svelte
    ├── explore/
    │   └── +page.svelte        ← ~30 lines: imports ConsumerShell
    ├── owner/
    │   └── +page.svelte        ← ~30 lines: imports OwnerShell
    └── team-styles/ (unchanged)
```

### Key Principle: `views/` vs `components/`

- **`components/`** — Reusable compositions. A shell, a section, a widget. They
  don't know which tab they're in.
- **`views/`** — Full tab panels. Each view is a self-contained screen that was
  previously a route. They import from `@sdk/ui` and `@sdk/state`. They DO know
  they're a tab and may communicate with the shell via props/events.

The route file for `/explore/+page.svelte` becomes approximately:

```
Imports ConsumerShell
Reads $page.url.searchParams for initial tab
Renders ConsumerShell with initialTab prop
```

That's it. ~30 lines. All the real UI lives in views and components.

---

## 7. Migration Moves (Ordered by Dependency)

Each move is independently shippable. Do them in this order to avoid breaking
imports:

### Move 1: SDK UI restructure

- Create new folders: `discover/`, `visitor/`, `merchant/`, `admin/`, `share/`
- Move files as specified in section 5
- Update all `mod.ts` barrel exports
- Update `sdk/ui/src/mod.ts` root barrel
- Run the app — all imports should resolve via the barrel

### Move 2: Extract profile components from routes to SDK

- Move `AdminProfile.svelte` → `sdk/ui/admin/`
- Move `MerchantProfile.svelte` → `sdk/ui/merchant/`
- Move `TouristProfile.svelte` → `sdk/ui/visitor/`
- Update `/profile/+page.svelte` to import from `@sdk/ui` instead of relative
  paths
- Verify profile page still works

### Move 3: Extract route pages into views

- Copy content of `/discover/+page.svelte` →
  `explorer/lib/views/DiscoverView.svelte`
- Replace any `goto()` calls with event dispatches (the shell handles
  navigation)
- Replace any `$page` reads with props
- Repeat for: saved, dashboard, menu, admin, share
- Do NOT delete the old routes yet — they can coexist during migration

### Move 4: Build the shells

- Create `ConsumerShell.svelte` — manages tabs: Discover, Saved, Profile
- Create `OwnerShell.svelte` — manages tabs: Dashboard, Menu, Profile, Share,
  Admin
- Each shell: a `$state activeTab`, a tab bar (daisyUI tabs or BottomNav), and a
  `{#if}` block that renders the matching view
- URL sync: `$effect` that calls `replaceState` when tab changes, reads
  `searchParams.get('tab')` on mount

### Move 5: Create new routes, delete old ones

- Create `/explore/+page.svelte` — imports ConsumerShell
- Create `/owner/+page.svelte` — imports OwnerShell
- Move `/merchant/register/+page.svelte` →
  `/(auth)/merchant-register/+page.svelte`
- Delete: `/discover/`, `/saved/`, `/food/`, `/dashboard/`, `/menu/`,
  `/merchant/`, `/profile/`, `/admin/`, `/share/`
- Update all internal links (`<a href=...>`) and `goto()` calls
- Update Navbar and BottomNav link targets

### Move 6: Delete explorer/lib/components duplicates

- Delete `MerchantPreviewCard.svelte` — use `MerchantCard` with variant prop
- Move `AnimatedCounter.svelte` → `sdk/ui/primitives/`
- Move `CountdownTimer.svelte` → `sdk/ui/primitives/`
- Delete the now-empty `explorer/lib/components/` originals

---

## 8. Trade-Off Analysis

```
DECISION: Tabs-in-a-route vs. many routes
OPTIONS CONSIDERED:
  A. Keep 14 routes — each page is its own SvelteKit route
     pros: URL-native, each page independently loadable, standard SvelteKit pattern
     cons: route sprawl, layout duplication, components coupled to SvelteKit APIs
  B. Collapse to 3 views with $state tabs + URL sync
     pros: fewer files, components portable, trivial to add tabs, shared shell state
     cons: no per-tab code splitting (all tabs load at once), non-standard for SvelteKit
  C. Use SvelteKit nested layouts with sub-routes
     pros: code splitting, URL-native, layout inheritance
     cons: still many route files, complex layout nesting, SvelteKit coupling remains
CHOSEN: B — $state tabs with URL sync
REASON: The app uses `adapter-static` with `ssr: false` — it's already a client-side SPA.
  Code splitting is irrelevant because the entire bundle ships on first load. The portability
  gain (components work without SvelteKit) outweighs the code-splitting loss. Tab additions
  become a one-line change. At year 3, new features are tabs, not routes. At year 5, the
  components power a Tauri native app without modification.
REVISIT IF: The app moves to SSR, or bundle size exceeds 500KB and per-route splitting
  becomes necessary.
```

```
DECISION: Where do domain components live — SDK or explorer?
OPTIONS CONSIDERED:
  A. Everything in SDK — explorer routes are pure shells
     pros: maximum reuse, single source of truth, vision app can showcase everything
     cons: SDK grows large, some components are truly explorer-specific
  B. Domain components in SDK, app-specific compositions in explorer
     pros: clear boundary, SDK stays generic, explorer owns its UX
     cons: need discipline to enforce the boundary
  C. Everything in explorer — SDK only has primitives
     pros: simple, no cross-package decisions
     cons: vision app can't use anything, zero reuse, duplication inevitable
CHOSEN: B — Domain in SDK, compositions in explorer
REASON: The SDK already has domain components (DishCard, MerchantDashboard, etc.) and
  rune-lab provides the framework layer. Explorer should only own what's unique to its UX
  (homepage sections, shell managers, view compositions). The vision app already imports from
  the SDK for its showcase — this pattern is proven. The boundary rule is simple: "Would
  another app want this?" If yes → SDK. If no → explorer.
REVISIT IF: A third app is created and the boundary gets fuzzy.
```

```
DECISION: What to do about /food/[id] and /merchant/[id] dynamic routes
OPTIONS CONSIDERED:
  A. Keep as routes — they have unique URLs for deep-linking and sharing
     pros: shareable URLs, SEO (if SSR enabled later), browser back/forward works
     cons: adds 2 routes, couples detail views to SvelteKit
  B. Convert to modals with URL state (?dish=abc&merchant=xyz)
     pros: fewer routes, detail views are reusable overlays, smoother UX transitions
     cons: query params are less clean than path segments, sharing a "?dish=abc" URL is uglier
  C. Convert to modals with NO URL state
     pros: simplest, zero route overhead
     cons: not shareable, back button doesn't close modal, breaks expected web behavior
CHOSEN: B — Modals with query param URL state
REASON: The app already uses DishDetailModal and BusinessDetailModal as overlay components.
  Converting them from route-triggered to state-triggered with query param sync gives the
  best of both worlds — smooth modal transitions AND shareable URLs. The consumer shell's
  $effect reads searchParams on mount and opens the appropriate modal. [ASSUMPTION] Deep
  linking to a specific dish (/explore?dish=abc) is acceptable UX for sharing.
REVISIT IF: SEO becomes important (i.e., SSR + crawlable individual dish pages).
```

---

## 9. Validation Strategy

| What to Verify                         | How                                                                                                           |
| -------------------------------------- | ------------------------------------------------------------------------------------------------------------- |
| No component is declared in two places | Script: grep for component name across all `.svelte` files — must appear as definition in exactly 1 file      |
| All old routes redirect or are removed | Manual: visit every old URL, confirm 404 or redirect                                                          |
| Tab URL sync works                     | Manual: change tabs, verify URL updates; paste URL in new tab, verify correct tab opens                       |
| Modal deep links work                  | Manual: copy `?dish=abc` URL, open in incognito, verify modal opens                                           |
| SDK barrel exports are complete        | Script: import `* from "@sdk/ui"` in a test file, verify every component is accessible                        |
| No SvelteKit API leaks into views      | Script: grep for `$page`, `goto`, `$app/` inside `lib/views/` — must be zero matches                          |
| rune-lab features are not duplicated   | Script: grep for "Toaster", "CommandPalette", "ThemeSelector" in `sdk/` — must be zero matches (only imports) |

---

## 10. Open Questions & Risks

- [HIGH RISK] Moving files across workspace packages (`explorer/` → `sdk/ui/`)
  may break Vite's module resolution cache. After moves, run a clean build
  (`rm -rf .svelte-kit node_modules/.vite && pnpm install`).
- [REVISIT] The `food/[id]` route currently uses `onMount` + `goto` for fallback
  behavior. When converting to modal, this logic moves into the consumer shell's
  `$effect`. Verify the timing is equivalent.
- [ASSUMPTION] The BottomNav component can be adapted to emit tab-change events
  instead of `<a href>` navigation. If it's hardcoded with `<a>` tags, it needs
  a `mode="tabs"` prop that uses `onclick` + `event.preventDefault()` instead.
- [ASSUMPTION] `authStore.role` is accessible synchronously to gate the Admin
  tab in the owner shell. If it's async, the shell needs a loading state.
- The `vision` app imports from `@sdk/ui` — verify it still works after the
  restructure by running its dev server.
