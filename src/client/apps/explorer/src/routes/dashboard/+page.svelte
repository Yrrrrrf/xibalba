<script lang="ts">
  // @ts-ignore
  import { createDishStore, createBusinessStore } from "@sdk/state";
  import { MerchantDashboard, StatsCard } from "@sdk/ui";
  // @ts-ignore
  import * as m from "$lib/paraglide/messages.js";

  const dishStore = createDishStore();
  const businessStore = createBusinessStore();

  const stats = $derived([
    { title: m.merchant_total_dishes(), value: dishStore.all.length, icon: '🍽️', variant: 'primary' as const, trend: 'neutral' as const },
    { title: m.merchant_total_sales(), value: dishStore.all.reduce((acc: number, d: any) => acc + d.sales_count, 0), icon: '💰', variant: 'success' as const, trend: 'up' as const, trendValue: '+5%' },
  ]);
</script>

<svelte:head>
  <title>{m.app_name()} — {m.nav_dashboard()}</title>
</svelte:head>

<main class="container mx-auto px-4 pt-6 pb-10 max-w-5xl">
  <div class="mb-8">
    <h1 class="text-3xl font-extrabold text-neutral-100 tracking-tight">
      {m.dashboard_title()} 🍽️
    </h1>
    <p class="text-neutral-500 text-xs mt-1 font-medium italic">
      {m.dashboard_subtitle()}
    </p>
  </div>

  <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 mb-8">
    {#each stats as stat}
      <StatsCard {...stat} />
    {/each}
  </div>

  <MerchantDashboard dishes={dishStore.all} />
</main>
