# XIBALBÁ — UI STEROIDS SPEC

> **Codename:** Kron Ascension **Goal:** Bring every page in the Explorer app to
> the visual and interaction quality of `/discover` — the gold standard.
> **Constraint:** ZERO new libraries. Only what's already in the workspace:
> `@sdk/ui`, `@sdk/core`, `@sdk/state`, `rune-lab`, `lucide-svelte`,
> `daisyUI 5`, `Tailwind CSS 4`. **Pretext mini-game:** UNTOUCHED. Keep it
> exactly as-is at the top of the layout.

---

## 0. Executive Summary

The `/discover` page is cinematic — full-bleed map, glassmorphism HUD, 3D cards,
animated toasts, vibe filters, and a "Command Center" feel. Every other page in
the app feels like a wireframe by comparison. This spec defines a
feature-per-feature injection to close that gap across all user-facing routes:
the Welcome page (`+page.svelte`), Dashboard, Admin, Menu, Merchant storefront,
Profile (all three roles), Saved, Share, Auth (login/register), and Merchant
Registration. Each section below is a self-contained enhancement ticket — they
can be implemented in any order, in parallel, and none depend on each other.
Even if the features are mocked/non-functional initially, the UI must feel
alive.

---

## 1. Context & Constraints

- **Stack:** Svelte 5 (Runes), SvelteKit (static adapter), Tailwind 4, daisyUI
  5, `rune-lab` (ThemeSelector, LanguageSelector, CurrencySelector,
  RuneProvider, LayoutPlugin, PalettesPlugin, MoneyPlugin)
- **SDK:** `@sdk/ui` exports: GlassContainer, GlassCard, DishCard,
  DishDetailModal, BusinessDetailModal, MapView, ZoneSelector, Navbar, Footer,
  BottomNav, HeroCarousel, RoleCards, AdminDashboard, MerchantDashboard,
  BusinessProfileEditor, LocationPicker, FormInput, SubmitButton, QRCode,
  SavedDishCard, DishForm, PriceTag, StatusBadge, StatsCard, ICONS, m (i18n)
- **SDK State:** `@sdk/state` exports: createDishStore, createGeoStore,
  createBusinessStore, createVisitorStore, authStore
- **SDK Core:** `@sdk/core` exports: DISH_CATEGORIES, types (Dish, Business,
  DishFormData)
- **Rule:** NO new npm packages. Everything built with existing primitives.
- **Rule:** The pretext code / mini-game at the top of the layout is sacred — do
  not modify it.
- [ASSUMPTION] The SDK components (GlassCard, GlassContainer, MapView, etc.) are
  stable and accept `class` prop for customization.
- [ASSUMPTION] daisyUI themes are fully wired via `rune-lab` — any daisyUI
  semantic color is available.
- [ASSUMPTION] All `lucide-svelte` icons are available since the package is
  installed.

---

## 2. Design Language Reference (Extracted from `/discover`)

Before implementing anything, internalize the visual DNA that makes `/discover`
special. Every enhancement below must match this language:

**Glassmorphism:** `backdrop-blur-2xl`, `bg-base-100/60`,
`border border-white/10`, `shadow-[0_40px_80px_-20px_rgba(0,0,0,0.6)]`

**Typography:** Oversized headings
(`text-6xl font-black uppercase tracking-[calc(-0.05em)] italic`), micro-labels
(`text-[10px] font-black uppercase tracking-widest opacity-40`), gradient text
via `text-transparent bg-clip-text bg-gradient-to-br`

**Cards:** Use `GlassCard` with `enable3D={true}`, `glowColor`, oversized
rounded corners (`rounded-[2rem]`), hover elevation (`group-hover:scale-110`,
`hover:-translate-y-1`), gradient overlays on images

**Animation:** CSS `@keyframes` for width-reveal, `animate-pulse` on live
indicators, `animate-bounce` on CTAs,
`transition-all duration-500`/`duration-700`/`duration-1000` for hover states,
`animate-in fade-in slide-in-from-bottom-4`

**Spatial hierarchy:** Full-bleed hero zones (70vh), gradient masks
(`bg-gradient-to-t from-base-100 via-base-100/60 to-transparent`), floating HUDs
positioned `absolute` over content, negative margin overlaps (`-mt-6`)

