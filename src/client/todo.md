# Xibalbá — Add QR Code Feature (Phase 4)

> **Task**: Add a branded QR code component + `/share` route to the explorer
> PWA. **Agent workflow**: Context → Implement → Verify

---

## Step 0 — Gather context

Run this first to understand what changed recently:

```bash
git diff HEAD~1 --stat
git diff HEAD~1 --name-only
```

Read the output. If Phases 0–3 (manifest, service worker, PWA meta tags) landed
in the last commit, you're good to proceed. If not, check that these files exist
and are wired up before continuing:

- `apps/explorer/static/manifest.json` — must exist
- `apps/explorer/src/service-worker.ts` — must exist
- `apps/explorer/src/app.html` — must contain `<link rel="manifest" ...>`

---

## Step 1 — Install dependency

```bash
bun add qr-code-styling
```

This goes in the **workspace root** `package.json` (hoisted). The library
renders styled QR codes as canvas/SVG with embedded logo support.

---

## Step 2 — Create `QRCode.svelte`

**File**: `sdk/ui/src/components/primitives/QRCode.svelte`

> ⚠️ **Architecture rule**: All primitives live in
> `sdk/ui/src/components/primitives/`. They are re-exported through the barrel:
> `primitives/mod.ts` → `sdk/ui/src/mod.ts` → `@sdk/ui`. The explorer app
> resolves `@sdk/ui` via alias to `../../sdk/ui/src/mod.ts` (a file, NOT a
> directory). **Never** import directly as `@sdk/ui/components/...` — always use
> `import { X } from "@sdk/ui"`.

> **Svelte 5 patterns used in this project**:
>
> - Props via `$props()` with TypeScript `interface Props`
> - Reactive state via `$state()`
> - Lifecycle via `onMount` from `"svelte"`
> - DaisyUI + Tailwind utility classes for styling
> - Existing primitives use `class?: string` prop for external styling

```svelte
<script lang="ts">
  import { onMount } from "svelte";
  import QRCodeStyling from "qr-code-styling";

  interface Props {
    url: string;
    size?: number;
    logoSrc?: string;
    downloadName?: string;
  }

  let { url, size = 280, logoSrc, downloadName = "xibalba-qr" }: Props =
    $props();
  let container: HTMLDivElement;
  let qr: QRCodeStyling | null = $state(null);

  onMount(() => {
    qr = new QRCodeStyling({
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
      cornersDotOptions: {
        color: "#e63946",
        type: "dot",
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

  function download(ext: "png" | "svg") {
    qr?.download({ name: downloadName, extension: ext });
  }
</script>

<div class="flex flex-col items-center gap-3">
  <div
    bind:this={container}
    class="inline-block rounded-2xl overflow-hidden shadow-lg ring-1 ring-base-content/10"
  ></div>

  {#if qr}
    <div class="flex gap-2">
      <button
        onclick={() => download("png")}
        class="btn btn-xs btn-ghost opacity-60 hover:opacity-100"
      >
        PNG
      </button>
      <button
        onclick={() => download("svg")}
        class="btn btn-xs btn-ghost opacity-60 hover:opacity-100"
      >
        SVG
      </button>
    </div>
  {/if}
</div>
```

---

## Step 3 — Export from barrel

**File**: `sdk/ui/src/components/primitives/mod.ts`

Add this line at the end:

```ts
export { default as QRCode } from "./QRCode.svelte";
```

> The chain is: `primitives/mod.ts` → `sdk/ui/src/mod.ts` (already has
> `export * from "./components/primitives/mod.ts"`) → consumed by explorer via
> `@sdk/ui` alias. No other files need changes for the export to work.

---

## Step 4 — Create the `/share` route

**File**: `apps/explorer/src/routes/share/+page.svelte`

> Create the `share/` directory first.

