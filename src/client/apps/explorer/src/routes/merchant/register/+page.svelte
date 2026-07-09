<script lang="ts">
  import { goto } from "$app/navigation";
  import { GlassContainer, GlassCard, FormInput, SubmitButton, m, ICONS } from "@sdk/ui";
  import { Store, Globe, Banknote, Clock, Sparkles } from "lucide-svelte";
  import { authStore } from "@sdk/state";

  const auth = authStore;

  let loading = $state(false);
  let form = $state({
    email: "",
    password: "",
    businessName: "",
    address: "",
  });

  async function registerMerchant(e: Event) {
    e.preventDefault();
    loading = true;
    await new Promise((r) => setTimeout(r, 800)); // Simulate API
    loading = false;
    auth.setRole("business");
    goto("/dashboard");
  }

  const benefits = [
    { label: "Visibilidad Global", desc: "Traducido a 13+ idiomas", icon: Globe },
    { label: "Sin Comisiones", desc: "Tus ventas son 100% tuyas", icon: Banknote },
    { label: "Alta en 10 Min", desc: "Proceso rápido y digital", icon: Clock }
  ];
</script>

<svelte:head>
  <title>Alta Comercial — Xibalba</title>
</svelte:head>

<div class="min-h-screen flex flex-col items-center justify-center p-5 bg-base-100 relative overflow-hidden">
  <!-- Drifting Background Decor -->
  <div class="absolute top-[-10%] right-[-10%] w-[60%] h-[60%] bg-warning/10 blur-[120px] rounded-full pointer-events-none animate-pulse"></div>
  <div class="absolute bottom-[-10%] left-[-10%] w-[40%] h-[40%] bg-error/5 blur-[100px] rounded-full pointer-events-none animate-pulse delay-1000"></div>

  <div class="w-full max-w-2xl z-10 py-16">
    <div class="text-center mb-12">
      <div class="inline-flex items-center justify-center w-20 h-20 rounded-[2rem] bg-gradient-to-br from-warning to-error text-white shadow-2xl shadow-warning/30 mb-6 group hover:rotate-12 transition-transform duration-500">
        <Store size={40} />
      </div>
      <h1 class="text-4xl md:text-6xl font-black italic uppercase tracking-tighter text-transparent bg-clip-text bg-gradient-to-br from-base-content to-base-content/40 mb-4">
        Haz Crecer tu Negocio
      </h1>
      
      <!-- 3.14.2 — Social Proof Counter -->
      <div class="inline-flex items-center gap-3 px-4 py-2 rounded-full bg-warning/10 border border-warning/20 mb-8">
         <div class="w-2 h-2 rounded-full bg-warning animate-pulse"></div>
         <span class="text-[10px] font-black uppercase tracking-widest text-warning">487 negocios ya se unieron esta semana</span>
      </div>
    </div>

    <!-- 3.14.1 — Benefit Cards -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-10">
       {#each benefits as benefit}
         {@const Icon = benefit.icon}
         <GlassCard class="p-6 !rounded-[2rem] bg-warning/5 border border-warning/10 text-center flex flex-col items-center gap-3 group hover:-translate-y-1 transition-all" enable3D={true}>
            <div class="w-12 h-12 rounded-2xl bg-warning/10 text-warning flex items-center justify-center group-hover:bg-warning group-hover:text-white transition-all duration-500">
               <Icon size={24} />
            </div>
            <div>
               <h3 class="text-xs font-black uppercase tracking-widest leading-none mb-1">{benefit.label}</h3>
               <p class="text-[10px] font-bold opacity-40 italic">{benefit.desc}</p>
            </div>
         </GlassCard>
       {/each}
    </div>

    <GlassContainer class="!rounded-[3rem] p-8 md:p-12 shadow-[0_50px_100px_-20px_rgba(0,0,0,0.3)]" accent="from-warning to-error">
      <div class="mb-8">
         <h2 class="text-2xl font-black italic uppercase tracking-tighter flex items-center gap-2">
            <Sparkles size={20} class="text-warning" /> Registro de Establecimiento
         </h2>
         <p class="text-xs font-medium opacity-50 mt-1 italic">Completa los campos para activar tu terminal digital.</p>
      </div>

      <form onsubmit={registerMerchant} class="space-y-6">
        
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <FormInput
            type="email"
            label="Correo de Acceso"
            bind:value={form.email}
            placeholder="negocio@correo.com"
            required
          />
          <FormInput
            type="password"
            label="Contraseña"
            bind:value={form.password}
            placeholder="••••••••"
            required
          />
        </div>

        <div class="divider text-[9px] font-black uppercase tracking-[0.3em] opacity-20 italic my-4">Identidad de Marca</div>

        <FormInput
          label="Nombre del Establecimiento"
          bind:value={form.businessName}
          placeholder="Ej. Tacos El Pastor"
          required
        />

        <FormInput
          type="textarea"
          label="Ubicación Detallada"
          bind:value={form.address}
          placeholder="Calle Secundaria #123, Colonia Centro..."
          required
        />

        <div class="pt-6">
          <SubmitButton {loading} variant="primary" class="w-full h-auto py-5 rounded-[2rem] border-none bg-gradient-to-r from-warning to-error text-white font-black uppercase tracking-widest text-sm shadow-2xl shadow-warning/40 hover:scale-[1.02] active:scale-95 transition-all">
            Activar Cuenta Comercial
          </SubmitButton>
        </div>
      </form>

      <div class="mt-10 text-center">
        <p class="text-[10px] font-black uppercase tracking-widest text-base-content/40">
          ¿Ya tienes cuenta como comercio? 
          <a href="/login" class="text-warning hover:underline ml-2">
            Inicia Sesión
          </a>
        </p>
      </div>
    </GlassContainer>
  </div>
</div>