**Micro-interactions:** Pill-shaped filter buttons with active state glow
(`shadow-xl shadow-primary/40 -translate-y-1`), search input with pulsing icon
and blur halo, status dots with `animate-pulse` for "open" state

**Color system:** Always use daisyUI semantic tokens — `primary`, `secondary`,
`accent`, `base-100/200/300`, `base-content`, `success`, `warning`, `error`.
Opacity via `/30`, `/50`, `/60`. Never hardcode hex colors except for
category-specific accent colors in data arrays.

---

## 3. Page-by-Page Enhancement Spec

---

### 3.1 Welcome Page (`/` — `+page.svelte`)

**Current state:** Navbar → HeroCarousel → RoleCards → Footer. Clean but flat.

**Enhancements to add (below HeroCarousel + RoleCards, keep those untouched):**

**3.1.1 — Live Pulse Stats Bar** A horizontal glass strip below the hero showing
animated counters: "Negocios Activos", "Turistas Conectados", "Platillos
Disponibles", "Países Representados". Each counter has a StatsCard-style icon, a
big number using `text-4xl font-black`, and a micro-label. The numbers should
use a `$state` that increments on mount with a staggered `setInterval` to
simulate live counting (e.g., 0 → 847 over 2 seconds using easing). Wrap in
`GlassContainer` with the discover-style giant border radius (`!rounded-[3rem]`)
and `shadow-[0_30px_60px_-15px_rgba(0,0,0,0.3)]`.

**3.1.2 — "How It Works" Triple-Step Section** Three `GlassCard` components in a
horizontal grid (`grid-cols-1 md:grid-cols-3`). Each card: a large numbered
circle
(`w-16 h-16 rounded-full bg-primary/20 text-primary text-2xl font-black`), a
title, and a one-liner. Cards: (1) "Explora" with ICONS.search, (2) "Elige" with
ICONS.star, (3) "Visita" with ICONS.map_pin. Each card gets `enable3D={true}`. A
connecting dashed line between cards on desktop using
`border-dashed border-t-2 border-primary/20` positioned absolutely.

**3.1.3 — World Cup Countdown Timer** A glass banner with a live countdown to
World Cup 2026 opening ceremony (June 11, 2026). Four "flip-clock" style blocks
(days, hours, minutes, seconds) each in a `GlassCard` with
`text-5xl font-black font-mono`. Below: "El mundo viene a México. ¿Tu negocio
está listo?" in gradient text. A CTA button: "Registra tu Comercio" linking to
`/merchant/register` with `btn-primary shadow-lg shadow-primary/30`.

**3.1.4 — Featured Merchants Carousel** A horizontally scrollable row of
merchant preview cards (mocked data, 8-10 items). Each card: rounded image with
gradient overlay, merchant name, category badge, rating stars, "open now" pulse
dot. Use `overflow-x-auto scrollbar-hide` with `snap-x snap-mandatory`. Each
card is `snap-center flex-shrink-0 w-72`. On hover, card lifts
(`hover:-translate-y-2 transition-transform duration-500`).

**3.1.5 — Cultural Adaptivity Showcase** A full-width dark section
(`bg-neutral text-neutral-content`) with the heading "Tu País, Tu Experiencia"
in gradient text. Show 4-5 flag icons from the team themes (🇲🇽 🇯🇵 🇧🇷 🇩🇪 🇸🇦) in
large circles. Below each flag, a small mockup-style card showing how the theme
adapts (just show the flag + theme name + accent color swatch). The point is to
visually communicate the "cultural adaptation" feature. Use `GlassCard` for
each.

**3.1.6 — Testimonials / Social Proof Strip** Three horizontal `GlassCard` with
fake testimonials. Each: avatar circle (ICONS.user with colored bg), quote text
in italic, name + role ("María G. — Taquera en CDMX"). Subtle
`border-l-4 border-primary` accent on each card.

---

### 3.2 Dashboard (`/dashboard`)

**Current state:** Title → stats grid (2 cards) → BusinessProfileEditor →
MerchantDashboard list. Functional but sterile.

