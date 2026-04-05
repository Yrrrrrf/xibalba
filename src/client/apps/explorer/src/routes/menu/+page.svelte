<script lang="ts">
  import { createDishStore } from "@sdk/state";
  import { GlassCard, PriceTag, StatusBadge, ICONS } from "@sdk/ui";
  import { m } from "@sdk/ui";
  import { Plus } from 'lucide-svelte';

  const dishStore = createDishStore();
</script>

<svelte:head>
  <title>{m.app_name()} — {m.nav_menu()}</title>
</svelte:head>

<main class="container mx-auto px-4 pt-6 pb-10 max-w-5xl">
  <div class="flex items-center justify-between mb-8">
    <div>
      <h1 class="text-3xl font-extrabold text-base-content tracking-tight flex items-center gap-3">
        {m.menu_title()} <ICONS.book_menu size={32} class="text-primary" />
      </h1>
      <p class="text-base-content/50 text-xs mt-1 font-medium italic">
        {m.menu_subtitle()}
      </p>
    </div>
    <a
      href="/menu/new"
      class="btn btn-primary font-bold rounded-2xl shadow-lg shadow-primary/20 gap-2 h-auto py-3 px-6"
    >
      <Plus size={18} /> {m.menu_add()}
    </a>
  </div>

  <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 pb-12">
    {#each dishStore.all as dish}
      <GlassCard class="p-4 group">
        <div class="flex items-start justify-between gap-4">
          <div class="flex-1 min-w-0">
            <h3 class="font-bold text-base-content truncate">{dish.name}</h3>
            <p class="text-xs text-base-content/60">{dish.category}</p>
          </div>
          <StatusBadge
            status={dish.available ? "active_food" : "hidden_food"}
          />
        </div>

        <div class="mt-4 flex items-center justify-between">
          <PriceTag amount={dish.price} size="sm" />
          <div class="flex gap-2">
            <button
              class="btn btn-xs btn-ghost hover:bg-primary/10 text-primary"
              >{m.merchant_edit()}</button
            >
            <button
              class="btn btn-xs btn-ghost hover:bg-error/10 text-error"
              >{m.merchant_pause()}</button
            >
          </div>
        </div>
      </GlassCard>
    {/each}

    {#if dishStore.all.length === 0}
      <div
        class="col-span-full text-center py-20 bg-base-200/40 rounded-3xl border border-dashed border-base-content/10 flex flex-col items-center justify-center"
      >
        <div class="text-base-content/30 mb-3">
          <ICONS.nav_menu size={48} strokeWidth={1.5} />
        </div>
        <p class="text-base-content/40">{m.merchant_no_dishes()}</p>
        <a href="/menu/new" class="btn btn-link text-primary mt-2"
          >{m.merchant_no_dishes_sub()}</a
        >
      </div>
    {/if}
  </div>
</main>
