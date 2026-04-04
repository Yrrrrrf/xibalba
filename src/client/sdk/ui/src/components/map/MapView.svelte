<script lang="ts">
  import { onMount, onDestroy } from "svelte";
  import type { Business } from "@sdk/core";
  import * as m from "../../../src/i18n/paraglide/messages.js";

  interface Props {
    height?: string;
    businesses?: Business[];
    showUserLocation?: boolean;
  }

  let {
    height = "420px",
    businesses = [],
    showUserLocation = true,
  }: Props = $props();

  // Centro: Ciudad de México (sede Mundial 2026)
  const DEFAULT_LAT = 19.4326;
  const DEFAULT_LNG = -99.1332;

  let mapEl: HTMLDivElement;
  let map: import("leaflet").Map | null = null;
  let userMarker: import("leaflet").Marker | null = null;
  let L: typeof import("leaflet") | null = null;
  let locating = $state(false);
  let locationError = $state("");
  let userLat = $state(DEFAULT_LAT);
  let userLng = $state(DEFAULT_LNG);

  // ── Iconos SVG inline codificados ──────────────────────────────────
  function makeIcon(color: string, emoji: string) {
    const svg = `
      <svg xmlns="http://www.w3.org/2000/svg" width="36" height="44" viewBox="0 0 36 44">
        <filter id="s"><feDropShadow dx="0" dy="2" stdDeviation="2" flood-opacity="0.3"/></filter>
        <path filter="url(#s)" d="M18 2C10.3 2 4 8.3 4 16c0 10.5 14 26 14 26S32 26.5 32 16C32 8.3 25.7 2 18 2z" fill="${color}"/>
        <circle cx="18" cy="16" r="9" fill="white" opacity="0.95"/>
        <text x="18" y="20" text-anchor="middle" font-size="11">${emoji}</text>
      </svg>`;
    return `data:image/svg+xml;base64,${btoa(svg)}`;
  }

  const categoryEmoji: Record<string, string> = {
    mexican: "🌮",
    seafood: "🦐",
    street_food: "🫔",
    drinks: "🥤",
    desserts: "🍩",
    vegetarian: "🥗",
    fast_food: "🍔",
    international: "🍜",
  };

  function getCategoryEmoji(cat: string) {
    return categoryEmoji[cat] ?? "🍽️";
  }

  function buildPopup(c: Business) {
    const statusText = c.open ? m.badge_open() : m.badge_closed();
    return `
      <div style="min-width:180px;font-family:system-ui">
        <p style="font-weight:700;font-size:14px;margin:0 0 2px">${c.name}</p>
        <p style="font-size:11px;color:#888;margin:0 0 6px">${getCategoryEmoji(c.category)} ${c.category}</p>
        <p style="font-size:11px;margin:0 0 4px">📍 ${c.address}</p>
        <div style="display:flex;align-items:center;gap:8px;margin-top:4px">
          <span style="font-size:12px">⭐ <strong>${c.rating}</strong></span>
          <span style="font-size:11px;padding:2px 8px;border-radius:999px;background:${c.open ? "#d1fae5" : "#fee2e2"};color:${c.open ? "#065f46" : "#991b1b"}">
            ● ${statusText}
          </span>
        </div>
      </div>`;
  }

  async function initMap() {
    if (typeof window === "undefined") return;
    L = (await import("leaflet")).default;

    // Fix default icon paths broken by bundlers
    delete L.Icon.Default.prototype._getIconUrl;
    L.Icon.Default.mergeOptions({
      iconUrl: "https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon.png",
      iconRetinaUrl:
        "https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon-2x.png",
      shadowUrl:
        "https://unpkg.com/leaflet@1.9.4/dist/images/marker-shadow.png",
    });

    if (!mapEl) return;
    map = L.map(mapEl, { zoomControl: false }).setView(
      [DEFAULT_LAT, DEFAULT_LNG],
      14,
    );

    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      attribution:
        '© <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>',
      maxZoom: 19,
    }).addTo(map);

    L.control.zoom({ position: "bottomright" }).addTo(map);

    // Business markers
    for (const c of businesses) {
      const icon = L.icon({
        iconUrl: makeIcon(
          c.open ? "#10b981" : "#6b7280",
          getCategoryEmoji(c.category),
        ),
        iconSize: [36, 44],
        iconAnchor: [18, 44],
        popupAnchor: [0, -44],
      });
      L.marker([c.lat, c.lng], { icon })
        .addTo(map!)
        .bindPopup(buildPopup(c), { maxWidth: 220 });
    }

    // User marker placeholder
    if (showUserLocation) {
      const userIcon = L.icon({
        iconUrl: makeIcon("#6366f1", "📍"),
        iconSize: [40, 48],
        iconAnchor: [20, 48],
        popupAnchor: [0, -48],
      });
      userMarker = L.marker([userLat, userLng], {
        icon: userIcon,
        zIndexOffset: 1000,
      })
        .addTo(map!)
        .bindPopup("<strong>📍 " + m.map_use_location() + "</strong>");
    }
  }

  async function locateMe() {
    if (!navigator.geolocation) {
      locationError = "Tu navegador no soporta geolocalización";
      return;
    }
    locating = true;
    locationError = "";
    navigator.geolocation.getCurrentPosition(
      (pos) => {
        userLat = pos.coords.latitude;
        userLng = pos.coords.longitude;
        userMarker?.setLatLng([userLat, userLng]);
        map?.flyTo([userLat, userLng], 16, { duration: 1.5 });
        locating = false;
      },
      (err) => {
        locationError =
          "No se pudo obtener tu ubicación. Usando posición por defecto.";
        locating = false;
        // Simulate movement to default center
        map?.flyTo([DEFAULT_LAT, DEFAULT_LNG], 14, { duration: 1 });
      },
      { timeout: 8000, enableHighAccuracy: true },
    );
  }

  onMount(() => {
    initMap();
  });

  onDestroy(() => {
    if (map) {
      map.remove();
      map = null;
    }
  });