**3.2.1 — Welcome Banner with Greeting** At the top, a full-width glass banner
with `bg-gradient-to-r from-primary/10 to-secondary/10`. Shows a greeting based
on time of day ("Buenos Días / Tardes / Noches") using `$derived` from
`new Date().getHours()`. Include merchant name from authStore, a motivational
micro-line ("Tu menú tiene 12 platillos activos"), and a small animated wave
emoji or sun/moon icon.

**3.2.2 — Expanded Stats Grid (4 cards)** Add two more StatsCard instances:
"Vistas del Perfil" (eye icon, trend "up"), and "Valoración Promedio" (star
icon, show rating like 4.7). Arrange as `grid-cols-2 lg:grid-cols-4`. Each card
gets a subtle colored top border (`border-t-4 border-primary` / `border-success`
/ etc.) and a hover glow effect.

**3.2.3 — Quick Actions Row** A row of 4 pill-shaped action buttons below the
stats: "Añadir Platillo" (primary), "Editar Horario" (secondary), "Ver
Analíticas" (accent), "Compartir QR" (info). Each button: icon + label,
`GlassCard` style, hover lift. Links to respective pages or opens a placeholder
modal.

**3.2.4 — Revenue Mini-Chart Placeholder** A `GlassCard` with title "Ingresos
Estimados (7 días)" and a simple bar chart built with pure CSS (7 vertical `div`
bars with varying heights using inline `style="height: {value}%"`, colored
`bg-primary` with `rounded-t-lg`). X-axis labels for days of week. Even if data
is fake, the visual gives the dashboard a "real analytics" feel.

**3.2.5 — Recent Activity Feed** A vertical list of 5-6 mocked events: "Nuevo
pedido de Tacos al Pastor", "Reseña de ⭐⭐⭐⭐⭐ recibida", "Perfil visto 23
veces hoy". Each item: timestamp on the left (`text-[10px] opacity-40`), colored
dot indicator, event description. Wrap in `GlassContainer` with
`divide-y divide-base-content/5`.

---

### 3.3 Admin Panel (`/admin`)

**Current state:** Three stat cards → AdminDashboard merchant table. Looks like
a generic admin page.

**3.3.1 — Admin Hero Banner** Replace the plain title with a dark glass banner:
`bg-gradient-to-r from-error/10 via-base-100 to-error/5`. Show the admin icon
large and glowing (`drop-shadow-[0_0_20px_rgba(255,0,0,0.4)]`), title "CENTRO DE
CONTROL" in all-caps `text-4xl font-black tracking-[0.2em]`, and a subtitle
"Sesión Root Activa • Nivel de Acceso: Máximo" with a blinking red dot
(`animate-pulse bg-error`).

**3.3.2 — Platform Health Dashboard Row** Below stats, add a horizontal strip of
5 mini metric cards: "Uptime" (99.9%), "Latencia" (42ms), "Sesiones Activas"
(1,234), "Errores 24h" (3), "Caché Hit Rate" (94%). Each card: icon, big number,
micro-label. Use conditional coloring — green for healthy, yellow for warning,
red for critical. All mocked but looks like a real ops dashboard.

**3.3.3 — Merchant Approval Queue with Rich Cards** Instead of just the
AdminDashboard table, add above it a "Pendientes de Aprobación" section using
`GlassCard` for each pending merchant. Each card: business name, category,
registration date, a truncated description, and two action buttons ("Aprobar" in
success, "Rechazar" in error). Cards have a yellow left border
(`border-l-4 border-warning`) for pending status.

**3.3.4 — System Event Log Panel** A `GlassContainer` styled like a
terminal/console: `bg-neutral text-neutral-content font-mono text-xs`. Show
10-15 mocked log lines with timestamps, severity badges (INFO in blue, WARN in
yellow, ERROR in red), and event descriptions. Auto-scroll feeling (just show
the list, no actual scrolling needed). Title: "Event Stream" with a green
pulsing dot.

**3.3.5 — Geographic Heat Indicator** A simple visual showing "Zonas Más
Activas" — a row of 5 zone names with horizontal bar charts (pure CSS bars,
`bg-primary` with varying widths). Zones: "Centro Histórico (89%)", "Zona Rosa
(72%)", "Coyoacán (65%)", "Santa Fe (41%)", "Xochimilco (28%)".

---

### 3.4 Menu Management (`/menu`)

**Current state:** Title + grid of GlassCards with dish name, category, price,
status. Functional but bland.

