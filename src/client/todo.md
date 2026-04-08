# Xibalbá — PWA Implementation Guide

> **Phased roadmap to convert the `explorer` app into an installable, offline-capable PWA with QR-based distribution.**
>
> Each phase is self-contained: build → validate → move on.

---

## Current State (what you already have)

| Aspect | Status | Where |
|---|---|---|
| `adapter-static` | ✅ configured | `apps/explorer/svelte.config.js` |
| SPA mode (`ssr: false`) | ✅ enabled | `apps/explorer/src/routes/+layout.ts` |
| `prerender: true` | ✅ enabled | `apps/explorer/src/routes/+layout.ts` |
| `fallback: "index.html"` | ⚠️ **commented out** | `apps/explorer/svelte.config.js` → line 8 |
| Service worker | ❌ none | — |
| Web app manifest | ❌ none | — |
| PWA meta tags | ❌ none | `apps/explorer/src/app.html` |
| QR code generation | ❌ none | — |

---

## Phase 0 — Pre-flight (SPA fallback)

**Goal**: Make `adapter-static` emit a proper SPA fallback so all client-side routes work when accessed directly (e.g. `/discover`, `/menu/new`).

### What to do

**File**: `apps/explorer/svelte.config.js`

Uncomment the `fallback` line:

```js
adapter: adapter({
  fallback: "index.html",  // ← uncomment this
  // strict: true,          // keep this commented — strict conflicts with fallback
}),
```

### Validate

```bash
bun run --cwd apps/explorer vite build
ls apps/explorer/build/   # should contain index.html as the fallback
```

Open `apps/explorer/build/index.html` in a browser via a local server. Navigate to `/discover` directly — it should work without a 404.

---

## Phase 1 — Web App Manifest

**Goal**: Create the manifest that tells browsers "this is an installable app."

### 1.1 — Generate icons

You need at minimum two PNG icons: **192×192** and **512×512**.

