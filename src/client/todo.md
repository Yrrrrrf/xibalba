# Xibalbá Explorer — PWA Installability Spec

## Reverse-Engineered PWA Audit

**Project**: `xibalba-explorer` (SvelteKit + adapter-static + Bun workspace)
**App path**: `src/client/apps/explorer/` **Current status**: Partially
installable — core pieces exist, several flags missing

---

## Current State

| Artifact                 | Status        | Notes                                                                                                |
| ------------------------ | ------------- | ---------------------------------------------------------------------------------------------------- |
| `static/manifest.json`   | ⚠️ Incomplete | Missing `id`, `scope`, maskable icon, `screenshots`, `categories`, `lang`, `dir`, `display_override` |
| `src/service-worker.ts`  | ✅ Solid      | install → cache all, activate → prune old, fetch → cache-first / network-fallback                    |
| `src/app.html` meta tags | ⚠️ Incomplete | `apple-touch-icon` is **commented out**, missing `description` meta, missing `og:` tags              |
| PWA icon files           | ❌ Missing    | `pwa-192x192.png` and `pwa-512x512.png` are referenced but not present in `static/`                  |

---

## What Browsers Require for "Install" Prompt

### Chrome / Edge (Android & Desktop)

1. ✅ Valid `manifest.json` linked from `<head>`
2. ✅ `name` or `short_name`
3. ✅ `start_url`
4. ✅ `display`: `standalone` | `fullscreen` | `minimal-ui`
5. ✅ Service worker with `fetch` handler
6. ⚠️ `icons`: 192×192 **and** 512×512 PNG — files must actually exist
7. ❌ `id` — strongly recommended (stable identity across URL changes)
8. ❌ Maskable icon — needed for adaptive icon shapes on Android
9. ❌ `screenshots` — triggers the richer install sheet on Android/desktop

### Safari (iOS 16.4+)

1. ✅ `<meta name="apple-mobile-web-app-capable" content="yes">`
2. ✅ `<meta name="apple-mobile-web-app-status-bar-style">`
3. ✅ `<meta name="apple-mobile-web-app-title">`
4. ❌ `<link rel="apple-touch-icon">` — **currently commented out!**
5. ❌ Actual `apple-touch-icon` file (180×180 PNG recommended)

### Samsung Internet / Firefox

- Same core requirements as Chrome, plus the actual icon files existing on disk.

---

## Changes Required

### 1. `static/manifest.json` — add missing fields

```json
{
  "id": "/",
  "name": "Xibalbá — Descubre lo local",
  "short_name": "Xibalbá",
  "description": "Conecta turistas con negocios locales",
  "lang": "es",
  "dir": "ltr",
  "start_url": "/",
  "scope": "/",
  "display": "standalone",
  "display_override": ["standalone", "minimal-ui"],
  "background_color": "#0d1b2a",
  "theme_color": "#e63946",
  "orientation": "portrait",
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
    },
    {
      "src": "/apple-touch-icon.png",
      "sizes": "180x180",
      "type": "image/png"
    }
  ],
  "screenshots": [
    {
      "src": "/screenshots/mobile-discover.png",
      "sizes": "1080x1920",
      "type": "image/png",
      "form_factor": "narrow",
      "label": "Discover local food near you"
    },
    {
      "src": "/screenshots/mobile-menu.png",
      "sizes": "1080x1920",
      "type": "image/png",
      "form_factor": "narrow",
      "label": "Browse restaurant menus"
    }
  ]
}
```

**New fields explained:**

| Field                      | Why                                                                                        |
| -------------------------- | ------------------------------------------------------------------------------------------ |
| `id`                       | Stable app identity — Chrome uses this to deduplicate installs even if `start_url` changes |
| `scope`                    | Limits what URLs the PWA "owns" — prevents navigation outside your app shell               |
| `display_override`         | Ordered fallback list — browsers try first entry, fall back to next                        |
| `lang` / `dir`             | Proper i18n signal for the install prompt and OS-level app name                            |
| `categories`               | Helps app stores / OS categorize the PWA                                                   |
| `purpose: "maskable"` icon | Android adaptive icons — without this, your icon gets a white ring                         |
| `screenshots`              | Triggers the richer "Install app" bottom sheet on Chrome Android (vs. the small banner)    |

### 2. `src/app.html` — uncomment apple-touch-icon + add meta

```html
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <meta name="description" content="Conecta turistas con negocios locales" />

  <link rel="manifest" href="/manifest.json" />
  <meta name="theme-color" content="#e63946" />
  <meta name="apple-mobile-web-app-capable" content="yes" />
  <meta
    name="apple-mobile-web-app-status-bar-style"
    content="black-translucent"
  />
  <meta name="apple-mobile-web-app-title" content="Xibalbá" />
  <link rel="apple-touch-icon" href="/apple-touch-icon.png" />

  <!-- Optional: splash screens for iOS -->
  <link rel="icon" type="image/png" sizes="32x32" href="/favicon-32x32.png" />
  <link rel="icon" type="image/png" sizes="16x16" href="/favicon-16x16.png" />

  %sveltekit.head%
</head>
```

### 3. Generate actual icon files in `static/`

You need these files to physically exist:

| File                              | Size      | Notes                           |
| --------------------------------- | --------- | ------------------------------- |
| `pwa-192x192.png`                 | 192×192   | Standard Android icon           |
| `pwa-512x512.png`                 | 512×512   | Splash screen + maskable source |
| `apple-touch-icon.png`            | 180×180   | iOS home screen icon            |
| `favicon-32x32.png`               | 32×32     | Browser tab favicon             |
| `favicon-16x16.png`               | 16×16     | Browser tab favicon             |
| `screenshots/mobile-discover.png` | 1080×1920 | Install sheet screenshot        |
| `screenshots/mobile-menu.png`     | 1080×1920 | Install sheet screenshot        |

> **Tip**: For the maskable icon, ensure the important content stays inside the
> "safe zone" (inner 80% circle). Use https://maskable.app/editor to preview.

---

## Testing Workflow

See the companion `pwa-test-workflow.md` for the step-by-step verification
process.
