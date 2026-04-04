<script lang="ts">
  import { goto } from "$app/navigation";
  import { DishForm, GlassCard } from "@sdk/ui";
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
      class="text-xs font-bold text-neutral-500 hover:text-orange-500 flex items-center gap-1 mb-2"
    >
      <svg
        class="h-3 w-3"
        fill="none"
        viewBox="0 0 24 24"
        stroke="currentColor"
      >
        <path
          stroke-linecap="round"
          stroke-linejoin="round"
          stroke-width="3"
          d="M15 19l-7-7 7-7"
        />
      </svg>
      {m.nav_menu()}
    </a>
    <h1 class="text-3xl font-extrabold text-neutral-100 tracking-tight">
      {m.menu_new_title()} ➕
    </h1>
    <p class="text-neutral-500 text-xs mt-1 font-medium italic">
      {m.menu_subtitle()}
    </p>
  </div>

  <GlassCard class="p-6">
    <DishForm onsubmit={handleSubmit} oncancel={() => goto("/menu")} />
  </GlassCard>
</main>