**Tool**: Use [realfavicongenerator.net](https://realfavicongenerator.net/) or [favicon.io](https://favicon.io/) to generate all sizes from a single source image.

Place them in:

```
apps/explorer/static/
├── pwa-192x192.png
├── pwa-512x512.png
└── manifest.json
```

### 1.2 — Create `manifest.json`

**File**: `apps/explorer/static/manifest.json`

```json
{
  "name": "Xibalbá — Descubre lo local",
  "short_name": "Xibalbá",
  "description": "Conecta turistas con negocios locales durante el Mundial FIFA 2026",
  "start_url": "/",
  "display": "standalone",
  "background_color": "#0d1b2a",
  "theme_color": "#e63946",
  "orientation": "portrait",
  "lang": "es",
  "dir": "ltr",
  "categories": ["food", "travel", "lifestyle"],
  "icons": [
    {
      "src": "/pwa-192x192.png",
      "sizes": "192x192",
      "type": "image/png"
    },
    {
      "src": "/pwa-512x512.png",
      "sizes": "512x512",
      "type": "image/png"
    },
    {
      "src": "/pwa-512x512.png",
      "sizes": "512x512",
      "type": "image/png",
      "purpose": "maskable"
    }
  ]
}
```

> **Note**: Use your project colors — `#0d1b2a` (c-dark) and `#e63946` (c-accent) from your Typst doc.

### 1.3 — Link manifest in `app.html`

**File**: `apps/explorer/src/app.html`

Add inside `<head>`, before `%sveltekit.head%`:

```html
<link rel="manifest" href="/manifest.json" />
<meta name="theme-color" content="#e63946" />
<meta name="apple-mobile-web-app-capable" content="yes" />
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent" />
<meta name="apple-mobile-web-app-title" content="Xibalbá" />
<link rel="apple-touch-icon" href="/pwa-192x192.png" />
```

### Validate

```bash
bun run --cwd apps/explorer vite build
bun run --cwd apps/explorer vite preview
```

1. Open Chrome → DevTools → **Application** tab → **Manifest** section
2. All fields should render correctly
3. The "installability" section should show the manifest is detected

---

## Phase 2 — Service Worker (offline support)

**Goal**: Cache the app shell so it works offline / on saturated 3G.

You have **two paths** here. Pick one:

### Path A — Manual (SvelteKit built-in)

Create the file `apps/explorer/src/service-worker.ts`:

```typescript
/// <reference no-default-lib="true"/>
/// <reference lib="esnext" />
/// <reference lib="webworker" />
/// <reference types="@sveltejs/kit" />

import { build, files, version } from '$service-worker';

const self = /** @type {ServiceWorkerGlobalScope} */ (globalThis.self as any);
const CACHE = `xibalba-cache-${version}`;
const ASSETS = [...build, ...files];

// Install: cache everything
self.addEventListener('install', (event: ExtendableEvent) => {
  event.waitUntil(
    caches.open(CACHE)
      .then(cache => cache.addAll(ASSETS))
      .then(() => self.skipWaiting())
  );
});

// Activate: clean old caches
self.addEventListener('activate', (event: ExtendableEvent) => {
  event.waitUntil(
    caches.keys()
      .then(keys => Promise.all(
        keys
          .filter(key => key !== CACHE)
          .map(key => caches.delete(key))
      ))
      .then(() => self.clients.claim())
  );
});

// Fetch: cache-first for assets, network-first for API
self.addEventListener('fetch', (event: FetchEvent) => {
  if (event.request.method !== 'GET') return;

  const url = new URL(event.request.url);

  // Skip API calls — let them go to network
  if (url.pathname.startsWith('/api')) return;

  event.respondWith(
    caches.match(event.request)
      .then(cached => cached || fetch(event.request)
        .then(response => {
          const clone = response.clone();
          caches.open(CACHE).then(cache => cache.put(event.request, clone));
          return response;
        })
      )
      .catch(() => caches.match('/index.html') as Promise<Response>)
  );
});
```

> SvelteKit auto-registers this file — no extra config needed.

### Path B — Plugin (`@vite-pwa/sveltekit`)

Install:

```bash
bun add -D @vite-pwa/sveltekit
```

Update `apps/explorer/vite.config.ts`:

```typescript
import { paraglideVitePlugin } from "@inlang/paraglide-js";
import tailwindcss from "@tailwindcss/vite";
import { sveltekit } from "@sveltejs/kit/vite";
import { SvelteKitPWA } from "@vite-pwa/sveltekit";      // ← add
import { defineConfig } from "vite-plus";

export default defineConfig({
  plugins: [
    sveltekit(),
    tailwindcss(),
    paraglideVitePlugin({
      project: "./src/lib/i18n/project.inlang",
      outdir: "./src/lib/i18n/paraglide",
      strategy: ["localStorage", "preferredLanguage", "baseLocale"],
    }),
    SvelteKitPWA({                                         // ← add
      manifest: false,                // you already have static/manifest.json
      strategies: 'generateSW',       // auto-generate service worker
      workbox: {
        globPatterns: ['client/**/*.{js,css,ico,png,svg,webp,webmanifest}'],
        navigateFallback: '/index.html',
      },
    }),
  ],
  // ...rest of your config stays the same
});
```

Then register it in your layout. Add to `apps/explorer/src/routes/+layout.svelte`:

```svelte
<script lang="ts">
  import { onMount } from "svelte";
  // ...your existing imports

  onMount(async () => {
    if ('serviceWorker' in navigator) {
      const { useRegisterSW } = await import('virtual:pwa-register');
      useRegisterSW({ immediate: true });
    }
  });
</script>
```

### Validate

```bash
bun run --cwd apps/explorer vite build
bun run --cwd apps/explorer vite preview
```

1. Open Chrome → DevTools → **Application** → **Service Workers**
2. You should see the service worker registered and active
3. Check the **Cache Storage** section — your assets should be cached
4. Toggle **Offline** in the Network tab → reload → the app should still render
5. Chrome should now show the **Install** button in the address bar

---

## Phase 3 — Build, deploy & test on a real device

**Goal**: Get the PWA running on a real server so mobile devices can install it.

### 3.1 — Deploy options (pick one)

PWAs require HTTPS. Fastest options for a hackathon demo:

| Option | Command / Steps | URL you get |
|---|---|---|
| **Cloudflare Pages** | `npx wrangler pages deploy apps/explorer/build` | `*.pages.dev` |
| **Vercel** | `npx vercel apps/explorer/build` | `*.vercel.app` |
| **Netlify** | Drag `build/` folder to [app.netlify.com/drop](https://app.netlify.com/drop) | `*.netlify.app` |
| **GitHub Pages** | Push `build/` to `gh-pages` branch | `user.github.io/repo` |
| **Local tunnel** (for quick testing) | `npx localtunnel --port 4173` | temporary `*.loca.lt` |

### 3.2 — Test on your phone

1. Open the deployed URL on your phone's browser (Chrome on Android / Safari on iOS)
2. **Android**: Chrome will show an "Install app" banner or you can tap ⋮ → "Add to Home Screen"
3. **iOS**: Safari → Share button → "Add to Home Screen"
4. Launch the app from your home screen — it should open in standalone mode (no browser chrome)

### Validate

- App opens in standalone mode (no URL bar)
- Navigation between routes works (`/discover`, `/menu`, `/profile`, etc.)
- Theme color shows in the status bar (`#e63946`)
- App icon on home screen matches your PWA icon
- Offline: Turn on airplane mode → open the app → the cached shell should render

---

## Phase 4 — QR Code for instant access

**Goal**: Generate a QR that points to your deployed PWA URL so tourists can scan and install.

### 4.1 — Install `qr-code-styling`

```bash
bun add qr-code-styling
```

> Using `qr-code-styling` over plain `qrcode` because it lets you embed your Xibalbá logo inside the QR.

### 4.2 — Create a QR component

**File**: `sdk/ui/src/components/primitives/QRCode.svelte`

```svelte
<script lang="ts">
  import { onMount } from "svelte";
  import QRCodeStyling from "qr-code-styling";

  interface Props {
    url: string;
    size?: number;
    logoSrc?: string;
  }

  let { url, size = 280, logoSrc }: Props = $props();
  let container: HTMLDivElement;

  onMount(() => {
    const qr = new QRCodeStyling({
      width: size,
      height: size,
      data: url,
      image: logoSrc || undefined,
      dotsOptions: {
        color: "#0d1b2a",
        type: "rounded",
      },
      cornersSquareOptions: {
        color: "#e63946",
        type: "extra-rounded",
      },
      backgroundOptions: {
        color: "#ffffff",
      },
      imageOptions: {
        crossOrigin: "anonymous",
        margin: 8,
      },
    });

    qr.append(container);
  });
</script>

<div bind:this={container} class="inline-block rounded-2xl overflow-hidden shadow-lg"></div>
```

### 4.3 — Use it in a sharing/landing page

You can add a route like `apps/explorer/src/routes/share/+page.svelte` or embed it in the dashboard:

```svelte
<script lang="ts">
  import QRCode from "@sdk/ui/components/primitives/QRCode.svelte";

  const appUrl = "https://your-deployed-url.pages.dev";
</script>

<div class="flex flex-col items-center gap-6 p-8">
  <h2 class="text-2xl font-bold">Escanea para abrir Xibalbá</h2>
  <QRCode url={appUrl} size={300} logoSrc="/pwa-192x192.png" />
  <p class="text-sm text-base-content/60">
    Abre la cámara de tu teléfono y apunta al código QR
  </p>
</div>
```

### 4.4 — Generate a printable QR (for physical distribution)

For posters, flyers, table cards at the hackathon demo, you can also generate a static QR image at build time or use a quick online tool:

- [qr-code-styling online editor](https://qr-code-styling.com/) — lets you download PNG/SVG with logo
- Or generate server-side with `qrcode` npm in a build script

### Validate

1. Open the `/share` page on desktop
2. Scan the QR with your phone camera
3. Your phone should open the PWA URL
4. Install prompt should appear (or you can manually add to home screen)
5. Full flow complete: **scan → open → install → use offline**

---

## Phase 5 — Polish & hackathon-ready refinements

**Goal**: Final touches that make the demo impressive.

### 5.1 — Splash screen (Android)

Chrome auto-generates a splash screen from your manifest's `name`, `background_color`, and `icons`. Make sure your 512×512 icon looks good on a dark background (`#0d1b2a`).

### 5.2 — Offline fallback UX

Add a visual indicator when the user is offline. In your layout:

```svelte
<script lang="ts">
  let online = $state(typeof navigator !== 'undefined' ? navigator.onLine : true);

  if (typeof window !== 'undefined') {
    window.addEventListener('online', () => online = true);
    window.addEventListener('offline', () => online = false);
  }
</script>

{#if !online}
  <div class="fixed top-0 inset-x-0 z-[200] bg-warning text-warning-content text-center text-xs py-1 font-bold">
    Sin conexión — mostrando datos en caché
  </div>
{/if}
```

### 5.3 — Cache Leaflet tiles for offline maps

If you want the map to work offline, you need to pre-cache tiles. This is advanced and optional, but the strategy is:

- Use the `workbox` range request plugin to cache tiles as the user pans
- Or use a static tile set for the demo area (CDMX / Expo Santa Fe zone)
- Libraries like `leaflet.offline` can help

### 5.4 — Update the `client.just` deploy recipe

```just
# ── Deploy (PWA) ─────────────────────────────────────
[doc('Build and deploy the PWA')]
[group('Deploy')]
deploy-pwa: sync-ui
    bun run --cwd apps/explorer vite build
    # Then deploy to your chosen platform:
    # npx wrangler pages deploy apps/explorer/build
    @echo "✓ PWA built — deploy apps/explorer/build/ to your host"
```

---

## Quick Reference — File Changes Summary

| File | Action | Phase |
|---|---|---|
| `apps/explorer/svelte.config.js` | Uncomment `fallback: "index.html"` | 0 |
| `apps/explorer/static/manifest.json` | **Create** — PWA manifest | 1 |
| `apps/explorer/static/pwa-192x192.png` | **Create** — app icon | 1 |
| `apps/explorer/static/pwa-512x512.png` | **Create** — app icon | 1 |
| `apps/explorer/src/app.html` | Add manifest link + meta tags | 1 |
| `apps/explorer/src/service-worker.ts` | **Create** — offline caching (Path A) | 2 |
| `apps/explorer/vite.config.ts` | Add `SvelteKitPWA` plugin (Path B) | 2 |
| `sdk/ui/src/components/primitives/QRCode.svelte` | **Create** — QR component | 4 |
| `apps/explorer/src/routes/share/+page.svelte` | **Create** — QR sharing page | 4 |
| `client.just` | Add `deploy-pwa` recipe | 5 |

---

## Decision Tree — Which service worker path?

```
Do you want maximum control over caching logic?
├── YES → Path A (manual service-worker.ts)
│         Pros: No extra dependency, SvelteKit native, simple
│         Cons: You write the caching strategy yourself
│
└── NO, just make it work → Path B (@vite-pwa/sveltekit)
          Pros: Zero-config, Workbox handles everything, auto-generates manifest
          Cons: Extra dependency, slightly more complex vite config
```

**Recommendation for the hackathon**: Path A is simpler and has zero dependencies. You're already in SPA mode with `adapter-static`, so the manual service worker is ~40 lines and does everything you need.

---

## Timeline Estimate

| Phase | Effort | Dependency |
|---|---|---|
| Phase 0 — SPA fallback | 5 min | None |
| Phase 1 — Manifest + icons | 30 min | Need a 512px icon |
| Phase 2 — Service worker | 30–60 min | Phase 0 + 1 done |
| Phase 3 — Deploy + test on phone | 30 min | Phase 2 done |
| Phase 4 — QR code | 30 min | Phase 3 done (need deployed URL) |
| Phase 5 — Polish | 30–60 min | Everything above |
| **Total** | **~2.5–4 hours** | |