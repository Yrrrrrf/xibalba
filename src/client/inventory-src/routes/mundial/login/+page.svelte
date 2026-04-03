<script lang="ts">
  import { goto } from "$app/navigation";

  let loading = $state<string | null>(null);

  async function entrar(rol: "cliente" | "comerciante" | "admin") {
    loading = rol;
    await new Promise((r) => setTimeout(r, 600));
    goto(`/mundial/${rol}`);
  }

  const roles = [
    {
      id: "cliente" as const,
      emoji: "🧳",
      label: "Entrar como Turista",
      sublabel: "Explora la mejor gastronomía del Mundial",
      gradient: "from-orange-500 to-amber-600",
      glow: "shadow-orange-900/40",
      border: "border-orange-500/20",
      bg: "from-orange-950/20 to-amber-950/20",
    },
    {
      id: "comerciante" as const,
      emoji: "🍽️",
      label: "Entrar como Comerciante",
      sublabel: "Gestiona tu negocio y tus platillos",
      gradient: "from-amber-600 to-yellow-600",
      glow: "shadow-amber-900/40",
      border: "border-amber-500/20",
      bg: "from-amber-950/20 to-yellow-950/20",
    },
    {
      id: "admin" as const,
      emoji: "🛡️",
      label: "Entrar como Administrador",
      sublabel: "Panel de control y analíticas globales",
      gradient: "from-rose-600 to-pink-600",
      glow: "shadow-rose-900/40",
      border: "border-rose-500/20",
      bg: "from-rose-950/20 to-pink-950/20",
    },
  ] as const;
</script>

<svelte:head>
  <title>Mundial Food — Acceso</title>
  <meta
    name="description"
    content="Plataforma gastronómica para el Mundial. Turistas, comerciantes y administradores."
  />
</svelte:head>

<div class="flex-1 flex flex-col items-center justify-center p-5 pt-24 pb-10">
  <!-- Brand hero -->
  <div class="text-center mb-10 space-y-3">
    <div
      class="relative inline-flex items-center justify-center w-24 h-24 mb-2"
    >
      <!-- Glow ring -->
      <div
        class="absolute inset-0 rounded-full bg-gradient-to-br from-orange-400 to-amber-500
                  opacity-20 blur-xl animate-pulse"
      ></div>
      <!-- Glass circle -->
      <div
        class="
                  flex items-center justify-center"
      >
        <span class="text-6xl">⚽</span>
      </div>
    </div>

    <h1
      class="text-5xl font-extrabold tracking-tight
               bg-gradient-to-br from-orange-600 via-amber-500 to-orange-700
               bg-clip-text text-transparent"
    >
      Xibalbá
    </h1>
    <p class="text-stone-500 text-sm max-w-xs mx-auto leading-relaxed">
      Descubre la gastronomía más auténtica durante el Mundial · Qatar 2026
    </p>
    <div class="flex justify-center gap-2 flex-wrap pt-1">
      {#each ["🏆 Qatar 2026", "🌍 32 selecciones", "🍴 +500 platillos"] as badge}
        <span
          class="px-3 py-1 rounded-full text-[10px] font-bold uppercase tracking-wider
                     bg-white/5 backdrop-blur-md border border-white/10
                     text-neutral-400 shadow-sm"
        >
          {badge}
        </span>
      {/each}
    </div>
  </div>

  <!-- Role selector -->
  <div class="w-full max-w-sm space-y-3">
    <p
      class="text-center text-xs font-bold text-stone-400 uppercase tracking-widest mb-5"
    >
      Selecciona tu rol
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
        <!-- Emoji icon with gradient bg -->
        <div
          class="w-14 h-14 rounded-2xl flex-shrink-0 flex items-center justify-center
                    bg-gradient-to-br {rol.gradient}
                    shadow-md {rol.glow}
                    group-hover:scale-110 group-hover:rotate-3
                    transition-transform duration-300 text-3xl"
        >
          {rol.emoji}
        </div>

        <!-- Text -->
        <div class="flex-1 min-w-0">
          <p class="font-bold text-neutral-100 text-sm">{rol.label}</p>
          <p class="text-neutral-500 text-xs truncate mt-0.5">{rol.sublabel}</p>
        </div>

        <!-- Arrow / Spinner -->
        <div
          class="flex-shrink-0 text-stone-300 group-hover:text-orange-500
                    group-hover:translate-x-1 transition-all duration-300"
        >
          {#if loading === rol.id}
            <svg class="h-5 w-5 animate-spin" viewBox="0 0 24 24" fill="none">
              <circle
                class="opacity-25"
                cx="12"
                cy="12"
                r="10"
                stroke="currentColor"
                stroke-width="4"
              />
              <path
                class="opacity-75"
                fill="currentColor"
                d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"
              />
            </svg>
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

  <p class="mt-10 text-xs text-stone-300 text-center">
    Demo experimental · Datos ficticios · Solo para prototipo
  </p>
</div>