</script>

<!-- Leaflet CSS via CDN -->
<svelte:head>
  <link
    rel="stylesheet"
    href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"
  />
</svelte:head>

<div
  class="relative w-full rounded-2xl overflow-hidden border border-white/10 shadow-md"
  style="height:{height}"
>
  <!-- Map container -->
  <div bind:this={mapEl} class="w-full h-full z-0"></div>

  <!-- Locate button overlay -->
  {#if showUserLocation}
    <div class="absolute top-3 left-3 z-[999] flex flex-col gap-2">
      <button
        onclick={locateMe}
        disabled={locating}
        class="btn btn-sm btn-primary shadow-lg gap-2"
        title={m.map_use_location()}
      >
        {#if locating}
          <span class="loading loading-spinner loading-xs"></span>
          ...
        {:else}
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="h-4 w-4"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"
            />
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"
            />
          </svg>
          {m.map_use_location()}
        {/if}
      </button>

      <!-- Legend -->
      <div
        class="bg-neutral-900/90 backdrop-blur rounded-xl px-3 py-2 shadow text-xs space-y-1 text-neutral-200 border border-white/10"
      >
        <p class="font-semibold text-neutral-400 mb-1">Leyenda</p>
        <div class="flex items-center gap-2">
          <span class="inline-block w-3 h-3 rounded-full bg-emerald-500"></span>
          <span>{m.badge_open()}</span>
        </div>
        <div class="flex items-center gap-2">
          <span class="inline-block w-3 h-3 rounded-full bg-gray-400"></span>
          <span>{m.badge_closed()}</span>
        </div>
        <div class="flex items-center gap-2">
          <span class="inline-block w-3 h-3 rounded-full bg-indigo-500"></span>
          <span>Tú</span>
        </div>
      </div>
    </div>
  {/if}

  <!-- Error toast -->
  {#if locationError}
    <div
      class="absolute bottom-4 left-1/2 -translate-x-1/2 z-[999] alert alert-warning shadow-lg py-2 px-4 text-xs max-w-xs text-center"
    >
      ⚠️ {locationError}
    </div>
  {/if}

  <!-- Businesses count badge -->
  <div class="absolute top-3 right-3 z-[999]">
    <div
      class="badge badge-neutral badge-lg shadow font-semibold gap-1 border-white/10 bg-neutral-900/80 backdrop-blur text-neutral-100"
    >
      🏪 {businesses.length}
      {m.map_businesses_count()}
    </div>
  </div>
</div>
