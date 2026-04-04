<script lang="ts">
  import "./layout.css";
  import { createAuthStore } from "@sdk/state";
  import { page } from "$app/stores";
  import { onMount } from "svelte";
  import { goto } from "$app/navigation";
  import { m, ICONS } from "@sdk/ui";

  let { children } = $props();
  const auth = createAuthStore();

  onMount(() => {
    if (!auth.role && $page.url.pathname !== "/login") {
      goto("/login");
    }
  });

  const touristNav = $derived([
    { href: "/discover", label: m.nav_discover(), icon: ICONS.nav_discover },
    { href: "/saved", label: m.nav_saved(), icon: ICONS.nav_saved },
  ]);

  const businessNav = $derived([
    { href: "/dashboard", label: m.nav_dashboard(), icon: ICONS.nav_dashboard },
    { href: "/menu", label: m.nav_menu(), icon: ICONS.nav_menu },
    { href: "/profile", label: m.nav_profile(), icon: ICONS.nav_profile },
    { href: "/discover", label: m.nav_discover(), icon: ICONS.tourist }, // View as tourist
  ]);

  const navItems = $derived(
    auth.role === "tourist"
      ? touristNav
      : auth.role === "business"
        ? businessNav
        : [],
  );
</script>

<div
  class="min-h-screen bg-neutral-950 text-neutral-100 flex flex-col selection:bg-orange-500/30"
>
  {#if auth.role && $page.url.pathname !== "/login"}
    <!-- Top Brand Bar -->
    <header
      class="sticky top-0 z-[100] bg-neutral-950/80 backdrop-blur-xl border-b border-white/5 px-4 py-3"
    >
      <div class="container mx-auto flex items-center justify-between">
        <div class="flex items-center gap-2">
          <div
            class="w-8 h-8 rounded-lg bg-gradient-to-br from-orange-500 to-amber-600 flex items-center justify-center shadow-lg shadow-orange-900/20 text-white"
          >
            <ICONS.brand size={18} />
          </div>
          <span
            class="text-xl font-black tracking-tighter bg-gradient-to-r from-white to-neutral-400 bg-clip-text text-transparent"
          >
            {m.app_name()}
          </span>
        </div>

        <button
          onclick={() => {
            auth.logout();
            goto("/login");
          }}
          class="text-[10px] font-bold uppercase tracking-widest px-3 py-1.5 rounded-xl bg-white/5 border border-white/10 hover:bg-rose-500/10 hover:text-rose-400 transition-all duration-300"
        >
          {m.nav_logout()}
        </button>
      </div>
    </header>

    <!-- Main Content Area -->
    <div class="flex-1 flex flex-col pb-20 md:pb-0">
      {@render children()}
    </div>

    <!-- Bottom Navigation (Mobile) -->
    <nav
      class="fixed bottom-0 inset-x-0 z-[100] md:hidden bg-neutral-900/90 backdrop-blur-2xl border-t border-white/5 px-2 pb-safe-area-inset-bottom"
    >
      <div class="flex items-center justify-around h-16">
        {#each navItems as item}
          <a
            href={item.href}
            class="flex flex-col items-center justify-center gap-1 flex-1 transition-all duration-300
                   {$page.url.pathname === item.href
              ? 'text-orange-500'
              : 'text-neutral-500 hover:text-neutral-300'}"
          >
            <item.icon size={20} />
            <span class="text-[9px] font-bold uppercase tracking-wider"
              >{item.label}</span
            >
            {#if $page.url.pathname === item.href}
              <div
                class="absolute -bottom-1 w-1 h-1 rounded-full bg-orange-500 shadow-[0_0_8px_rgba(249,115,22,0.8)]"
              ></div>
            {/if}
          </a>
        {/each}
      </div>
    </nav>

    <!-- Sidebar Navigation (Desktop) -->
    <!-- (Optional for hackathon, but can be added if needed) -->
  {:else}
    <div class="flex-1 flex flex-col">
      {@render children()}
    </div>
  {/if}
</div>

<style>
  :global(body) {
    background-color: #0a0a0a;
    -webkit-tap-highlight-color: transparent;
  }
</style>
