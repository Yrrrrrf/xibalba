# Rune-Lab Integration for Xibalbá `explorer` App

**Context for the LLM:** You are working on `xibalbá`, a monorepo Svelte 5 /
SvelteKit application built for the FIFA World Cup 2026.

- We are focusing **strictly** on the `apps/explorer` app and the `@sdk/ui`
  package.
- `explorer` is the mobile-first app for Tourists and Business Owners.
- Do **NOT** implement complex layouts like `WorkspaceLayout`,
  `NavigationPanel`, or `DetailPanel` here (those are reserved for the `vision`
  admin app later).
- **Goal:** Integrate `rune-lab` v0.4.4 into `explorer` to enable Global
  Theming, Language Switching, Currency Conversion, and Toast Notifications.

Please implement the following architectural refactors step-by-step. Do not
break existing Tailwind v4 / DaisyUI v5 styling.

---

## PHASE 1: Provider Setup in `explorer`

**Target:** `src/client/apps/explorer/src/routes/+layout.svelte`

1. **Import Requirements:**
   - Import `RuneProvider`, `LayoutPlugin`, `PalettesPlugin`, `MoneyPlugin`, and
     `localStorageDriver` from `rune-lab`.
   - Import the Paraglide dictionary: `import * as m from "@sdk/ui"`.
2. **Setup `<RuneProvider>`:**
   - Wrap the entire application content (`{@render children()}`) in
     `<RuneProvider>`.
   - Pass the plugins array: `[LayoutPlugin, PalettesPlugin, MoneyPlugin]`.
   - Pass the config object containing:
     - `app`: `{ name: "Xibalbá", version: "1.0.0" }`
     - `persistence`: `localStorageDriver`
     - `dictionary`: `m`
     - `"rune-lab.money"`: Set `defaultCurrency: "USD"` and configure exchange
       rates (e.g., base USD to MXN, EUR, JPY, etc., as dummy data for now).

## PHASE 2: Global UI Selectors Integration

**Target:** `src/client/apps/explorer/src/routes/+layout.svelte` (Header
section)

1. **Import Selectors:**
   - Import `ThemeSelector`, `LanguageSelector`, and `CurrencySelector` from
     `rune-lab`.
2. **Update the Top Brand Bar:**
   - Currently, the header contains the brand logo on the left and a "Logout"
     button on the right.
   - Insert a new `div` cluster next to the logout button to hold the three
     selectors.
   - Ensure they are styled nicely for mobile (e.g., using flex, gap, and
     keeping them compact so they fit on small screens).

## PHASE 3: Money Subsystem Refactor

**Target:** `@sdk/core` and `@sdk/ui`

Currently, monetary values in `@sdk/core` (like `Dish.price`) are raw floats
(e.g., `7.5`). `rune-lab`'s MoneyPlugin requires integers (minor units / cents,
e.g., `750`).

1. **Update `@sdk/core/src/entities/dish.ts`:**
   - Update `price` documentation/comments to enforce that it is stored in
     **minor units** (cents). (Assume existing mock data is updated accordingly,
     e.g., `7.5` becomes `750`).
2. **Refactor `PriceTag.svelte`
   (`@sdk/ui/src/components/primitives/PriceTag.svelte`):**
   - Remove the hardcoded `$ {amount.toFixed(2)}`.
   - Import `MoneyDisplay` from `rune-lab`.
   - Replace the internal markup with
     `<MoneyDisplay amount={amount} currency="USD" />` (or read the active
     currency dynamically via `rune-lab`'s `useMoney()` composable if
     preferred).
3. **Update Forms (`DishForm.svelte`):**
   - Update `DishForm` to convert the user's float input (major units) into
     minor units before submitting to `onsubmit`, using `toMinorUnit` from
     `rune-lab` or a simple `* 100` multiplier.

## PHASE 4: Toast Notifications

**Target:** `@sdk/ui` (Forms and Action Buttons)

Replace silent actions or simple `console.log` statements with `rune-lab`'s
`ToastStore`.

1. **Import:** `import { getToastStore } from "rune-lab"` in the relevant
   components.
2. **Update `DishForm.svelte`:**
   - On successful validation and submit, trigger
     `toasts.success(m.form_saved_success())` (ensure translation key exists or
     use a fallback string).
3. **Update `BusinessProfileEditor.svelte`:**
   - Inside `handleSave()`, trigger `toasts.success("Perfil actualizado")`.
4. **Update `LocationPicker.svelte`:**
   - Inside `confirmLocation()`, trigger `toasts.success("Ubicación guardada")`.
5. **Update `SavedDishCard.svelte`:**
   - Inside the remove button action, trigger
     `toasts.info("Platillo eliminado de favoritos")`.

## PHASE 5: Translation Engine Synchronization

**Target:** `@sdk/ui/src/i18n/`

1. The Hackathon document specifies 13 languages are required.
2. `rune-lab` expects the Paraglide object to be passed into `RuneProvider`.
   Ensure that `explorer/src/hooks.server.ts` correctly utilizes
   `paraglideMiddleware` so the SSR HTML `lang` attribute matches the `rune-lab`
   active language state.
3. No manual translation files need writing for this prompt, but ensure the
   architecture perfectly connects the `rune-lab` `LanguageStore` to Paraglide's
   runtime.

---

### Strict Non-Negotiable Rules for the LLM:

1. **Svelte 5 Runes Only:** Do not use `export let`, use `$props()`. Do not use
   `onMount` if `$effect` is better suited.
2. **Zero Code Outside Scope:** Do not modify the `vision` app. Do not touch the
   backend (`engine` or `db`).
3. **Design Preservation:** Keep the dark-glass, neon-orange aesthetic of
   `xibalbá`. Do not accidentally strip out Tailwind classes when dropping in
   `rune-lab` components.
4. **No Layout Shells:** You are strictly forbidden from importing
   `WorkspaceLayout` into `explorer`. `explorer` maintains its custom
   mobile-first layout structure.
