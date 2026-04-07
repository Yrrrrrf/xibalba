<script lang="ts">
  import { page } from "$app/stores";
  import { DishCard, GlassCard, ICONS, m } from "@sdk/ui";
  import { createDishStore } from "@sdk/state";
  import { MapPin, Star, Clock } from "lucide-svelte";
  import type { Dish } from "@sdk/core";

  const dishStore = createDishStore();
  const merchantId = $page.params.id;

  // Mocked Merchant Context based on param string for demonstration
  const merchant = {
    name: merchantId === "tacos-el-rey" ? "Tacos El Rey" : "Comercio Local",
    description: "Auténtica comida callejera con las recetas de la abuela. Especialidad en tacos, gringas y quesadillas.",
    rating: 4.8,
    reviews: 124,
    distance: "1.2 km",
    open: true,
    image_url: "https://images.unsplash.com/photo-1555396273-367ea4eb4db5?q=80&w=600&auto=format&fit=crop"
  };

  // Mocked Dishes filtered
  const merchantDishes = $derived(
    dishStore.all.slice(0, 10) // Fallback: just grab some global mock dishes 
  );
</script>

<svelte:head>
  <title>{merchant.name} — Menú</title>
</svelte:head>

<!-- Hero Section with Parallax feeling -->
<div class="relative h-[40vh] min-h-[300px] bg-base-300">
  <img 
    src={merchant.image_url} 
    alt={merchant.name}
    class="w-full h-full object-cover opacity-80"
  />
  <div class="absolute inset-0 bg-gradient-to-t from-base-100 via-base-100/60 to-transparent"></div>
  
  <div class="absolute inset-0 flex flex-col justify-end p-5 pb-8 container mx-auto max-w-5xl">
    <button onclick={() => history.back()} class="absolute top-5 left-4 btn btn-circle btn-sm btn-ghost bg-base-100/30 backdrop-blur-md">
      <ICONS.chevron_left size={20} />
    </button>

    <div class="flex items-end justify-between gap-4">
      <div class="text-base-content max-w-lg">
        <h1 class="text-4xl md:text-5xl font-extrabold tracking-tight drop-shadow-lg flex items-center gap-3">
          {merchant.name}
        </h1>
        <p class="text-base-content/80 mt-2 text-sm md:text-base font-semibold drop-shadow-md">
          {merchant.description}
        </p>
      </div>

      <div class="hidden sm:flex flex-col items-end gap-2 text-sm pb-1">
        <div class="flex items-center gap-1.5 px-3 py-1.5 rounded-full bg-base-100/50 backdrop-blur-xl border border-white/10 font-bold">
          <Star size={14} class="text-warning fill-warning" />
          {merchant.rating} <span class="text-base-content/50 font-normal">({merchant.reviews})</span>
        </div>
        <div class="flex items-center gap-1.5 px-3 py-1 rounded-full bg-base-100/50 backdrop-blur-xl border border-white/10 text-xs font-bold">
          <Clock size={12} class={merchant.open ? "text-success" : "text-error"} />
          {merchant.open ? "Abierto Ahora" : "Cerrado"}
        </div>
      </div>
    </div>
  </div>
</div>

<main class="container mx-auto px-4 pt-4 pb-12 max-w-5xl -mt-6 relative z-10">
  
  <!-- Mobile Stats (shown only on small screens) -->
  <div class="flex sm:hidden overflow-x-auto gap-3 mb-6 scrollbar-hide py-1">
    <div class="flex-shrink-0 flex items-center gap-1.5 px-4 py-2 rounded-2xl bg-base-200/80 backdrop-blur-md border border-base-content/5 font-bold text-sm shadow-sm">
      <Star size={16} class="text-warning fill-warning" />
      {merchant.rating} <span class="text-base-content/50 text-xs font-normal">({merchant.reviews})</span>
    </div>
    <div class="flex-shrink-0 flex items-center gap-1.5 px-4 py-2 rounded-2xl bg-base-200/80 backdrop-blur-md border border-base-content/5 font-bold text-sm shadow-sm">
      <MapPin size={16} class="text-info" />
      {merchant.distance}
    </div>
    <div class="flex-shrink-0 flex items-center gap-1.5 px-4 py-2 rounded-2xl bg-base-200/80 backdrop-blur-md border border-base-content/5 font-bold text-sm shadow-sm">
      <Clock size={16} class={merchant.open ? "text-success" : "text-error"} />
      {merchant.open ? "Abierto" : "Cerrado"}
    </div>
  </div>

  <div class="mb-6 flex items-center justify-between">
    <h2 class="text-2xl font-extrabold tracking-tight">Platillos Destacados</h2>
    <div class="flex gap-2">
      <button class="btn btn-sm btn-ghost btn-circle bg-base-200/50"><ICONS.search size={16}/></button>
    </div>
  </div>

  <!-- Food grid -->
  <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
    {#each merchantDishes as dish}
      <DishCard {dish} onselect={() => console.log('Open Modal', dish.id)} />
    {/each}
  </div>

  {#if merchantDishes.length === 0}
    <div class="text-center py-20 flex flex-col items-center justify-center">
      <GlassCard class="p-8 items-center bg-base-100/30">
        <ICONS.nav_menu size={48} strokeWidth={1.5} class="text-base-content/30 mb-3" />
        <p class="text-base-content/60 font-medium pb-2">Sin platillos disponibles en este momento.</p>
      </GlassCard>
    </div>
  {/if}
</main>
