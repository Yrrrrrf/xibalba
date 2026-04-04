<script lang="ts">
  import type { Zone } from '@sdk/core';
  // @ts-ignore
  import * as m from '../../paraglide/messages.js';

  interface Props {
    zones: Zone[];
    selectedZoneId: string;
    onchange?: (id: string) => void;
  }

  let { zones, selectedZoneId, onchange }: Props = $props();

  const selected = $derived(zones.find((z) => z.id === selectedZoneId));
</script>

<div class="card bg-neutral-900/60 backdrop-blur-xl shadow-xl border border-white/10 mb-4">
  <div class="card-body p-4">
    <div class="flex items-center gap-2 mb-3">
      <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-orange-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
      </svg>
      <h2 class="font-bold text-base text-neutral-100">{m.zone_your_location()}</h2>
    </div>

    <div class="flex flex-col sm:flex-row gap-3 items-start sm:items-center">
      <select
        class="select bg-black/20 border-white/10 text-white focus:border-orange-500/50 w-full sm:max-w-xs"
        value={selectedZoneId}
        onchange={(e) => onchange?.(e.currentTarget.value)}
      >
        {#each zones as zone}
          <option value={zone.id} class="bg-neutral-900 text-white">{zone.name}</option>
        {/each}
      </select>

      {#if selected}
        <div class="badge bg-orange-500/10 text-orange-400 border border-orange-500/20 gap-1 py-3 px-3">
          <span class="text-xs font-bold uppercase tracking-tighter">{selected.name}</span>
        </div>
      {/if}
    </div>

    {#if selected}
      <p class="text-[10px] text-neutral-500 mt-2 flex items-center gap-1 font-bold uppercase tracking-widest">
        <span>📡</span> {m.zone_gps_simulated()} <strong>{selected.name}</strong>
      </p>
    {/if}
  </div>
</div>
