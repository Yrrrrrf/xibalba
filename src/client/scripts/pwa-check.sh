#!/usr/bin/env bash
# ═══════════════════════════════════════════════════
#  Xibalbá PWA Installability — Automated Test Suite
# ═══════════════════════════════════════════════════
#
#  Run from:  src/client/
#  Usage:     ./scripts/pwa-check.sh
#  Requires:  bun
#
#  Exit code: number of failures (0 = all passed)
# ═══════════════════════════════════════════════════

set -euo pipefail

STATIC="apps/explorer/static"
HTML="apps/explorer/src/app.html"
SW="apps/explorer/src/service-worker.ts"
MANIFEST="$STATIC/manifest.json"

PASS=0
FAIL=0

pass() { echo "  ✅ $1"; ((PASS++)) || true; }
fail() { echo "  ❌ $1"; ((FAIL++)) || true; }

echo ""
echo "🦇 ═══════════════════════════════════════"
echo "   Xibalbá PWA Installability Test Suite"
echo "   ═══════════════════════════════════════"

# ── Phase 0: File existence ──────────────────────

echo ""
echo "━━ Phase 0: Required files exist ━━"

for f in \
  "$MANIFEST" \
  "$STATIC/pwa-192x192.png" \
  "$STATIC/pwa-512x512.png" \
  "$STATIC/pwa-maskable-512x512.png" \
  "$STATIC/apple-touch-icon.png" \
  "$STATIC/favicon-48x48.png" \
  "$STATIC/favicon-32x32.png" \
  "$STATIC/favicon-16x16.png" \
  "$STATIC/screenshots/mobile-discover.png" \
  "$STATIC/screenshots/mobile-menu.png" \
  "$STATIC/screenshots/desktop-discover.png" \
  "$SW" \
  "$HTML"; do
  [ -f "$f" ] && pass "$f" || fail "MISSING $f"
done

# ── Phase 1: Manifest fields ────────────────────

echo ""
echo "━━ Phase 1: Manifest fields ━━"

echo ""
echo "  ── Chrome install requirements (P0) ──"
for field in name short_name start_url display icons; do
  bun -e "
    const m = JSON.parse(await Bun.file('$MANIFEST').text());
    if (m['$field'] === undefined) process.exit(1);
  " 2>/dev/null && pass "$field" || fail "$field"
done

echo ""
echo "  ── Recommended for full installability (P1) ──"
for field in id scope description screenshots; do
  bun -e "
    const m = JSON.parse(await Bun.file('$MANIFEST').text());
    if (m['$field'] === undefined) process.exit(1);
  " 2>/dev/null && pass "$field" || fail "$field"
done

echo ""
echo "  ── Nice to have (P2) ──"
for field in display_override categories orientation background_color theme_color; do
  bun -e "
    const m = JSON.parse(await Bun.file('$MANIFEST').text());
    if (m['$field'] === undefined) process.exit(1);
  " 2>/dev/null && pass "$field" || fail "$field"
done

# ── Phase 1b: Icon entries ──────────────────────

echo ""
echo "━━ Phase 1b: Icon entries ━━"

bun -e "
  const m = JSON.parse(await Bun.file('$MANIFEST').text());
  const icons = m.icons || [];

  const has = (s, p) => icons.some(i => i.sizes === s && (i.purpose || 'any') === (p || 'any'));

  if (has('192x192'))         console.log('  ✅ 192x192 icon');
  else                        { console.log('  ❌ MISSING 192x192 icon'); process.exitCode = 1; }

  if (has('512x512'))         console.log('  ✅ 512x512 icon');
  else                        { console.log('  ❌ MISSING 512x512 icon'); process.exitCode = 1; }

  if (has('512x512', 'maskable')) console.log('  ✅ 512x512 maskable icon');
  else                        { console.log('  ❌ MISSING 512x512 maskable icon'); process.exitCode = 1; }

  if (has('180x180'))         console.log('  ✅ 180x180 apple icon');
  else                        console.log('  ⚠️  No 180x180 apple icon in manifest (OK if <link> tag handles it)');

  // Check for the anti-pattern: any maskable on the same entry
  const anyMaskable = icons.some(i => i.purpose === 'any maskable');
  if (anyMaskable) {
    console.log('  ⚠️  WARNING: Found purpose \"any maskable\" on same icon — Chrome recommends separate entries');
  }
" 2>/dev/null

# ── Phase 1c: Screenshot entries ────────────────

echo ""
echo "━━ Phase 1c: Screenshot entries ━━"

