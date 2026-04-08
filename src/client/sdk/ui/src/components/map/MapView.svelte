<script lang="ts">
  import { onMount, onDestroy } from "svelte";
  import { MapPin, Store, TriangleAlert } from 'lucide-svelte';
  import { makeMarkerIcon, CATEGORY_ICONS } from "../../icons/mod.ts";
  import type { Business } from "@sdk/core";
  import * as m from "../../../src/i18n/paraglide/messages.js";

  interface Props {
    height?: string;
    businesses?: Business[];
    showUserLocation?: boolean;
    onbusinessselect?: (b: Business) => void;
  }

  let {
    height = "420px",
    businesses = [],
    showUserLocation = true,
    onbusinessselect,
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

  function getCategoryIconName(cat: string): string {
    const iconMap: Record<string, string> = {
      mexican: "ChefHat",
      seafood: "Fish",
      street_food: "Flame",
      drinks: "CupSoda",
      desserts: "CakeSlice",
      vegetarian: "Salad",
      fast_food: "Hamburger",
      international: "Soup",
    };
    return iconMap[cat] ?? "Utensils";
  }

  function buildPopup(c: Business) {
    const statusText = c.open ? m.badge_open() : m.badge_closed();
    
    // Inline SVGs for popup
    const starSvg = `<svg style="width:12px;height:12px;display:inline;vertical-align:middle;margin-right:2px" viewBox="0 0 24 24" fill="oklch(var(--wa))" stroke="oklch(var(--wa))" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M11.525 2.295a.53.53 0 0 1 .95 0l2.31 4.679a2.123 2.123 0 0 0 1.595 1.16l5.166.756a.53.53 0 0 1 .294.904l-3.736 3.638a2.123 2.123 0 0 0-.611 1.878l.882 5.14a.53.53 0 0 1-.771.56l-4.618-2.428a2.122 2.122 0 0 0-1.973 0L6.396 21.01a.53.53 0 0 1-.77-.56l.881-5.139a2.122 2.122 0 0 0-.611-1.879L2.16 9.795a.53.53 0 0 1 .294-.906l5.165-.755a2.122 2.122 0 0 0 1.597-1.16z" /></svg>`;
    const pinSvg = `<svg style="width:10px;height:10px;display:inline;vertical-align:middle;margin-right:4px;color:oklch(var(--bc)/0.5)" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 10c0 4.993-5.539 10.193-7.399 11.799a1 1 0 0 1-1.202 0C9.539 20.193 4 14.993 4 10a8 8 0 0 1 16 0" /><circle cx="12" cy="10" r="3" /></svg>`;

    return `
      <div style="min-width:180px;font-family:system-ui;color:oklch(var(--bc))">
        <p style="font-weight:700;font-size:14px;margin:0 0 2px;color:oklch(var(--bc))">${c.name}</p>
        <p style="font-size:11px;color:oklch(var(--bc)/0.6);margin:0 0 6px">${c.category}</p>
        <p style="font-size:11px;margin:0 0 4px">${pinSvg}${c.address}</p>
        <div style="display:flex;align-items:center;gap:8px;margin-top:4px">
          <span style="font-size:12px">${starSvg}<strong>${c.rating}</strong></span>
          <span style="font-size:11px;padding:2px 8px;border-radius:999px;background:${c.open ? "oklch(var(--su)/0.15)" : "oklch(var(--er)/0.15)"};color:${c.open ? "oklch(var(--su))" : "oklch(var(--er))"};border:1px solid ${c.open ? "oklch(var(--su)/0.2)" : "oklch(var(--er)/0.2)"}">
            ● ${statusText}
          </span>
        </div>
      </div>`;
  }

  async function initMap() {
    if (typeof window === "undefined") return;
    L = (await import("leaflet")).default;

    // Fix default icon paths broken by bundlers
    delete (L.Icon.Default.prototype as any)._getIconUrl;
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
        iconUrl: makeMarkerIcon(
          getCategoryIconName(c.category),
          c.open ? "#10b981" : "#6b7280",
        ),
        iconSize: [36, 44],
        iconAnchor: [18, 44],
        popupAnchor: [0, -44],
      });
      L.marker([c.lat, c.lng], { icon })
        .addTo(map!)
        .on('click', () => onbusinessselect?.(c))
        .bindPopup(buildPopup(c), { maxWidth: 220 });
    }

    // User marker placeholder
    if (showUserLocation) {
      const userIcon = L.icon({
        iconUrl: makeMarkerIcon("MapPin", "#6366f1"),
        iconSize: [40, 48],
        iconAnchor: [20, 48],
        popupAnchor: [0, -48],
      });
      userMarker = L.marker([userLat, userLng], {
        icon: userIcon,
        zIndexOffset: 1000,
      })
        .addTo(map!)
        .bindPopup("<strong>" + m.map_use_location() + "</strong>");
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
          <MapPin size={16} />
          {m.map_use_location()}
        {/if}
      </button>

      <!-- Legend -->
      <div
        class="bg-base-200/90 backdrop-blur rounded-xl px-3 py-2 shadow text-xs space-y-1 text-base-content/80 border border-base-content/10"
      >
        <p class="font-semibold text-base-content/60 mb-1">Leyenda</p>
        <div class="flex items-center gap-2">
          <span class="inline-block w-3 h-3 rounded-full bg-success"></span>
          <span>{m.badge_open()}</span>
        </div>
        <div class="flex items-center gap-2">
          <span class="inline-block w-3 h-3 rounded-full bg-base-content/40"></span>
          <span>{m.badge_closed()}</span>
        </div>
        <div class="flex items-center gap-2">
          <span class="inline-block w-3 h-3 rounded-full bg-primary"></span>
          <span>Tú</span>
        </div>
      </div>
    </div>
  {/if}

  <!-- Error toast -->
  {#if locationError}
    <div
      class="absolute bottom-4 left-1/2 -translate-x-1/2 z-[999] alert alert-warning shadow-lg py-2 px-4 text-xs max-w-xs text-center flex items-center gap-2"
    >
      <TriangleAlert size={14} />
      {locationError}
    </div>
  {/if}

  <!-- Businesses count badge -->
  <div class="absolute top-3 right-3 z-[999]">
    <div
      class="badge badge-neutral badge-lg shadow font-semibold gap-2 border-base-content/10 bg-base-300/80 backdrop-blur text-base-content"
    >
      <Store size={14} />
      {businesses.length}
      {m.map_businesses_count()}
    </div>
  </div>
</div>
