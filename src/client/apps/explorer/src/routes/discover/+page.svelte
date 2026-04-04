<script lang="ts">
  import {
    createDishStore,
    createGeoStore,
    createBusinessStore,
  } from "@sdk/state";
  import { DishCard, DishDetailModal, ZoneSelector, MapView } from "@sdk/ui";
  import { DISH_CATEGORIES } from "@sdk/core";
  import type { Dish } from "@sdk/core";
  import { m } from "@sdk/ui";

  const dishStore = createDishStore();
  const geoStore = createGeoStore();
  const businessStore = createBusinessStore();

  let selectedDish = $state<Dish | null>(null);
  let isDetailOpen = $state(false);
  let categoriaActiva = $state("Todos");

  const categorias = $derived([
    { key: "Todos", label: m.discover_all() },
    ...DISH_CATEGORIES.map((c) => ({
      key: c.key,
      label: (m as any)[`cat_${c.key}`]?.() ?? c.label,
    })),
  ]);

  const filteredDishes = $derived(
    categoriaActiva === "Todos"
      ? dishStore.all
      : dishStore.all.filter((d: Dish) => d.category === categoriaActiva),
  );

  // Map needs business entities, mapping them from summaries for now
  const businessesForMap = $derived(
    businessStore.all.map((b: any) => ({
      id: b.id,
      name: b.name,
      category: b.category,
      address: "—",
      rating: 4.5,
      lat: 19.4326 + (Math.random() - 0.5) * 0.01,
      lng: -99.1332 + (Math.random() - 0.5) * 0.01,
      open: true,
    })),
  );

  function openDetail(dish: Dish) {
    selectedDish = dish;
    isDetailOpen = true;
  }
</script>

<svelte:head>
  <title>{m.app_name()} — {m.nav_discover()}</title>
</svelte:head>

<main class="container mx-auto px-4 pt-6 pb-10 max-w-6xl">
  <div class="mb-8">
    <h1 class="text-3xl font-extrabold text-neutral-100 tracking-tight">
      {m.discover_hello()} 👋
    </h1>
    <p class="text-neutral-500 text-xs mt-1 font-medium italic">
      {m.discover_subtitle()}
    </p>
  </div>

  <ZoneSelector
    zones={geoStore.allZones}
    selectedZoneId={geoStore.currentZone?.id ?? ""}
    onchange={(id) => geoStore.setZone(id)}
  />

  <div
    class="mb-8 rounded-3xl overflow-hidden shadow-2xl border border-white/10"
  >
    <MapView businesses={businessesForMap} height="300px" />
  </div>

  <!-- Category filters -->
  <div class="flex gap-2 overflow-x-auto pb-3 mb-7 scrollbar-hide">
    {#each categorias as cat}
      <button
        onclick={() => {
          categoriaActiva = cat.key;
        }}
        class="flex items-center gap-2 px-4 py-2 rounded-full text-[11px] font-bold uppercase tracking-wider
                 flex-shrink-0 border transition-all duration-300
                 {categoriaActiva === cat.key
          ? 'bg-orange-500 text-white border-orange-500 shadow-lg shadow-orange-900/20'
          : 'bg-neutral-900/40 backdrop-blur-sm text-neutral-400 border-white/10 hover:bg-white/5'}"
      >
        <span>{cat.label}</span>
      </button>
    {/each}
  </div>

  <!-- Food grid -->
  <div
    class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6 pb-12"
  >
    {#each filteredDishes as dish}
      <DishCard {dish} onselect={() => openDetail(dish)} />
    {/each}
  </div>

  {#if filteredDishes.length === 0}
    <div class="text-center py-20">
      <p class="text-5xl mb-3">🔍</p>
      <p class="text-stone-400 font-medium">{m.discover_no_results()}</p>
    </div>
  {/if}
</main>

<DishDetailModal
  dish={selectedDish}
  open={isDetailOpen}
  onclose={() => {
    isDetailOpen = false;
  }}
/>
