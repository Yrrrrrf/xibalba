<script lang="ts">
  import { 
    X, 
    Pencil, 
    User, 
    MapPin, 
    House, 
    Phone, 
    Mail, 
    Clock, 
    MessageSquare, 
    Save,
    ChefHat
  } from 'lucide-svelte';
  import type { BusinessProfile } from "@sdk/core";
  import { GlassCard } from "../primitives/mod.ts";
  import * as m from "../../../src/i18n/paraglide/messages.js";

  interface Props {
    profile: BusinessProfile;
    onsave?: (updated: BusinessProfile) => void;
  }

  let { profile, onsave }: Props = $props();
  let editing = $state(false);
  let localProfile = $state<BusinessProfile>(undefined!);

  $effect.pre(() => {
    if (!editing) {
      localProfile = { ...profile };
    }
  });

  function handleSave() {
    editing = false;
    onsave?.(localProfile);
  }
</script>

<GlassCard class="p-6">
  <div
    class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3 mb-4"
  >
    <div class="flex items-center gap-3">
      <div class="avatar placeholder">
        <div class="bg-primary text-primary-content w-14 rounded-full flex items-center justify-center">
          <ChefHat size={28} />
        </div>
      </div>
      <div>
        <h2 class="card-title text-xl text-neutral-100">{localProfile.name}</h2>
        <p class="text-sm text-neutral-400">{localProfile.category}</p>
      </div>
    </div>
    <button
      onclick={() => {
        editing = !editing;
      }}
      class="group flex items-center gap-2 px-4 py-2 rounded-xl text-xs font-bold transition-all duration-300 {editing
        ? 'bg-rose-500/10 text-rose-400 border border-rose-500/20'
        : 'bg-orange-500/10 text-orange-400 border border-orange-500/20 hover:bg-orange-500/20'}"
    >
      {#if editing}
        <X size={14} /> {m.editor_cancel()}
      {:else}
        <Pencil size={14} /> {m.editor_edit()}
      {/if}
    </button>
  </div>

  <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
    {#each [
      { label: m.biz_owner(), field: "owner_name" as const, icon: User }, 
      { label: m.biz_zone(), field: "zone" as const, icon: MapPin }, 
      { label: m.biz_address(), field: "address" as const, icon: House }, 
      { label: m.biz_phone(), field: "phone" as const, icon: Phone }, 
      { label: m.biz_email(), field: "email" as const, icon: Mail }, 
      { label: m.biz_hours(), field: "hours" as const, icon: Clock }
    ] as item}
      <div class="form-control">
        <label class="label py-1" for="field-{item.field}">
          <span
            class="label-text text-[10px] font-bold uppercase tracking-wider text-neutral-500 flex items-center gap-1.5"
          >
            <item.icon size={12} class="text-neutral-600" />
            {item.label}
          </span>
        </label>
        {#if editing}
          <input
            id="field-{item.field}"
            class="input bg-black/20 border-white/10 text-white input-sm focus:border-orange-500/50"
            bind:value={localProfile[item.field]}
          />
        {:else}
          <p
            class="text-sm py-2 px-3 bg-white/5 rounded-xl border border-white/5 text-neutral-200"
          >
            {localProfile[item.field]}
          </p>
        {/if}
      </div>
    {/each}
  </div>

  <div class="form-control mt-2">
    <label class="label py-1" for="biz-desc">
      <span
        class="label-text text-[10px] font-bold uppercase tracking-wider text-neutral-500 flex items-center gap-1.5"
        >
        <MessageSquare size={12} class="text-neutral-600" />
        {m.biz_description()}
      </span>
    </label>
    {#if editing}
      <textarea
        id="biz-desc"
        class="textarea bg-black/20 border-white/10 text-white textarea-sm focus:border-orange-500/50"
        bind:value={localProfile.description}
        rows="3"
      ></textarea>
    {:else}
      <p
        class="text-sm py-2.5 px-3 bg-white/5 rounded-xl border border-white/5 text-neutral-200 leading-relaxed"
      >
        {localProfile.description}
      </p>
    {/if}
  </div>

  {#if editing}
    <div class="card-actions justify-end mt-4">
      <button onclick={handleSave} class="btn btn-primary gap-2">
        <Save size={18} /> {m.editor_save()}
      </button>
    </div>
  {/if}
</GlassCard>
