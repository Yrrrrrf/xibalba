<script lang="ts">
  import type { BusinessSummary } from "@sdk/core";
  import { StatusBadge, GlassCard } from "../primitives/mod.ts";
  import * as m from "../../../src/i18n/paraglide/messages.js";

  interface Props {
    data?: BusinessSummary[];
    onselect?: (id: string) => void;
  }

  let { data = [], onselect }: Props = $props();

  let search = $state("");
  let filterZona = $state("");

  const zonas = $derived([...new Set(data.map((d) => d.zone))]);

  const filtered = $derived(
    data.filter((c) => {
      const matchSearch =
        !search ||
        c.name.toLowerCase().includes(search.toLowerCase()) ||
        c.owner.toLowerCase().includes(search.toLowerCase());
      const matchZona = !filterZona || c.zone === filterZona;
      return matchSearch && matchZona;
    }),
  );
</script>

<div class="space-y-4">
  <!-- Filtros -->
  <div class="flex flex-col sm:flex-row gap-3">
    <input
      type="text"
      placeholder="🔍 {m.table_search()}"
      class="input bg-black/20 border-white/10 text-white placeholder:text-neutral-600 focus:border-orange-500/50 input-sm flex-1"
      bind:value={search}
    />
    <select
      class="select bg-black/20 border-white/10 text-white select-sm focus:border-orange-500/50"
      bind:value={filterZona}
    >
      <option value="" class="bg-neutral-900">{m.table_all_zones()}</option>
      {#each zonas as zona}
        <option value={zona} class="bg-neutral-900">{zona}</option>
      {/each}
    </select>
    <div
      class="badge bg-white/5 border border-white/10 text-neutral-400 self-center px-3 py-3 text-[10px] font-bold uppercase"
    >
      {filtered.length}
      {m.table_results()}
    </div>
  </div>

  <!-- Tabla -->
  <div
    class="overflow-x-auto rounded-xl border border-white/10 shadow-2xl bg-neutral-900/40 backdrop-blur-md"
  >
    <table class="table table-zebra table-sm w-full text-neutral-200">
      <thead class="bg-white/5 text-neutral-400">
        <tr>
          <th class="text-xs">#</th>
          <th class="text-xs">{m.table_business()}</th>
          <th class="text-xs hidden md:table-cell">{m.table_owner()}</th>
          <th class="text-xs hidden sm:table-cell">{m.table_zone()}</th>
          <th class="text-xs">{m.table_category()}</th>
          <th class="text-xs hidden lg:table-cell">{m.table_dishes()}</th>
          <th class="text-xs">{m.table_sales()}</th>
          <th class="text-xs">{m.table_status()}</th>
          <th class="text-xs">{m.table_action()}</th>
        </tr>
      </thead>
      <tbody>
        {#each filtered as c}
          <tr
            class="hover:bg-white/5 border-b border-white/5 last:border-0 transition-colors"
          >
            <td class="text-[10px] font-bold text-neutral-600">{c.id}</td>
            <td>
              <div class="font-bold text-sm text-neutral-100">{c.name}</div>
            </td>
            <td class="hidden md:table-cell text-sm text-neutral-400"
              >{c.owner}</td
            >
            <td class="hidden sm:table-cell">
              <span
                class="badge bg-white/5 border border-white/10 text-neutral-400 badge-sm text-[9px] font-bold uppercase"
                >{c.zone}</span
              >
            </td>
            <td class="text-xs text-neutral-400 italic">{c.category}</td>
            <td class="hidden lg:table-cell text-center font-bold text-white"
              >{c.dish_count}</td
            >
            <td class="font-extrabold text-orange-400 text-center">{c.sales}</td
            >
            <td>
              <StatusBadge status={c.status} />
            </td>
            <td>
              <div class="flex gap-1">
                <button
                  onclick={() => onselect?.(c.id)}
                  class="btn btn-xs btn-ghost hover:bg-orange-500/10 text-orange-400"
                  aria-label="Ver"
                >
                  👁️
                </button>
                <button
                  class="btn btn-xs btn-ghost hover:bg-rose-500/10 text-rose-400"
                  aria-label="Suspender">🚫</button
                >
              </div>
            </td>
          </tr>
        {/each}

        {#if filtered.length === 0}
          <tr>
            <td
              colspan="9"
              class="text-center py-12 text-neutral-500 font-bold uppercase tracking-widest text-xs"
            >
              {m.table_no_results()}
            </td>
          </tr>
        {/if}
      </tbody>
    </table>
  </div>
</div>