**3.4.1 — Menu Header with Search & Filters** Add a search input
(discover-style: glass background, pulsing search icon, rounded-full) and
category filter pills below the title. Categories from DISH_CATEGORIES. Active
pill gets
`bg-primary text-primary-content shadow-xl shadow-primary/40 -translate-y-1`.

**3.4.2 — Enhanced Dish Cards** Each dish card gets: a placeholder image area
(`h-32 rounded-2xl bg-gradient-to-br from-primary/5 to-secondary/5` with a
centered fork-knife icon), the dish name in `text-lg font-bold`, category as a
mini badge, price using PriceTag with size="lg", availability toggle styled as a
`toggle toggle-primary`, and edit/delete action buttons with icon-only hover
states. Use `enable3D={true}` on GlassCard.

**3.4.3 — Drag-to-Reorder Visual Hint** Add a grip handle icon (`ICONS.menu` or
three horizontal lines) on the left of each card with
`cursor-grab opacity-30 hover:opacity-100`. Even if drag-and-drop isn't wired,
the visual communicates that reordering is planned.

**3.4.4 — Menu Stats Summary Bar** A glass strip at the top: "12 Platillos · 8
Activos · 4 Pausados · Precio Promedio $85 MXN". Each stat separated by a
`divider-horizontal` or a thin `w-px h-6 bg-base-content/10`. Use the
discover-style `text-[10px] font-black uppercase tracking-widest` for labels and
`text-xl font-black` for values.

---

### 3.5 Menu New (`/menu/new`)

**Current state:** Back link → Title → GlassCard with DishForm.

**3.5.1 — Progress Stepper** Above the form, add a horizontal stepper bar with 3
steps: "Información Básica", "Precios y Fotos", "Revisión". Three circles
connected by a line, active step filled with `bg-primary`, future steps
`bg-base-300`. Even if the form is single-step, the stepper communicates a
polished flow. Use `$state` for `currentStep` so it can be wired later.

**3.5.2 — Image Upload Placeholder** Inside or above the form, add a large
dashed-border drop zone
(`border-2 border-dashed border-primary/30 rounded-3xl h-48`) with a camera icon
(ICONS or lucide `Camera`), "Arrastra una foto o haz clic" text, and subtle
`hover:border-primary/60 hover:bg-primary/5 transition-all`. Non-functional but
looks intentional.

**3.5.3 — Preview Card** On the right side (desktop) or below (mobile), show a
live preview of what the dish card will look like as the user fills the form.
Use `DishCard` or a simplified version. Bind its props to the form `$state`
reactively. Title: "Vista Previa" in micro-label style.

---

### 3.6 Merchant Storefront (`/merchant/[id]`)

**Current state:** Hero with image → merchant info → dish grid. Solid but can be
elevated.

**3.6.1 — Parallax-Depth Hero** Add
`style="transform: translateZ(-1px) scale(2)"` or a CSS `perspective` wrapper to
give the hero image a subtle depth effect on scroll (pure CSS parallax). Add a
`backdrop-blur-sm` overlay text area.

**3.6.2 — Merchant Info Bar (Sticky)** A sticky bar (`sticky top-0 z-50`) that
appears when the user scrolls past the hero. Shows merchant name, rating,
open/closed status, and a "Cómo Llegar" button. Use `GlassContainer` with
`backdrop-blur-2xl`. Animate in with `transition-transform` — hidden by default,
slides in from top when a scroll threshold `$state` is met.

**3.6.3 — Category Tab Navigation** Below the hero, horizontal scrollable tabs
(daisyUI `tab` component or custom pills) to filter dishes by category. Same
visual language as discover's category pills.

**3.6.4 — "About This Place" Section** A `GlassCard` below the tabs with: a
short description, operating hours (7-day grid with open/closed per day),
accepted payment methods (icons for cash, card, QR), and a mini embedded map
preview using `MapView` at reduced height.

**3.6.5 — Reviews Preview Section** A `GlassContainer` with 3 mocked reviews:
avatar, stars, comment text, date. Below: "Ver todas las reseñas (124)" link.
Each review has `border-b border-base-content/5` separator.

---

### 3.7 Profile — Tourist (`/profile` when role is tourist)

**Current state:** Avatar section → two info cards (Favoritos, Alertas).
Minimal.

