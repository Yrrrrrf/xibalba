<script lang="ts">
  import type { Dish } from '@sdk/core';
  import { PriceTag, StatusBadge, EmptyState, GlassCard } from '../primitives/mod.ts';
  // @ts-ignore
  import * as m from '../../paraglide/messages.js';

  interface Props {
    dishes?: Dish[];
  }

  let { dishes = [] }: Props = $props();

  const totalSales = $derived(dishes.reduce((acc, p) => acc + p.sales_count, 0));
  const availableCount = $derived(dishes.filter((p) => p.available).length);
</script>

<div class="space-y-4">
  <!-- Resumen -->
  <div class="stats stats-horizontal shadow-xl w-full bg-neutral-900/60 backdrop-blur-xl border border-white/10">
    <div class="stat place-items-center">
      <div class="stat-title text-[10px] uppercase font-bold tracking-widest text-neutral-500">{m.merchant_total_dishes()}</div>
      <div class="stat-value text-orange-400 text-2xl">{dishes.length}</div>
    </div>
    <div class="stat place-items-center border-l border-white/5">
      <div class="stat-title text-[10px] uppercase font-bold tracking-widest text-neutral-500">{m.merchant_available()}</div>
      <div class="stat-value text-emerald-400 text-2xl">{availableCount}</div>
    </div>
    <div class="stat place-items-center border-l border-white/5">
      <div class="stat-title text-[10px] uppercase font-bold tracking-widest text-neutral-500">{m.merchant_total_sales()}</div>
      <div class="stat-value text-cyan-400 text-2xl">{totalSales}</div>
    </div>
  </div>

  <!-- Grid de productos -->
  {#if dishes.length === 0}
    <EmptyState
      title={m.merchant_no_dishes()}
      subtitle={m.merchant_no_dishes_sub()}
    />
  {:else}
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
      {#each dishes as dish}
        <GlassCard class="bg-neutral-900/40 hover:shadow-orange-500/10 transition-all duration-300 hover:-translate-y-1">
          <div class="p-4">
            <div class="flex items-start justify-between gap-2">
              <h3 class="font-bold text-neutral-100 text-sm leading-tight">{dish.name}</h3>
              <StatusBadge status={dish.available ? 'active_food' : 'hidden_food'} />
            </div>
            <p class="text-xs text-neutral-400">{dish.category}</p>

            <div class="flex items-center justify-between mt-3">
              <PriceTag amount={dish.price} size="sm" />
              <span class="text-[10px] text-neutral-500 flex items-center gap-1 font-bold uppercase">
                📦 {dish.sales_count} {m.merchant_sales_label()}
              </span>
            </div>

            <div class="card-actions justify-end mt-2 flex gap-2">
              <button class="btn btn-xs btn-outline btn-warning border-orange-500/20 text-orange-400 hover:bg-orange-500/10">{m.merchant_edit()}</button>
              <button class="btn btn-xs btn-outline btn-error border-rose-500/20 text-rose-400 hover:bg-rose-500/10">{m.merchant_pause()}</button>
            </div>
          </div>
        </GlassCard>
      {/each}
    </div>
  {/if}
</div>
