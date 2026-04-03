<script lang="ts">
  import { onMount, onDestroy } from 'svelte';

  interface Props {
    height?: string;
    initialLat?: number;
    initialLng?: number;
    onlocationchange?: (lat: number, lng: number, address?: string) => void;
  }

  let {
    height = '380px',
    initialLat = 19.4326,
    initialLng = -99.1332,
    onlocationchange,
  }: Props = $props();

  let mapEl: HTMLDivElement;
  let map: import('leaflet').Map | null = null;
  let marker: import('leaflet').Marker | null = null;
  let L: typeof import('leaflet') | null = null;

  let pickedLat = $state(initialLat);
  let pickedLng = $state(initialLng);
  let address = $state('');
  let geocoding = $state(false);
  let confirmed = $state(false);
  let locating = $state(false);

  function makeIcon(color: string) {
    const svg = `
      <svg xmlns="http://www.w3.org/2000/svg" width="40" height="50" viewBox="0 0 40 50">
        <filter id="s"><feDropShadow dx="0" dy="3" stdDeviation="3" flood-opacity="0.35"/></filter>
        <path filter="url(#s)" d="M20 3C11.2 3 4 10.2 4 19c0 12 16 28 16 28S36 31 36 19C36 10.2 28.8 3 20 3z" fill="${color}"/>
        <circle cx="20" cy="19" r="10" fill="white" opacity="0.95"/>
        <text x="20" y="23" text-anchor="middle" font-size="13">🏪</text>
      </svg>`;
    return `data:image/svg+xml;base64,${btoa(svg)}`;
  }

  async function reverseGeocode(lat: number, lng: number) {
    geocoding = true;
    address = '';
    try {
      const res = await fetch(
        `https://nominatim.openstreetmap.org/reverse?lat=${lat}&lon=${lng}&format=json`,
        { headers: { 'Accept-Language': 'es' } }
      );
      const data = await res.json();
      address = data.display_name ?? `${lat.toFixed(5)}, ${lng.toFixed(5)}`;
    } catch {
      address = `${lat.toFixed(5)}, ${lng.toFixed(5)}`;
    } finally {
      geocoding = false;
    }
  }

  function updatePickedLocation(lat: number, lng: number) {
    pickedLat = lat;
    pickedLng = lng;
    confirmed = false;
    marker?.setLatLng([lat, lng]);
    marker?.openPopup();
    reverseGeocode(lat, lng);
  }

  async function locateMe() {
    if (!navigator.geolocation) return;
    locating = true;
    navigator.geolocation.getCurrentPosition(
      (pos) => {
        const { latitude, longitude } = pos.coords;
        map?.flyTo([latitude, longitude], 17, { duration: 1.4 });
        updatePickedLocation(latitude, longitude);
        locating = false;
      },
      () => { locating = false; },
      { timeout: 8000, enableHighAccuracy: true }
    );
  }

  function confirmLocation() {
    confirmed = true;
    onlocationchange?.(pickedLat, pickedLng, address);
  }

  async function initMap() {
    L = (await import('leaflet')).default;

    // @ts-ignore
    delete L.Icon.Default.prototype._getIconUrl;
    L.Icon.Default.mergeOptions({
      iconUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon.png',
      iconRetinaUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon-2x.png',
      shadowUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-shadow.png',
    });

    map = L.map(mapEl, { zoomControl: false }).setView([initialLat, initialLng], 15);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '© <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>',
      maxZoom: 19,
    }).addTo(map);

    L.control.zoom({ position: 'bottomright' }).addTo(map);

    const icon = L.icon({
      iconUrl: makeIcon('#f59e0b'),
      iconSize: [40, 50],
      iconAnchor: [20, 50],
      popupAnchor: [0, -50],
    });

    marker = L.marker([initialLat, initialLng], { icon, draggable: true })
      .addTo(map!)
      .bindPopup('📍 Arrastra el marcador<br>o haz clic en el mapa', { closeButton: false });

    marker.on('dragend', (e) => {
      const latlng = (e.target as import('leaflet').Marker).getLatLng();
      updatePickedLocation(latlng.lat, latlng.lng);
    });

    map.on('click', (e: import('leaflet').LeafletMouseEvent) => {
      map?.flyTo(e.latlng, map.getZoom(), { duration: 0.5 });
      updatePickedLocation(e.latlng.lat, e.latlng.lng);
    });

    // Initial geocode
    reverseGeocode(initialLat, initialLng);
  }

  onMount(() => { initMap(); });
  onDestroy(() => { map?.remove(); map = null; });
