<script lang="ts">
  import { goto } from "$app/navigation";
  import { authStore, type UserRole } from "@sdk/state";
  import { m, ICONS, GlassCard } from "@sdk/ui";
  import { Shield, MapPin, Store, Globe, Apple, Circle } from "lucide-svelte";

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
  <title>Acceso — {m.app_name()}</title>
</svelte:head>

<div class="text-center mb-10">
  <h1 class="text-4xl font-black italic uppercase tracking-tighter text-transparent bg-clip-text bg-gradient-to-br from-base-content to-base-content/40">Panel de Acceso</h1>
  <p class="text-base-content/50 text-[10px] font-black uppercase tracking-widest mt-2 italic">Selecciona tu rol para ingresar</p>
</div>

<div class="grid grid-cols-1 gap-4 w-full">
  <!-- TURISTA -->
  <button 
    onclick={() => loginAs("tourist")}
    class="group w-full"
    disabled={!!loadingRole}
  >
    <GlassCard 
      class="p-6 text-left transition-all group-hover:-translate-y-1 group-hover:shadow-primary/10 {loadingRole === 'tourist' ? 'border-primary ring-2 ring-primary/20' : 'border-white/5'}"
      enable3D={true}
    >
      <div class="flex items-center gap-5">
        <div class="flex h-14 w-14 items-center justify-center rounded-2xl bg-primary/10 text-primary transition-all group-hover:bg-primary group-hover:text-primary-content shadow-inner">
          <MapPin size={28} />
        </div>
        <div class="flex-1">
          <h3 class="text-xl font-black italic uppercase tracking-tighter">Turista</h3>
          <p class="text-[10px] font-bold opacity-40 uppercase tracking-widest">Explora destinos y sabores</p>
        </div>
        {#if loadingRole === 'tourist'}
          <span class="loading loading-spinner loading-md text-primary"></span>
        {/if}
      </div>
    </GlassCard>
  </button>

  <!-- COMERCIANTE -->
  <button 
    onclick={() => loginAs("business")}
    class="group w-full"
    disabled={!!loadingRole}
  >
    <GlassCard 
      class="p-6 text-left transition-all group-hover:-translate-y-1 group-hover:shadow-secondary/10 {loadingRole === 'business' ? 'border-secondary ring-2 ring-secondary/20' : 'border-white/5'}"
      enable3D={true}
    >
      <div class="flex items-center gap-5">
        <div class="flex h-14 w-14 items-center justify-center rounded-2xl bg-secondary/10 text-secondary transition-all group-hover:bg-secondary group-hover:text-secondary-content shadow-inner">
          <Store size={28} />
        </div>
        <div class="flex-1">
          <h3 class="text-xl font-black italic uppercase tracking-tighter">Comerciante</h3>
          <p class="text-[10px] font-bold opacity-40 uppercase tracking-widest">Gestiona tu negocio</p>
        </div>
        {#if loadingRole === 'business'}
          <span class="loading loading-spinner loading-md text-secondary"></span>
        {/if}
      </div>
    </GlassCard>
  </button>

  <!-- ADMIN -->
  <button 
    onclick={() => loginAs("admin")}
    class="group w-full"
    disabled={!!loadingRole}
  >
    <GlassCard 
      class="p-6 text-left transition-all group-hover:-translate-y-1 group-hover:shadow-error/10 {loadingRole === 'admin' ? 'border-error ring-2 ring-error/20' : 'border-white/5'}"
      enable3D={true}
    >
      <div class="flex items-center gap-5">
        <div class="flex h-14 w-14 items-center justify-center rounded-2xl bg-error/10 text-error transition-all group-hover:bg-error group-hover:text-error-content shadow-inner">
          <Shield size={28} />
        </div>
        <div class="flex-1">
          <h3 class="text-xl font-black italic uppercase tracking-tighter">Administrador</h3>
          <p class="text-[10px] font-bold opacity-40 uppercase tracking-widest">Supervisión total</p>
        </div>
        {#if loadingRole === 'admin'}
          <span class="loading loading-spinner loading-md text-error"></span>
        {/if}
      </div>
    </GlassCard>
  </button>
</div>

<!-- 3.12.2 — OAuth Placeholder Buttons -->
<div class="mt-10 space-y-6">
   <div class="divider text-[9px] font-black uppercase tracking-[0.3em] opacity-20 italic">o continúa con</div>
   
   <div class="grid grid-cols-3 gap-4">
      <button class="btn btn-outline border-white/5 bg-white/5 h-14 rounded-2xl btn-disabled opacity-30 grayscale">
         <Globe size={20} />
      </button>
      <button class="btn btn-outline border-white/5 bg-white/5 h-14 rounded-2xl btn-disabled opacity-30 grayscale">
         <Apple size={20} />
      </button>
      <button class="btn btn-outline border-white/5 bg-white/5 h-14 rounded-2xl btn-disabled opacity-30 grayscale">
         <Circle size={20} />
      </button>
   </div>
</div>

<div class="mt-12 text-center">
  <p class="text-[9px] font-black uppercase tracking-[0.4em] opacity-20">
    XIBALBÁ // PROTOCOLO_DE_ACCESO // V1.2
  </p>
</div>
