<script lang="ts">
  import { goto } from "$app/navigation";
  import { authStore } from "@sdk/state";
  import { m, ICONS, GlassCard } from "@sdk/ui";
  import { User, Store, Globe, Apple, Circle } from "lucide-svelte";

  const auth = authStore;
  
  let loading = $state(false);
  let name = $state("");
  let email = $state("");
  let password = $state("");
  
  let userRole = $state<"tourist" | "business">("tourist");

  async function handleRegister(e: Event) {
    e.preventDefault();
    loading = true;
    
    // Simulate network delay
    await new Promise((r) => setTimeout(r, 800));
    
    auth.setRole(userRole);
    
    loading = false;
    
    if (userRole === "tourist") {
      goto("/discover");
    } else {
      goto("/dashboard");
    }
  }
</script>

<svelte:head>
  <title>Registro — {m.app_name()}</title>
</svelte:head>

<div class="text-center mb-8">
  <h1 class="text-4xl font-black italic uppercase tracking-tighter text-transparent bg-clip-text bg-gradient-to-br from-base-content to-base-content/40">Únete a Xibalbá</h1>
  <p class="text-base-content/50 text-[10px] font-black uppercase tracking-widest mt-2 italic">Crea tu pasaporte digital</p>
</div>

<!-- 3.13.1 — Role Selection Cards -->
<div class="grid grid-cols-2 gap-4 mb-8">
   <button onclick={() => userRole = 'tourist'} class="group">
      <GlassCard 
        class="p-4 flex flex-col items-center gap-3 transition-all {userRole === 'tourist' ? 'border-primary ring-2 ring-primary/20 bg-primary/5' : 'border-white/5 opacity-50 grayscale'}"
        enable3D={userRole === 'tourist'}
      >
         <div class="w-12 h-12 rounded-xl bg-primary/10 text-primary flex items-center justify-center">
            <User size={24} />
         </div>
         <span class="text-[10px] font-black uppercase tracking-widest">Soy Turista</span>
      </GlassCard>
   </button>
   
   <button onclick={() => userRole = 'business'} class="group">
      <GlassCard 
        class="p-4 flex flex-col items-center gap-3 transition-all {userRole === 'business' ? 'border-secondary ring-2 ring-secondary/20 bg-secondary/5' : 'border-white/5 opacity-50 grayscale'}"
        enable3D={userRole === 'business'}
      >
         <div class="w-12 h-12 rounded-xl bg-secondary/10 text-secondary flex items-center justify-center">
            <Store size={24} />
         </div>
         <span class="text-[10px] font-black uppercase tracking-widest">Soy Comercio</span>
      </GlassCard>
   </button>
</div>

<form onsubmit={handleRegister} class="space-y-5">
  <div class="space-y-1">
    <label class="text-[10px] font-black uppercase tracking-widest opacity-40 ml-2">Nombre Completo</label>
    <div class="relative">
       <input 
         type="text" 
         bind:value={name}
         placeholder="Ej. Juan Pérez" 
         class="w-full px-6 py-4 rounded-2xl bg-base-100/40 border border-white/10 focus:outline-none focus:ring-2 {userRole === 'tourist' ? 'focus:ring-primary/20 focus:border-primary/30' : 'focus:ring-secondary/20 focus:border-secondary/30'} transition-all font-bold text-sm" 
         required
       />
    </div>
  </div>

  <div class="space-y-1">
    <label class="text-[10px] font-black uppercase tracking-widest opacity-40 ml-2">Correo Electrónico</label>
    <div class="relative">
       <input 
         type="email" 
         bind:value={email}
         placeholder="tu@correo.com" 
         class="w-full px-6 py-4 rounded-2xl bg-base-100/40 border border-white/10 focus:outline-none focus:ring-2 {userRole === 'tourist' ? 'focus:ring-primary/20 focus:border-primary/30' : 'focus:ring-secondary/20 focus:border-secondary/30'} transition-all font-bold text-sm" 
         required
       />
    </div>
  </div>

  <div class="space-y-1">
    <label class="text-[10px] font-black uppercase tracking-widest opacity-40 ml-2">Contraseña</label>
    <div class="relative">
       <input 
         type="password" 
         bind:value={password}
         placeholder="••••••••" 
         class="w-full px-6 py-4 rounded-2xl bg-base-100/40 border border-white/10 focus:outline-none focus:ring-2 {userRole === 'tourist' ? 'focus:ring-primary/20 focus:border-primary/30' : 'focus:ring-secondary/20 focus:border-secondary/30'} transition-all font-bold text-sm" 
         required
       />
    </div>
  </div>

  <button 
    type="submit" 
    class="btn {userRole === 'business' ? 'btn-secondary shadow-secondary/30' : 'btn-primary shadow-primary/30'} w-full h-auto py-5 rounded-[2rem] shadow-2xl font-black uppercase tracking-widest text-xs mt-4 transition-all active:scale-95"
    disabled={loading}
  >
    {#if loading}
      <span class="loading loading-spinner loading-md"></span>
    {:else}
      Registrarme
    {/if}
  </button>
</form>

<div class="mt-8 space-y-6">
   <div class="divider text-[9px] font-black uppercase tracking-[0.3em] opacity-20 italic">o regístrate con</div>
   
   <div class="grid grid-cols-3 gap-4">
      <button class="btn btn-outline border-white/5 bg-white/5 h-12 rounded-2xl opacity-40 hover:opacity-100 transition-all">
         <Globe size={18} />
      </button>
      <button class="btn btn-outline border-white/5 bg-white/5 h-12 rounded-2xl opacity-40 hover:opacity-100 transition-all">
         <Apple size={18} />
      </button>
      <button class="btn btn-outline border-white/5 bg-white/5 h-12 rounded-2xl opacity-40 hover:opacity-100 transition-all">
         <Circle size={18} />
      </button>
   </div>
</div>

<p class="text-center text-[10px] font-black uppercase tracking-widest text-base-content/40 mt-8">
  ¿Ya tienes cuenta? 
  <a href="/login" class="text-base-content hover:text-primary transition-colors underline underline-offset-4">Inicia Sesión</a>
</p>