bun -e "
  const m = JSON.parse(await Bun.file('$MANIFEST').text());
  const ss = m.screenshots || [];

  if (ss.length === 0) {
    console.log('  ❌ No screenshots — richer install UI will not trigger');
    process.exitCode = 1;
  } else {
    console.log('  ✅ ' + ss.length + ' screenshot(s) found');
  }

  const hasNarrow = ss.some(s => s.form_factor === 'narrow');
  const hasWide   = ss.some(s => s.form_factor === 'wide');

  if (hasNarrow) console.log('  ✅ Has narrow (mobile) screenshot');
  else           console.log('  ❌ No narrow screenshot — richer mobile install sheet will not trigger');

  if (hasWide)   console.log('  ✅ Has wide (desktop) screenshot');
  else           console.log('  ⚠️  No wide screenshot — richer desktop install dialog will not trigger');

  // Validate dimensions
  for (const s of ss) {
    const [w, h] = s.sizes.split('x').map(Number);
    if (w < 320 || h < 320) {
      console.log('  ❌ Screenshot ' + s.src + ' is smaller than 320px minimum');
      process.exitCode = 1;
    }
    if (w > 3840 || h > 3840) {
      console.log('  ❌ Screenshot ' + s.src + ' exceeds 3840px maximum');
      process.exitCode = 1;
    }
    const ratio = Math.max(w, h) / Math.min(w, h);
    if (ratio > 2.3) {
      console.log('  ❌ Screenshot ' + s.src + ' aspect ratio ' + ratio.toFixed(2) + ' exceeds 2.3:1 limit');
      process.exitCode = 1;
    }
  }
" 2>/dev/null

# ── Phase 2: HTML meta tags ─────────────────────

echo ""
echo "━━ Phase 2: app.html meta tags ━━"

check_html() {
  grep -q "$1" "$HTML" && pass "$2" || fail "$2"
}

check_html 'rel="manifest"'                       '<link rel="manifest">'
check_html 'name="theme-color"'                    '<meta name="theme-color">'
check_html 'name="description"'                    '<meta name="description">'
check_html 'name="viewport"'                       '<meta name="viewport">'
check_html 'name="apple-mobile-web-app-capable"'   'apple-mobile-web-app-capable'
check_html 'name="apple-mobile-web-app-status-bar' 'apple-mobile-web-app-status-bar-style'
check_html 'name="apple-mobile-web-app-title"'     'apple-mobile-web-app-title'

# apple-touch-icon: must exist AND not be commented out
if grep -q 'rel="apple-touch-icon"' "$HTML"; then
  if grep -q '<!--.*apple-touch-icon' "$HTML"; then
    fail 'apple-touch-icon exists but is COMMENTED OUT'
  else
    pass 'apple-touch-icon (active, not commented)'
  fi
else
  fail 'apple-touch-icon link tag missing'
fi

# Favicon links
check_html 'rel="icon"' 'At least one <link rel="icon"> tag'

# ── Phase 3: Service worker ─────────────────────

echo ""
echo "━━ Phase 3: Service worker handlers ━━"

check_sw() {
  grep -q "$1" "$SW" && pass "$2" || fail "$2"
}

check_sw 'addEventListener.*install'   'install event listener'
check_sw 'addEventListener.*activate'  'activate event listener'
check_sw 'addEventListener.*fetch'     'fetch event listener'
check_sw 'skipWaiting'                 'skipWaiting() call'
check_sw 'clients.claim'              'clients.claim() call'
check_sw '\$service-worker'            '$service-worker import (SvelteKit)'

# ── Phase 4: prefer_related_applications guard ──

echo ""
echo "━━ Phase 4: Anti-patterns ━━"

bun -e "
  const m = JSON.parse(await Bun.file('$MANIFEST').text());
  if (m.prefer_related_applications === true) {
    console.log('  ❌ prefer_related_applications is true — Chrome will NOT show the install prompt');
    process.exitCode = 1;
  } else {
    console.log('  ✅ prefer_related_applications is not true');
  }
" 2>/dev/null

# ── Summary ─────────────────────────────────────

echo ""
echo "═══════════════════════════════════════"
echo "  TOTAL: $PASS ✅  |  $FAIL ❌"
echo "═══════════════════════════════════════"

if [ "$FAIL" -eq 0 ]; then
  echo ""
  echo "  🎉 All automated checks passed!"
  echo ""
  echo "  Next steps (manual):"
  echo "    1. Build:    bun run --cwd apps/explorer vite build"
  echo "    2. Preview:  bun run --cwd apps/explorer vite preview --host"
  echo "    3. Open Chrome → DevTools → Application → Manifest"
  echo "       → verify no warnings in the Installability section"
  echo "    4. DevTools → Application → Service Workers"
  echo "       → verify 'activated and is running'"
  echo "    5. Run Lighthouse → check PWA badges"
  echo "    6. Test on a real Android device via Chrome"
  echo "    7. Test on a real iOS device via Safari"
  echo ""
else
  echo ""
  echo "  ⚠️  Fix the failures above, then re-run."
  echo ""
fi

exit "$FAIL"
