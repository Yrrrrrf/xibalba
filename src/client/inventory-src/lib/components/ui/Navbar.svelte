<script lang="ts">
  import { goto } from "$app/navigation";
  import { ThemeSelector } from "rune-lab";

  interface Props {
    role?: "cliente" | "comerciante" | "admin" | null;
  }

  let { role = null }: Props = $props();

  const roleConfig = {
    cliente: { label: "🧳 Turista", cls: "bg-emerald-500/90 text-white" },
    comerciante: { label: "🍽️ Comerciante", cls: "bg-amber-500/90 text-white" },
    admin: { label: "🛡️ Admin", cls: "bg-rose-500/90 text-white" },
  };

  function logout() {
    goto("/mundial/login");
  }
</script>

<nav
  class="fixed top-0 w-full z-50 h-14 flex items-center justify-between px-4 sm:px-6 bg-black/50 backdrop-blur-md border-b border-white/10 text-white shadow-lg"
>
  <!-- Brand -->
  <a href="/mundial/login" class="flex items-center gap-2 group">
    <span
      class="text-2xl group-hover:rotate-12 transition-transform duration-300 inline-block"
      >⚽</span
    >
    <span
      class="font-extrabold text-base bg-gradient-to-r from-orange-600 to-amber-500
                 bg-clip-text text-transparent hidden sm:block tracking-tight"
    >
      Mundial Food
    </span>

    <ThemeSelector />
  </a>

  <!-- Role pill -->
  {#if role}
    <span
      class="px-3 py-1 rounded-full text-xs font-bold backdrop-blur-sm
                 {roleConfig[role].cls} shadow-sm"
    >
      {roleConfig[role].label}
    </span>
  {/if}

  <!-- Logout -->
  {#if role}
    <button
      onclick={logout}
      class="flex items-center gap-1.5 px-3 py-1.5 rounded-xl text-sm font-medium
             text-stone-500 hover:text-orange-600 hover:bg-orange-50/80
             transition-all duration-200"
      title="Cerrar sesión"
    >
      <svg
        xmlns="http://www.w3.org/2000/svg"
        class="h-4 w-4"
        fill="none"
        viewBox="0 0 24 24"
        stroke="currentColor"
      >
        <path
          stroke-linecap="round"
          stroke-linejoin="round"
          stroke-width="2"
          d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"
        />
      </svg>
      <span class="hidden sm:block">Salir</span>
    </button>
  {/if}
</nav>