```svelte
<script lang="ts">
  import { QRCode, m, ICONS } from "@sdk/ui";

  // Replace with actual deployed URL from Phase 3
  const appUrl = "https://your-deployed-url.pages.dev";
</script>

<svelte:head>
  <title>Comparte Xibalbá</title>
</svelte:head>

<div
  class="flex-1 flex flex-col items-center justify-center px-4 py-12 bg-gradient-to-b from-base-100 to-base-200"
>
  <div
    class="bg-base-100 rounded-3xl shadow-2xl shadow-primary/10 border border-base-content/5 p-8 md:p-12 max-w-sm w-full flex flex-col items-center gap-6 print:shadow-none print:border-none"
  >
    <!-- Brand mark (matches +layout.svelte header pattern) -->
    <div class="flex items-center gap-2">
      <div
        class="w-10 h-10 rounded-xl bg-primary flex items-center justify-center shadow-lg shadow-primary/20 text-primary-content"
      >
        <ICONS.brand size={22} />
      </div>
      <span class="text-2xl font-black tracking-tighter text-base-content">
        {m.app_name()}
      </span>
    </div>

    <p class="text-center text-base-content/70 text-sm leading-relaxed">
      Escanea para descubrir la mejor comida local durante el Mundial 2026
    </p>

    <QRCode url={appUrl} size={300} logoSrc="/pwa-192x192.png" />

    <div
      class="flex items-center gap-2 text-xs text-base-content/40 font-medium"
    >
      <span class="inline-block w-5 h-px bg-base-content/20"></span>
      Abre la cámara y apunta aquí
      <span class="inline-block w-5 h-px bg-base-content/20"></span>
    </div>

    <p
      class="hidden print:block text-[10px] text-base-content/50 break-all text-center"
    >
      {appUrl}
    </p>
  </div>

  <button
    onclick={() => window.print()}
    class="mt-6 btn btn-sm btn-ghost text-base-content/50 print:hidden"
  >
    Imprimir para póster / tarjeta de mesa
  </button>
</div>
```

---

## Step 5 — Build & verify

```bash
bun run --cwd apps/explorer vite build
```

**Expected**: Build completes with 0 errors. If you see `UNLOADABLE_DEPENDENCY`,
it means an import is using `@sdk/ui/components/...` path syntax instead of
`import { X } from "@sdk/ui"` — fix the import.

```bash
bun run --cwd apps/explorer vite preview
```

Then open in browser and navigate to `/share`. You should see a centered card
with the Xibalbá branding and a styled QR code.

---

## Files changed (summary)

| Action | File                                                   |
| ------ | ------------------------------------------------------ |
| CREATE | `sdk/ui/src/components/primitives/QRCode.svelte`       |
| MODIFY | `sdk/ui/src/components/primitives/mod.ts` (add 1 line) |
| CREATE | `apps/explorer/src/routes/share/+page.svelte`          |
| MODIFY | root `package.json` (via `bun add qr-code-styling`)    |

---

## Ground truth — Architecture notes for the model

These are facts extracted from the codebase, NOT assumptions:

- **Monorepo**: Bun workspaces. Root is `src/client/`, workspaces are `sdk/*`
  and `apps/*`.
- **Alias resolution**: `@sdk/ui` → `../../sdk/ui/src/mod.ts` (defined in
  `apps/explorer/svelte.config.js`). This points to a **file**, not a directory.
  Deep path imports like `@sdk/ui/foo/bar` will fail with "Not a directory".
- **Barrel chain**: `primitives/mod.ts` → `sdk/ui/src/mod.ts` (line:
  `export * from "./components/primitives/mod.ts"`) → consumed by apps.
- **Component patterns**: Svelte 5 runes (`$props()`, `$state()`), TypeScript
  `interface Props`, DaisyUI classes, `onMount` for lifecycle.
- **Brand colors**: `#0d1b2a` (c-dark / background), `#e63946` (c-accent /
  primary), `#ffffff` (QR background).
- **i18n**: `m.app_name()` from Paraglide. Available in `@sdk/ui` exports.
- **Icons**: `ICONS.brand` = Trophy from lucide-svelte. Exported from `@sdk/ui`.
- **Build command**: `bun run --cwd apps/explorer vite build` (uses
  adapter-static, SPA mode, fallback: "index.html").
- **Preview command**: `bun run --cwd apps/explorer vite preview`.
- **Static assets**: `apps/explorer/static/` — manifest.json, PWA icons live
  here.
