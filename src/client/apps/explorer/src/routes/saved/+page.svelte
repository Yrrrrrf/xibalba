<script lang="ts">
  import { createDishStore, createVisitorStore } from "@sdk/state";
  import { SavedDishCard } from "@sdk/ui";
  import type { Dish } from "@sdk/core";
  import { m } from "@sdk/ui";

  const dishStore = createDishStore();
  const visitorStore = createVisitorStore();

  const savedDishes = $derived(
    visitorStore.saved
      .map((s: any) => dishStore.findById(s.dish_id))
      .filter((d: Dish | undefined) => d !== undefined),
  );
</script>

<svelte:head>
  <title>{m.app_name()} — {m.nav_saved()}</title>
</svelte:head>

<main class="container mx-auto px-4 pt-6 pb-10 max-w-lg">
  <div class="mb-8">
    <h1 class="text-3xl font-extrabold text-neutral-100 tracking-tight">
      {m.saved_title()} ❤️
    </h1>
    <p class="text-neutral-500 text-xs mt-1 font-medium italic">
      {m.saved_subtitle()}
    </p>
  </div>

  <div class="space-y-4 pb-12">
    {#each savedDishes as dish}
      <div
        class="bg-neutral-900/60 backdrop-blur-xl border border-white/10 rounded-2xl shadow-xl"
      >
        <SavedDishCard {dish} onremove={(id) => visitorStore.remove(id)} />
      </div>
    {/each}

    {#if savedDishes.length === 0}
      <div class="text-center py-20">
        <p class="text-5xl mb-3">❤️</p>
        <p class="text-stone-400 font-medium">{m.saved_empty()}</p>
        <a href="/discover" class="btn btn-link text-orange-500 mt-2"
          >{m.saved_explore()}</a
        >
      </div>
    {/if}
  </div>
</main>
