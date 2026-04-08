<script lang="ts">
  import { goto } from "$app/navigation";
  import { authStore, type UserRole } from "@sdk/state";
  import { m } from "@sdk/ui";

  const auth = authStore;
  let loadingRole = $state<UserRole>(null);

  async function loginAs(role: UserRole) {
    loadingRole = role;
    
    // Simular un breve retardo para feedback visual
    await new Promise(r => setTimeout(r, 600));
    
    auth.setRole(role);
    
    if (role === "tourist") {
      goto("/discover");
    } else if (role === "admin") {
      goto("/admin");
    } else if (role === "business") {
      goto("/dashboard");
    }
    
    loadingRole = null;
  }
</script>

<svelte:head>
  <title>Acceso Rápido — {m.app_name()}</title>
</svelte:head>

<div class="text-center -mt-8 mb-10">
  <h1 class="text-4xl font-black mb-3 tracking-tight text-base-content drop-shadow-sm">Panel de Acceso</h1>
  <p class="text-base-content/60 text-sm font-medium">Selecciona tu rol para ingresar a la plataforma.</p>
</div>

<div class="grid grid-cols-1 gap-4 w-full max-w-md mx-auto">
  <!-- TURISTA -->
  <button 
    onclick={() => loginAs("tourist")}
    class="group relative overflow-hidden rounded-2xl border-2 border-primary/10 bg-base-200/40 p-6 text-left transition-all hover:border-primary hover:bg-primary/5 hover:shadow-xl hover:shadow-primary/10 active:scale-[0.98]"
    disabled={!!loadingRole}
  >
    <div class="flex items-center gap-5">
      <div class="flex h-14 w-14 items-center justify-center rounded-xl bg-primary/10 text-primary transition-transform group-hover:scale-110 group-hover:bg-primary group-hover:text-primary-content">
        <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
        </svg>
      </div>
      <div>
        <h3 class="text-xl font-bold text-base-content">Turista</h3>
        <p class="text-sm text-base-content/60">Explora destinos y experiencias</p>
      </div>
      {#if loadingRole === 'tourist'}
        <div class="ml-auto"><span class="loading loading-spinner loading-md text-primary"></span></div>
      {/if}
    </div>
  </button>

  <!-- COMERCIANTE -->
  <button 
    onclick={() => loginAs("business")}
    class="group relative overflow-hidden rounded-2xl border-2 border-secondary/10 bg-base-200/40 p-6 text-left transition-all hover:border-secondary hover:bg-secondary/5 hover:shadow-xl hover:shadow-secondary/10 active:scale-[0.98]"
    disabled={!!loadingRole}
  >
    <div class="flex items-center gap-5">
      <div class="flex h-14 w-14 items-center justify-center rounded-xl bg-secondary/10 text-secondary transition-transform group-hover:scale-110 group-hover:bg-secondary group-hover:text-secondary-content">
        <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
        </svg>
      </div>
      <div>
        <h3 class="text-xl font-bold text-base-content">Comerciante</h3>
        <p class="text-sm text-base-content/60">Gestiona tu negocio y ventas</p>
      </div>
      {#if loadingRole === 'business'}
        <div class="ml-auto"><span class="loading loading-spinner loading-md text-secondary"></span></div>
      {/if}
    </div>
  </button>

  <!-- ADMIN -->
  <button 
    onclick={() => loginAs("admin")}
    class="group relative overflow-hidden rounded-2xl border-2 border-accent/10 bg-base-200/40 p-6 text-left transition-all hover:border-accent hover:bg-accent/5 hover:shadow-xl hover:shadow-accent/10 active:scale-[0.98]"
    disabled={!!loadingRole}
  >
    <div class="flex items-center gap-5">
      <div class="flex h-14 w-14 items-center justify-center rounded-xl bg-accent/10 text-accent transition-transform group-hover:scale-110 group-hover:bg-accent group-hover:text-accent-content">
        <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
        </svg>
      </div>
      <div>
        <h3 class="text-xl font-bold text-base-content">Administrador</h3>
        <p class="text-sm text-base-content/60">Control total del ecosistema</p>
      </div>
      {#if loadingRole === 'admin'}
        <div class="ml-auto"><span class="loading loading-spinner loading-md text-accent"></span></div>
      {/if}
    </div>
  </button>
</div>

<div class="mt-12 text-center opacity-50 hover:opacity-100 transition-opacity">
  <p class="text-xs font-semibold uppercase tracking-widest text-base-content">
    Xibalbá • Plataforma de Exploración
  </p>
</div>