</script>

<svelte:head>
  <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
</svelte:head>

<div class="space-y-3">
  <!-- Instrucción -->
  <div class="alert bg-cyan-500/10 border-cyan-500/20 text-cyan-400 py-2 text-xs font-bold uppercase tracking-wider">
    <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
    </svg>
    <span>Haz clic en el mapa o arrastra el marcador 🏪 para fijar la ubicación de tu negocio</span>
  </div>

  <!-- Botones top -->
  <div class="flex gap-2 flex-wrap">
    <button
      onclick={locateMe}
      disabled={locating}
      class="btn btn-sm btn-outline btn-secondary gap-2"
    >
      {#if locating}
        <span class="loading loading-spinner loading-xs"></span>
      {:else}
        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"/>
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"/>
        </svg>
      {/if}
      Usar mi ubicación
    </button>
  </div>

  <!-- Map -->
  <div class="relative rounded-2xl overflow-hidden border border-white/10 shadow-2xl" style="height:{height}">
    <div bind:this={mapEl} class="w-full h-full z-0 grayscale-[0.3] invert-[0.05]"></div>

    <!-- Crosshair hint -->
    <div class="absolute bottom-10 left-1/2 -translate-x-1/2 z-[999] pointer-events-none">
      <div class="bg-black/60 backdrop-blur-md rounded-full px-4 py-1.5 text-[10px] font-bold uppercase tracking-widest text-white/80 border border-white/10 shadow-lg">
        👆 Toca para mover el marcador
      </div>
    </div>
  </div>

  <!-- Coordinates display -->
  <div class="grid grid-cols-2 gap-3">
    <div class="form-control">
      <label class="label py-1">
        <span class="label-text text-[10px] font-bold uppercase tracking-wider text-neutral-500">Latitud</span>
      </label>
      <input
        type="text"
        class="input bg-black/20 border-white/10 text-white input-sm font-mono"
        readonly
        value={pickedLat.toFixed(6)}
      />
    </div>
    <div class="form-control">
      <label class="label py-1">
        <span class="label-text text-[10px] font-bold uppercase tracking-wider text-neutral-500">Longitud</span>
      </label>
      <input
        type="text"
        class="input bg-black/20 border-white/10 text-white input-sm font-mono"
        readonly
        value={pickedLng.toFixed(6)}
      />
    </div>
  </div>

  <!-- Address display -->
  <div class="form-control">
    <label class="label py-1">
      <span class="label-text text-[10px] font-bold uppercase tracking-wider text-neutral-500">📍 Dirección detectada</span>
    </label>
    <div class="flex items-center gap-2">
      {#if geocoding}
        <div class="flex items-center gap-2 text-xs font-bold text-neutral-500 px-3 py-2.5 bg-white/5 border border-white/5 rounded-xl w-full">
          <span class="loading loading-dots loading-xs"></span>
          Obteniendo dirección...
        </div>
      {:else}
        <p class="text-xs px-3 py-2.5 bg-white/5 border border-white/5 rounded-xl flex-1 leading-snug text-neutral-300 italic">{address || '—'}</p>
      {/if}
    </div>
  </div>

  <!-- Confirm button -->
  <button
    onclick={confirmLocation}
    class="btn btn-warning w-full gap-2 {confirmed ? 'btn-success' : 'btn-warning'}"
  >
    {#if confirmed}
      <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
      </svg>
      ¡Ubicación guardada!
    {:else}
      📌 Confirmar ubicación del negocio
    {/if}
  </button>
</div>
