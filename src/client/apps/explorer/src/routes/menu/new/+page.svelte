<script lang="ts">
  import { goto } from "$app/navigation";
  import { DishForm, GlassCard, ICONS } from "@sdk/ui";
  import type { DishFormData } from "@sdk/core";
  import { m } from "@sdk/ui";

  function handleSubmit(data: DishFormData) {
    console.log("New dish data:", data);
    // In a real app, call store.addDish(data)
    goto("/menu");
  }
</script>

<svelte:head>
  <title>{m.app_name()} — {m.menu_new_title()}</title>
</svelte:head>

<main class="container mx-auto px-4 pt-6 pb-10 max-w-2xl">
  <div class="mb-8">
    <a
      href="/menu"
      class="text-xs font-bold text-base-content/50 hover:text-primary flex items-center gap-1 mb-2 transition-colors"
    >
      <ICONS.chevron_left size={14} strokeWidth={3} />
      {m.nav_menu()}
    </a>
    <h1 class="text-3xl font-extrabold text-base-content tracking-tight flex items-center gap-3">
      {m.menu_new_title()} <ICONS.add size={32} class="text-primary" />
    </h1>
    <p class="text-base-content/50 text-xs mt-1 font-medium italic">
      {m.menu_subtitle()}
    </p>
  </div>

  <GlassCard class="p-6">
    <DishForm onsubmit={handleSubmit} oncancel={() => goto("/menu")} />
  </GlassCard>
</main>
