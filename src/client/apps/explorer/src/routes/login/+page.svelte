<script lang="ts">
  import { goto } from "$app/navigation";
  import { createAuthStore } from "@sdk/state";
  import * as m from "$lib/paraglide/messages.js";

  const auth = createAuthStore();
  let loading = $state<string | null>(null);

  async function entrar(role: "tourist" | "business" | "admin") {
    loading = role;
    await new Promise((r) => setTimeout(r, 600));
    auth.setRole(role);
    if (role === "tourist") {
      goto("/discover");
    } else if (role === "business") {
      goto("/dashboard");
    } else {
      goto("/dashboard"); // Admin for now
    }
  }

  const roles = $derived([
    {
      id: "tourist" as const,
      emoji: "🧳",
      label: m.login_tourist(),
      sublabel: m.login_tourist_sub(),
      gradient: "from-orange-500 to-amber-600",
      glow: "shadow-orange-900/40",
      border: "border-orange-500/20",
    },
    {
      id: "business" as const,
      emoji: "🍽️",
      label: m.login_business(),
      sublabel: m.login_business_sub(),
      gradient: "from-amber-600 to-yellow-600",
      glow: "shadow-amber-900/40",
      border: "border-amber-500/20",
    },
    {
      id: "admin" as const,
      emoji: "🛡️",
      label: m.login_admin(),
      sublabel: m.login_admin_sub(),
      gradient: "from-rose-600 to-pink-600",
      glow: "shadow-rose-900/40",
      border: "border-rose-500/20",
    },
  ]);
</script>

<svelte:head>
  <title>{m.login_title()} — {m.nav_login()}</title>
</svelte:head>

<div
  class="min-h-screen flex flex-col items-center justify-center p-5 bg-neutral-950"
>
  <!-- Brand hero -->
  <div class="text-center mb-10 space-y-3">
    <div
      class="relative inline-flex items-center justify-center w-24 h-24 mb-2"
    >
      <div
        class="absolute inset-0 rounded-full bg-gradient-to-br from-orange-400 to-amber-500 opacity-20 blur-xl animate-pulse"
      ></div>
      <span class="text-6xl">⚽</span>
    </div>

    <h1
      class="text-5xl font-extrabold tracking-tight bg-gradient-to-br from-orange-600 via-amber-500 to-orange-700 bg-clip-text text-transparent"
    >
      {m.login_title()}
    </h1>
    <p class="text-stone-500 text-sm max-w-xs mx-auto leading-relaxed">
      {m.login_subtitle()}
    </p>
  </div>

  <!-- Role selector -->
  <div class="w-full max-w-sm space-y-3">
    <p
      class="text-center text-xs font-bold text-stone-400 uppercase tracking-widest mb-5"
    >
      {m.login_select_role()}
    </p>

    {#each roles as rol}
      <button
        onclick={() => entrar(rol.id)}
        disabled={loading !== null}
        class="group w-full flex items-center gap-4 p-4 rounded-3xl
               bg-neutral-900/60 backdrop-blur-xl
               border {rol.border}
               shadow-[0_8px_32px_rgba(0,0,0,0.3)]
               hover:shadow-[0_16px_40px_rgba(0,0,0,0.5)]
               hover:-translate-y-1
               active:scale-[0.98]
               transition-all duration-300 ease-out
               text-left cursor-pointer"
      >
        <div
          class="w-14 h-14 rounded-2xl flex-shrink-0 flex items-center justify-center
                    bg-gradient-to-br {rol.gradient} shadow-md {rol.glow}
                    group-hover:scale-110 group-hover:rotate-3
                    transition-transform duration-300 text-3xl"
        >
          {rol.emoji}
        </div>

        <div class="flex-1 min-w-0">
          <p class="font-bold text-neutral-100 text-sm">{rol.label}</p>
          <p class="text-neutral-500 text-xs truncate mt-0.5">{rol.sublabel}</p>
        </div>

        <div
          class="flex-shrink-0 text-stone-300 group-hover:text-orange-500 group-hover:translate-x-1 transition-all duration-300"
        >
          {#if loading === rol.id}
            <span class="loading loading-spinner loading-sm"></span>
          {:else}
            <svg
              class="h-5 w-5"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M9 5l7 7-7 7"
              />
            </svg>
          {/if}
        </div>
      </button>
    {/each}
  </div>

  <p
    class="mt-10 text-[10px] text-stone-500 text-center max-w-xs leading-relaxed uppercase font-bold tracking-widest"
  >
    {m.login_demo_note()}
  </p>
</div>
