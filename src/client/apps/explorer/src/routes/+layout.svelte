<script lang="ts">
  import "./layout.css";
  // @ts-ignore
  import { createAuthStore } from "@sdk/state";
  import { page } from "$app/stores";
  import { onMount } from "svelte";
  import { goto } from "$app/navigation";

  let { children } = $props();
  const auth = createAuthStore();

  // Simple protection: if not logged in and not on login page, redirect to login
  onMount(() => {
    if (!auth.role && $page.url.pathname !== '/login') {
      goto('/login');
    }
  });

  const navItems = $derived(
    auth.role === 'tourist'
      ? [
          { href: '/discover', label: 'Explorar' },
          { href: '/saved', label: 'Guardados' },
        ]
      : auth.role === 'business'
      ? [
          { href: '/dashboard', label: 'Dashboard' },
          { href: '/profile', label: 'Perfil' },
          { href: '/menu', label: 'Menú' },
        ]
      : []
  );
</script>

<div class="min-h-screen bg-neutral-950 text-neutral-100 flex flex-col">
  {#if auth.role}
    <nav class="sticky top-0 z-[100] bg-neutral-900/80 backdrop-blur-xl border-b border-white/10 px-4 py-3">
      <div class="container mx-auto flex items-center justify-between">
        <a href="/" class="text-xl font-black bg-gradient-to-r from-orange-500 to-amber-500 bg-clip-text text-transparent">
          Xibalbá
        </a>

        <div class="flex items-center gap-6">
          {#each navItems as item}
            <a
              href={item.href}
              class="text-sm font-bold uppercase tracking-widest hover:text-orange-500 transition-colors
                     {$page.url.pathname === item.href ? 'text-orange-500' : 'text-neutral-400'}"
            >
              {item.label}
            </a>
          {/each}

          <button
            onclick={() => { auth.logout(); goto('/login'); }}
            class="text-[10px] font-bold uppercase tracking-tighter px-3 py-1.5 rounded-xl bg-white/5 border border-white/10 hover:bg-rose-500/10 hover:text-rose-400 transition-all"
          >
            Salir
          </button>
        </div>
      </div>
    </nav>
  {/if}

  <div class="flex-1 flex flex-col">
    {@render children()}
  </div>
</div>
