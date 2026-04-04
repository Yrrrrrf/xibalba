<script lang="ts">
  // @ts-ignore
  import { createDishStore } from "@sdk/state";
  import { GlassCard, PriceTag, StatusBadge } from "@sdk/ui";
  // @ts-ignore
  import * as m from "$lib/paraglide/messages.js";

  const dishStore = createDishStore();
</script>

<svelte:head>
  <title>{m.app_name()} — {m.nav_menu()}</title>
</svelte:head>

<main class="container mx-auto px-4 pt-6 pb-10 max-w-5xl">
  <div class="flex items-center justify-between mb-8">
    <div>
      <h1 class="text-3xl font-extrabold text-neutral-100 tracking-tight">
        {m.menu_title()} 📖
      </h1>
      <p class="text-neutral-500 text-xs mt-1 font-medium italic">
        {m.menu_subtitle()}
      </p>
    </div>
    <a
      href="/menu/new"
      class="btn bg-orange-500 hover:bg-orange-600 text-white font-bold rounded-2xl border-none shadow-lg shadow-orange-900/20"
    >
      + {m.menu_add()}
    </a>
  </div>

  <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 pb-12">
    {#each dishStore.all as dish}
      <GlassCard class="p-4 group">
        <div class="flex items-start justify-between gap-4">
          <div class="flex-1 min-w-0">
            <h3 class="font-bold text-neutral-100 truncate">{dish.name}</h3>
            <p class="text-xs text-neutral-500">{dish.category}</p>
          </div>
          <StatusBadge status={dish.available ? 'active_food' : 'hidden_food'} />
        </div>

        <div class="mt-4 flex items-center justify-between">
          <PriceTag amount={dish.price} size="sm" />
          <div class="flex gap-2">
            <button class="btn btn-xs btn-ghost hover:bg-orange-500/10 text-orange-400">{m.merchant_edit()}</button>
            <button class="btn btn-xs btn-ghost hover:bg-rose-500/10 text-rose-400">{m.merchant_pause()}</button>
          </div>
        </div>
      </GlassCard>
    {/each}

    {#if dishStore.all.length === 0}
      <div class="col-span-full text-center py-20 bg-neutral-900/40 rounded-3xl border border-dashed border-white/10">
        <p class="text-4xl mb-3">🍽️</p>
        <p class="text-stone-400">{m.merchant_no_dishes()}</p>
        <a href="/menu/new" class="btn btn-link text-orange-500 mt-2">{m.merchant_no_dishes_sub()}</a>
      </div>
    {/if}
  </div>
</main>