**3.7.1 — Achievement Badges Row** Below the avatar section, a horizontal
scrollable row of "achievement" badges: "Primer Platillo Guardado" (🌮), "5
Negocios Visitados" (🏆), "Explorador Nocturno" (🌙), "Políglota" (🌐). Each
badge: circle icon + label below, locked badges are grayed out with
`opacity-30 grayscale`. Use `GlassCard` for each.

**3.7.2 — Taste Profile Radar** A section titled "Tu Perfil de Sabor" showing 5
categories (Picante, Dulce, Salado, Ácido, Umami) as horizontal bars (CSS only).
Each bar: label, colored `div` with `bg-primary`/`bg-secondary`/etc. at varying
widths. Even if data is mocked, it gives the profile a "personalization engine"
feel.

**3.7.3 — Recent Activity Timeline** A vertical timeline (daisyUI `timeline`
component) showing: "Guardaste Tacos El Rey", "Visitaste Zona Centro",
"Cambiaste idioma a English". 5-6 mocked entries with timestamps and small
icons.

**3.7.4 — Settings Quick Panel** A `GlassCard` with toggle switches for:
"Notificaciones Push", "Modo Accesibilidad", "Compartir Ubicación", "Tema Oscuro
Auto". Each toggle: label + `toggle toggle-primary`. Non-functional but ready
for wiring.

---

### 3.8 Profile — Merchant

**Current state:** BusinessProfileEditor + LocationPicker. Functional but bare.

