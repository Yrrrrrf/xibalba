<script lang="ts">
  import { createDishStore, createVisitorStore } from "@sdk/state";
  import { SavedDishCard, ICONS } from "@sdk/ui";
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
    <h1 class="text-3xl font-extrabold text-base-content tracking-tight flex items-center gap-3">
      {m.saved_title()} <ICONS.nav_saved size={32} class="text-error fill-error" />
    </h1>
    <p class="text-base-content/50 text-xs mt-1 font-medium italic">
      {m.saved_subtitle()}
    </p>
  </div>

  <div class="space-y-4 pb-12">
    {#each savedDishes as dish}
      <div
        class="bg-base-200/60 backdrop-blur-xl border border-base-content/10 rounded-2xl shadow-xl"
      >
        <SavedDishCard {dish} onremove={(id) => visitorStore.remove(id)} />
      </div>
    {/each}

    {#if savedDishes.length === 0}
      <div class="text-center py-20 flex flex-col items-center justify-center">
        <div class="text-base-content/30 mb-3">
          <ICONS.nav_saved size={48} strokeWidth={1.5} />
        </div>
        <p class="text-base-content/40 font-medium">{m.saved_empty()}</p>
        <a href="/discover" class="btn btn-link text-primary mt-2"
          >{m.saved_explore()}</a
        >
      </div>
    {/if}
  </div>
</main>
