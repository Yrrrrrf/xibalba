<script lang="ts">
  import { goto } from "$app/navigation";
  import { createAuthStore } from "@sdk/state";
  import { m, ICONS } from "@sdk/ui";

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
      icon: ICONS.tourist,
      label: m.login_tourist(),
      sublabel: m.login_tourist_sub(),
      gradient: "from-primary to-primary/80",
      glow: "shadow-primary/40",
      border: "border-primary/20",
    },
    {
      id: "business" as const,
      icon: ICONS.nav_menu,
      label: m.login_business(),
      sublabel: m.login_business_sub(),
      gradient: "from-warning to-warning/80",
      glow: "shadow-warning/40",
      border: "border-warning/20",
    },
    {
      id: "admin" as const,
      icon: ICONS.admin,
      label: m.login_admin(),
      sublabel: m.login_admin_sub(),
      gradient: "from-error to-error/80",
      glow: "shadow-error/40",
      border: "border-error/20",
    },
  ]);
</script>

<svelte:head>
  <title>{m.login_title()} — {m.nav_login()}</title>
</svelte:head>

<div
  class="min-h-screen flex flex-col items-center justify-center p-5 bg-base-100"
>
  <!-- Brand hero -->
  <div class="text-center mb-10 space-y-3">
    <div
      class="relative inline-flex items-center justify-center w-24 h-24 mb-2"
    >
      <div
        class="absolute inset-0 rounded-full bg-gradient-to-br from-primary to-primary/50 opacity-20 blur-xl animate-pulse"
      ></div>
      <div class="text-6xl text-primary">
        <ICONS.brand size={64} />
      </div>
    </div>

    <h1
      class="text-5xl font-extrabold tracking-tight bg-gradient-to-br from-primary via-primary/80 to-primary/60 bg-clip-text text-transparent"
    >
      {m.login_title()}
    </h1>
    <p class="text-base-content/50 text-sm max-w-xs mx-auto leading-relaxed">
      {m.login_subtitle()}
    </p>
  </div>

  <!-- Role selector -->
  <div class="w-full max-w-sm space-y-3">
    <p
      class="text-center text-xs font-bold text-base-content/40 uppercase tracking-widest mb-5"
    >
      {m.login_select_role()}
    </p>

    {#each roles as rol}
      <button
        onclick={() => entrar(rol.id)}
        disabled={loading !== null}
        class="group w-full flex items-center gap-4 p-4 rounded-3xl
               bg-base-200/60 backdrop-blur-xl
               border {rol.border}
               shadow-xl
               hover:shadow-2xl
               hover:-translate-y-1
               active:scale-[0.98]
               transition-all duration-300 ease-out
               text-left cursor-pointer"
      >
        <div
          class="w-14 h-14 rounded-2xl flex-shrink-0 flex items-center justify-center
                    bg-gradient-to-br {rol.gradient} shadow-md {rol.glow}
                    group-hover:scale-110 group-hover:rotate-3
                    transition-transform duration-300 text-primary-content"
        >
          <rol.icon size={32} />
        </div>

        <div class="flex-1 min-w-0">
          <p class="font-bold text-base-content text-sm">{rol.label}</p>
          <p class="text-base-content/50 text-xs truncate mt-0.5">{rol.sublabel}</p>
        </div>

        <div
          class="flex-shrink-0 text-base-content/30 group-hover:text-primary group-hover:translate-x-1 transition-all duration-300"
        >
          {#if loading === rol.id}
            <span class="loading loading-spinner loading-sm"></span>
          {:else}
            <ICONS.chevron_right size={20} />
          {/if}
        </div>
      </button>
    {/each}
  </div>

  <p
    class="mt-10 text-[10px] text-base-content/50 text-center max-w-xs leading-relaxed uppercase font-bold tracking-widest"
  >
    {m.login_demo_note()}
  </p>
</div>