**3.8.1 — Profile Completeness Indicator** A `radial-progress` (daisyUI) or a
horizontal progress bar showing "Perfil 65% Completo". Below: a checklist of
missing items ("Agrega foto de portada", "Describe tu negocio", "Verifica tu
ubicación") each with a checkmark or empty circle.

**3.8.2 — Public Preview Toggle** A button/toggle "Ver como Turista" that shows
a read-only preview of the merchant storefront as it would appear to customers.
Uses the same layout as `/merchant/[id]` but in a `GlassContainer` overlay or
inline preview.

**3.8.3 — QR Code Section** Embed the QRCode component showing the merchant's
direct link. Add "Descarga para tu mesa" and "Imprime para tu local" buttons.
Wrap in a `GlassCard` with `border-t-4 border-primary`.

---

### 3.9 Profile — Admin

**Current state:** Root admin banner + three action cards. Imposing but sparse.

**3.9.1 — Security Status Panel** A `GlassCard` with `border border-error/20`:
show "Última actividad sospechosa: hace 2h", "Intentos de acceso fallidos hoy:
7", "Tokens activos: 3". Each item with color-coded severity indicator.

**3.9.2 — Quick Platform Metrics** Mini sparkline-style indicators (pure CSS: a
row of thin vertical bars at varying heights) for "Registros esta semana",
"Reportes resueltos", "Tiempo de respuesta promedio". Each metric in its own
`GlassCard`.

---

### 3.10 Saved (`/saved`)

**Current state:** Title + list of SavedDishCards. Very simple.

**3.10.1 — Collection Header with Count & Sort** Enhance the header to show
count ("3 guardados"), and add sort pills: "Recientes", "Por Precio", "Por
Rating". Active pill uses discover-style active state.

**3.10.2 — Group by Merchant** Instead of a flat list, group saved dishes by
merchant. Each group: merchant name header, collapsible (use daisyUI `collapse`
or manual `$state` toggle), merchant mini-info (rating, distance). The cards
within each group are the existing SavedDishCards.

**3.10.3 — Empty State Enhancement** The empty state already exists but make it
more emotional: larger icon, gradient text for the message, a "pulsing" CTA
button linking to `/discover`. Add a subtle background pattern or radial
gradient.

**3.10.4 — "Plan My Route" CTA** At the bottom (when items exist), a full-width
`GlassContainer` banner: "¿Listo para tu ruta gastronómica?" with a map icon and
a "Planear Ruta" button. Non-functional but communicates future feature.

---

### 3.11 Share (`/share`)

**Current state:** Centered card with QR code + brand mark. Elegant but
isolated.

**3.11.1 — Social Share Buttons Row** Below the QR card, add a row of share
buttons: "WhatsApp", "Telegram", "Copiar Link", "Email". Each button: icon +
label, styled as discover-style pills with individual brand-inspired colors
(WhatsApp → green, Telegram → blue, etc. — use daisyUI `success`, `info` tokens
to stay semantic). `onclick` uses `navigator.share()` where available, falls
back to clipboard copy.

**3.11.2 — Download as Image Button** A "Descargar como Imagen" button that
(even if non-functional) communicates the feature. Styled as
`btn-outline btn-primary`.

**3.11.3 — Usage Stats** Below the card: "Este QR ha sido escaneado 47 veces"
with a small bar chart (last 7 days, pure CSS bars). Mocked but gives the page
utility beyond just displaying a QR.

---

### 3.12 Auth — Login (`/login`)

**Current state:** Glass card with email + password + submit. Functional.

**3.12.1 — Animated Background** Add 2-3 large blurred gradient blobs
(absolutely positioned `div` with `bg-primary/20 blur-[120px] rounded-full`)
that slowly drift using CSS `@keyframes` (translate + scale over 20s, infinite,
alternate). Same technique as merchant/register page but extended.

**3.12.2 — OAuth Placeholder Buttons** Below the form, add a `divider` ("o
continúa con") and 3 disabled-looking buttons: "Google", "Apple", "Facebook".
Each with a placeholder icon (lucide Globe, Smartphone, etc.) and
`btn-outline btn-disabled opacity-50`. Shows roadmap intent.

**3.12.3 — Trust Badges** Below the form: a small strip showing "🔒 Conexión
Segura · 🌐 13+ Idiomas · ⚡ Carga en <2s". Use
`text-[10px] opacity-40 uppercase tracking-widest`.

---

### 3.13 Auth — Register (`/register`)

Same enhancements as login (3.12.1, 3.12.2, 3.12.3) plus:

**3.13.1 — Role Selection Cards** Before the form fields, show two selectable
role cards: "Soy Turista" (ICONS.user, secondary color) and "Soy Comercio"
(ICONS.store, warning color). Each is a `GlassCard` with `cursor-pointer`,
`border-2`, and active state: `border-primary ring-2 ring-primary/30`. Selected
card controls which form variant appears (or just sets a `$state` for now).

---

### 3.14 Merchant Registration (`/merchant/register`)

**Current state:** Already has animated blob + GlassContainer. Decent.

**3.14.1 — Benefit Cards Above Form** Before the form, show 3 horizontal benefit
cards: "Visibilidad Global" (globe icon), "Sin Comisiones" (money icon), "Alta
en 10 Min" (clock icon). Each card: icon + title + one-liner. `GlassCard` with
`bg-warning/5 border border-warning/10`.

**3.14.2 — Social Proof Counter** Above the form: "487 negocios ya se unieron
esta semana" with a `animate-pulse` dot. Mocked number but creates urgency.

---

## 4. Global Enhancements (Apply Everywhere)

**4.1 — Page Transition Animations** Every `<main>` tag should have
`animate-in fade-in slide-in-from-bottom-4 duration-700` (already on some pages,
but standardize across ALL).

**4.2 — Scroll-to-Top Button** A floating `btn-circle btn-primary` at
bottom-right that appears after scrolling 300px. Uses `ICONS.chevron_up`,
`opacity-0 → opacity-100` transition,
`onclick={() => window.scrollTo({top: 0, behavior: 'smooth'})}`.

**4.3 — Skeleton Loaders** For any section that "loads data" (dishes, merchants,
stats), show daisyUI `skeleton` placeholders before the data appears. Even if
data is instant (mocked), add a 300ms artificial delay to show the skeleton →
content transition. This communicates a polished loading UX.

**4.4 — Toast Notification System** A global toast container (bottom-center or
top-center) using daisyUI `toast` + `alert`. Triggered by a shared `$state` in a
Svelte context/store. Show toasts on actions like: save a dish, update profile,
toggle a setting. Style with `rounded-[2rem]` and
`shadow-[0_30px_60px_-15px_oklch(var(--p)/0.5)]` — matching discover's magic
toast.

**4.5 — Consistent Section Headers** Every page section title uses the discover
pattern: oversized text
(`text-4xl md:text-6xl font-black uppercase tracking-tight italic`), gradient
text
(`text-transparent bg-clip-text bg-gradient-to-br from-base-content to-base-content/40`),
animated underline bar (`h-2 w-48 bg-primary rounded-full animate-width`), and a
counter/badge on the right side showing item count.

**4.6 — Empty State Standard** All empty states (no dishes, no saved items, no
merchants) use: large lucide icon in `text-base-content/20`, gradient message
text, pulsing CTA button, and a subtle
`bg-gradient-radial from-primary/5 to-transparent` background.

**4.7 — Hover Micro-Animations** Every interactive card, button, and link should
have at minimum: `transition-all duration-300`, a slight scale or translate on
hover, and a color shift toward `primary`. Cards:
`hover:-translate-y-1 hover:shadow-xl`. Buttons:
`hover:shadow-lg hover:shadow-primary/20`.

**4.8 — Focus States for Accessibility** All interactive elements:
`focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 focus-visible:ring-offset-base-100`.
Ensures keyboard navigation is visible and beautiful.

---

## 5. Component Map (New Components Needed in `@sdk/ui`)

These are components that should be created or extracted into the SDK to support
the above features:

| Component           | Responsibility                                           | Consumed By                |
| ------------------- | -------------------------------------------------------- | -------------------------- |
| AnimatedCounter     | Animates a number from 0 to target using easing on mount | Welcome, Admin, Dashboard  |
| CountdownTimer      | Shows days/hours/min/sec to a target date                | Welcome                    |
| MerchantPreviewCard | Horizontal scrollable card for featured merchant         | Welcome                    |
| AchievementBadge    | Circle icon + label, locked/unlocked state               | Tourist Profile            |
| ActivityFeedItem    | Timestamp + dot + event text                             | Dashboard, Tourist Profile |
| ProgressStepper     | Horizontal step indicator (active/complete/future)       | Menu New                   |
| SkeletonCard        | GlassCard-shaped skeleton placeholder                    | Everywhere                 |
| ScrollToTop         | Floating button, appears on scroll                       | Global (layout)            |
| ToastManager        | Context-based toast queue                                | Global (layout)            |
| SortPills           | Horizontal filter/sort pill row with active state        | Saved, Menu, Discover      |
| StatBar             | Horizontal bar chart row (pure CSS)                      | Admin, Dashboard           |
| TrustBadges         | Small horizontal security/feature badge strip            | Auth pages                 |
| ImageDropZone       | Dashed upload area placeholder                           | Menu New                   |
| ShareButtons        | Row of social share pill buttons                         | Share                      |
| ProfileCompleteness | Radial or bar progress + checklist                       | Merchant Profile           |
| StickyMerchantBar   | Scroll-aware sticky header for merchant page             | Merchant storefront        |

---

## 6. Open Questions & Risks

- [REVISIT] The SDK file (`@sdk/ui` source) was not included in the upload. The
  component interfaces described above are inferred from usage in the explorer
  pages. Verify that `GlassCard` accepts `enable3D`, `glowColor`, and `class`
  before building.
- [REVISIT] The `animate-in`, `fade-in`, `slide-in-from-*` classes used in
  `/discover` appear to come from Tailwind's animation utilities or a plugin —
  verify they are available globally, not just on pages that import a specific
  CSS file.
- [HIGH RISK] Adding too many animated elements (blurred blobs, parallax,
  animated counters) on the Welcome page could hurt performance on low-end
  mobile devices common in Mexico's MiPyME market. Recommend: use
  `will-change: transform` sparingly, keep blur layers to max 3 per viewport,
  and test on a mid-range Android device (Redmi Note series).
- [ASSUMPTION] The `rune-lab` library's
  ThemeSelector/LanguageSelector/CurrencySelector are already in the layout and
  handle theme switching globally. The enhancements here do not need to
  duplicate that functionality.
- The mini-game/pretext code at the top of the layout is NOT modified by any
  item in this spec.

---

> **TL;DR:** Take the visual intensity of `/discover` — glassmorphism, oversized
> typography, 3D cards, animated toasts, pulsing indicators, gradient masks —
> and inject it into every single page. Add mocked-but-visible features
> (counters, charts, timelines, achievement badges, social proof) so the app
> feels like a living product, not a prototype. Zero new dependencies. Ship the
> aesthetic first, wire the data later.
