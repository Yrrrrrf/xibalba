<script lang="ts">
  import { createDishStore, createBusinessStore } from "@sdk/state";
  import { MerchantDashboard, StatsCard, ICONS, GlassCard, GlassContainer } from "@sdk/ui";
  import { Plus, Eye, Star, Activity, ArrowRight, Layout, Settings, Share2, TrendingUp } from "lucide-svelte";
  import { m } from "@sdk/ui";

  const { onNavigate } = $props<{ onNavigate?: (tab: string) => void }>();

  const dishStore = createDishStore();
  const businessStore = createBusinessStore();

  const hour = new Date().getHours();
  const greeting = $derived(
    hour < 12 ? "Buenos Días" : hour < 18 ? "Buenas Tardes" : "Buenas Noches"
  );
  
  const userName = $derived(businessStore.profile?.owner_name || "Comerciante");

  const stats = $derived([
    {
      title: m.merchant_total_dishes(),
      value: dishStore.all.length,
      icon: ICONS.nav_menu,
      variant: "primary" as const,
      trend: "neutral" as const,
    },
    {
      title: m.merchant_total_sales(),
      value: dishStore.all.reduce(
        (acc: number, d: any) => acc + (d.sales_count || 0),
        0,
      ),
      icon: ICONS.money,
      variant: "success" as const,
      trend: "up" as const,
      trendValue: "+5%",
    },
    {
      title: "Vistas del Perfil",
      value: 847,
      icon: Eye,
      variant: "accent" as const,
      trend: "up" as const,
      trendValue: "+12%",
    },
    {
      title: "Valoración Promedio",
      value: "4.8",
      icon: Star,
      variant: "warning" as const,
      trend: "neutral" as const,
    },
  ]);

  const activities = [
    { time: "10:30 AM", text: "Nuevo pedido de Tacos al Pastor", color: "bg-success" },
    { time: "09:15 AM", text: "Reseña de ⭐⭐⭐⭐⭐ recibida", color: "bg-warning" },
    { time: "Ayer", text: "Perfil visto 23 veces hoy", color: "bg-info" },
    { time: "Ayer", text: "Cambio de horario guardado", color: "bg-primary" },
    { time: "Lunes", text: "Nuevo platillo 'Gringas Especiales' añadido", color: "bg-secondary" }
  ];
</script>

<main class="container mx-auto px-4 pt-6 pb-20 max-w-5xl animate-in fade-in slide-in-from-bottom-4 duration-700">
  
  <!-- 3.2.1 — Welcome Banner with Greeting -->
  <div class="mb-8 p-8 rounded-[2.5rem] bg-gradient-to-r from-primary/10 to-secondary/10 border border-white/10 backdrop-blur-xl relative overflow-hidden group shadow-2xl shadow-primary/5">
    <div class="absolute -right-10 -top-10 w-64 h-64 bg-primary/20 blur-[100px] rounded-full group-hover:scale-150 transition-transform duration-1000"></div>
    <div class="absolute -left-10 -bottom-10 w-48 h-48 bg-secondary/10 blur-[80px] rounded-full group-hover:scale-125 transition-transform duration-1000"></div>
    
    <div class="relative z-10 flex flex-col md:flex-row md:items-center justify-between gap-6">
      <div>
        <div class="flex items-center gap-2 mb-2">
          <span class="px-3 py-1 rounded-full bg-primary/20 text-primary text-[10px] font-black uppercase tracking-widest border border-primary/20">
            Panel del Propietario
          </span>
          <div class="flex items-center gap-1">
             <div class="w-1.5 h-1.5 rounded-full bg-success animate-pulse"></div>
             <span class="text-[10px] font-bold opacity-50 uppercase tracking-tighter">Sistema Online</span>
          </div>
        </div>
        <h2 class="text-4xl md:text-5xl font-black italic uppercase tracking-tighter text-transparent bg-clip-text bg-gradient-to-br from-base-content to-base-content/40 mb-3">
          {greeting}, {userName}
        </h2>
        <p class="text-base-content/60 font-medium max-w-md text-sm md:text-base">
          Tu menú tiene <span class="text-primary font-bold">{dishStore.all.length} platillos</span> activos. ¡Hoy es un gran día para recibir turistas!
        </p>
      </div>
      <div class="flex items-center gap-4">
         <div class="w-20 h-20 rounded-[2rem] bg-base-100/50 backdrop-blur-md flex items-center justify-center border border-white/10 shadow-2xl group-hover:rotate-12 transition-transform duration-500">
            {#if hour < 12}
              <span class="text-5xl drop-shadow-lg">🌅</span>
            {:else if hour < 18}
              <span class="text-5xl drop-shadow-lg">☀️</span>
            {:else}
              <span class="text-5xl drop-shadow-lg">🌙</span>
            {/if}
         </div>
      </div>
    </div>
  </div>

  <!-- 3.2.2 — Expanded Stats Grid -->
  <div class="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
    {#each stats as stat}
      <div class="group h-full border-t-4 border-t-transparent hover:border-t-primary transition-all duration-500 rounded-[2rem] shadow-xl hover:shadow-primary/10">
        <StatsCard {...stat} />
      </div>
    {/each}
  </div>

  <!-- 3.2.3 — Quick Actions Row -->
  <div class="grid grid-cols-2 md:grid-cols-4 gap-4 mb-10">
    <button onclick={() => onNavigate?.('menu')} class="group relative overflow-hidden p-5 rounded-[2rem] bg-base-100/40 border border-white/10 backdrop-blur-md hover:-translate-y-2 transition-all duration-500 shadow-lg hover:shadow-primary/20">
      <div class="absolute inset-0 bg-gradient-to-br from-primary/10 to-transparent opacity-0 group-hover:opacity-100 transition-opacity"></div>
      <div class="flex flex-col items-center gap-3 text-center relative z-10">
        <div class="w-12 h-12 rounded-2xl bg-primary/10 text-primary flex items-center justify-center group-hover:bg-primary group-hover:text-primary-content transition-all duration-500 shadow-inner">
          <Plus size={24} />
        </div>
        <span class="text-[10px] font-black uppercase tracking-widest opacity-80 group-hover:opacity-100">Añadir Platillo</span>
      </div>
    </button>

    <button onclick={() => onNavigate?.('profile')} class="group relative overflow-hidden p-5 rounded-[2rem] bg-base-100/40 border border-white/10 backdrop-blur-md hover:-translate-y-2 transition-all duration-500 shadow-lg hover:shadow-secondary/20">
      <div class="absolute inset-0 bg-gradient-to-br from-secondary/10 to-transparent opacity-0 group-hover:opacity-100 transition-opacity"></div>
      <div class="flex flex-col items-center gap-3 text-center relative z-10">
        <div class="w-12 h-12 rounded-2xl bg-secondary/10 text-secondary flex items-center justify-center group-hover:bg-secondary group-hover:text-secondary-content transition-all duration-500 shadow-inner">
          <Settings size={22} />
        </div>
        <span class="text-[10px] font-black uppercase tracking-widest opacity-80 group-hover:opacity-100">Configurar Local</span>
      </div>
    </button>

    <button onclick={() => onNavigate?.('dashboard')} class="group relative overflow-hidden p-5 rounded-[2rem] bg-base-100/40 border border-white/10 backdrop-blur-md hover:-translate-y-2 transition-all duration-500 shadow-lg hover:shadow-accent/20">
      <div class="absolute inset-0 bg-gradient-to-br from-accent/10 to-transparent opacity-0 group-hover:opacity-100 transition-opacity"></div>
      <div class="flex flex-col items-center gap-3 text-center relative z-10">
        <div class="w-12 h-12 rounded-2xl bg-accent/10 text-accent flex items-center justify-center group-hover:bg-accent group-hover:text-accent-content transition-all duration-500 shadow-inner">
          <TrendingUp size={22} />
        </div>
        <span class="text-[10px] font-black uppercase tracking-widest opacity-80 group-hover:opacity-100">Ver Analíticas</span>
      </div>
    </button>

    <button onclick={() => onNavigate?.('share')} class="group relative overflow-hidden p-5 rounded-[2rem] bg-base-100/40 border border-white/10 backdrop-blur-md hover:-translate-y-2 transition-all duration-500 shadow-lg hover:shadow-info/20">
      <div class="absolute inset-0 bg-gradient-to-br from-info/10 to-transparent opacity-0 group-hover:opacity-100 transition-opacity"></div>
      <div class="flex flex-col items-center gap-3 text-center relative z-10">
        <div class="w-12 h-12 rounded-2xl bg-info/10 text-info flex items-center justify-center group-hover:bg-info group-hover:text-info-content transition-all duration-500 shadow-inner">
          <Share2 size={22} />
        </div>
        <span class="text-[10px] font-black uppercase tracking-widest opacity-80 group-hover:opacity-100">Compartir QR</span>
      </div>
    </button>
  </div>

  <div class="grid grid-cols-1 lg:grid-cols-3 gap-8 mb-12">
    <!-- 3.2.4 — Revenue Mini-Chart Placeholder -->
    <div class="lg:col-span-2">
      <GlassCard class="p-8 h-full !rounded-[3rem] border border-white/5 shadow-2xl overflow-hidden group">
        <div class="absolute -right-20 -top-20 w-64 h-64 bg-primary/5 blur-[80px] rounded-full group-hover:bg-primary/10 transition-colors duration-1000"></div>
        
        <div class="flex items-center justify-between mb-8 relative z-10">
          <div>
            <h3 class="text-[10px] font-black uppercase tracking-widest opacity-40 mb-1">Análisis de Ingresos</h3>
            <p class="text-2xl font-black italic uppercase tracking-tighter">Rendimiento Semanal</p>
          </div>
          <div class="text-right">
            <span class="text-3xl font-black text-primary drop-shadow-sm">$2,450</span>
            <span class="text-[10px] font-bold opacity-40 block uppercase tracking-widest">MXN Estimados</span>
          </div>
        </div>

        <div class="flex items-end justify-between gap-3 h-48 relative z-10 px-2">
          {#each [40, 70, 45, 90, 65, 80, 55] as height, i}
            <div class="flex-1 flex flex-col items-center gap-3">
               <div class="relative w-full group/bar">
                  <div 
                    class="w-full bg-primary/10 rounded-2xl relative overflow-hidden transition-all duration-1000 ease-out delay-{i*100}" 
                    style="height: {height*1.8}px"
                  >
                    <div class="absolute inset-0 bg-gradient-to-t from-primary/60 to-primary opacity-40 group-hover/bar:opacity-100 transition-opacity duration-500"></div>
                    <div class="absolute inset-x-0 top-0 h-1 bg-white/20"></div>
                  </div>
                  <!-- Tooltip -->
                  <div class="absolute -top-10 left-1/2 -translate-x-1/2 bg-neutral text-neutral-content text-[10px] font-bold px-2 py-1 rounded-lg opacity-0 group-hover/bar:opacity-100 transition-opacity pointer-events-none whitespace-nowrap">
                    ${Math.round(height * 25)} MXN
                  </div>
               </div>
               <span class="text-[10px] font-black uppercase tracking-widest opacity-30">{"DLMMJVS"[i]}</span>
            </div>
          {/each}
        </div>
      </GlassCard>
    </div>

    <!-- 3.2.5 — Recent Activity Feed -->
    <div class="lg:col-span-1">
      <GlassContainer class="h-full !rounded-[3rem] border border-white/5 shadow-2xl p-8">
        <div class="flex items-center justify-between mt-2">
           <h3 class="text-[10px] font-black uppercase tracking-widest opacity-40">Flujo de Actividad</h3>
        </div>
        <div class="space-y-6 mt-6">
          {#each activities as item}
            <div class="flex items-start gap-4 group cursor-pointer">
              <div class="flex flex-col items-center gap-1 mt-1">
                <div class="w-2.5 h-2.5 rounded-full {item.color} shadow-[0_0_10px_rgba(0,0,0,0.1)] group-hover:scale-150 transition-transform duration-300"></div>
                <div class="w-0.5 h-10 bg-base-content/5 group-last:hidden"></div>
              </div>
              <div class="flex-1">
                <span class="text-[10px] font-black uppercase tracking-widest opacity-30 block mb-0.5">{item.time}</span>
                <p class="text-sm font-bold text-base-content/70 group-hover:text-base-content transition-colors leading-tight">
                  {item.text}
                </p>
              </div>
            </div>
          {/each}
        </div>
        <button class="btn btn-ghost btn-block btn-xs mt-6 text-[10px] font-black uppercase tracking-widest opacity-40 hover:opacity-100">
          Ver Historial Completo <ArrowRight size={10} />
        </button>
      </GlassContainer>
    </div>
  </div>

  <!-- 3.8.2 — Public Preview Toggle (Owners choice) -->
  <div class="mb-12">
    <div class="flex items-center justify-between mb-6">
       <div>
         <h3 class="text-[10px] font-black uppercase tracking-widest opacity-40 mb-1">Vista del Consumidor</h3>
         <p class="text-2xl font-black italic uppercase tracking-tighter">Tu Escaparate Digital</p>
       </div>
       <button class="btn btn-outline btn-primary rounded-[1.5rem] px-6 font-black uppercase tracking-widest text-[10px]">
          <Eye size={16} /> Ver como Turista
       </button>
    </div>
    
    <div class="relative group cursor-pointer overflow-hidden rounded-[3rem] border border-white/10 shadow-2xl">
      <div class="absolute inset-0 bg-gradient-to-t from-neutral/90 via-neutral/40 to-transparent z-10"></div>
      <div class="absolute inset-0 flex flex-col justify-end p-10 z-20">
        <div class="flex items-center gap-3 mb-2">
          <div class="px-3 py-1 rounded-full bg-primary text-primary-content text-[10px] font-black uppercase tracking-widest">Vista Previa</div>
          <span class="text-white/60 text-[10px] font-bold uppercase tracking-widest italic">Haz clic para editar la apariencia visual</span>
        </div>
        <h4 class="text-3xl font-black text-white italic uppercase tracking-tighter mb-4">
          Controla cómo el mundo ve tu negocio
        </h4>
        <div class="flex gap-4">
           <div class="flex items-center gap-1.5 px-4 py-2 rounded-2xl bg-white/10 backdrop-blur-md border border-white/10 text-white font-bold text-xs">
              <Layout size={14} /> Cambiar Diseño
           </div>
           <button class="flex items-center gap-1.5 px-4 py-2 rounded-2xl bg-white/10 backdrop-blur-md border border-white/10 text-white font-bold text-xs">
              <ICONS.nav_menu size={14} /> Personalizar Menú
           </button>
        </div>
      </div>
      <img 
        src="https://images.unsplash.com/photo-1555396273-367ea4eb4db5?q=80&w=1200&auto=format&fit=crop" 
        alt="Preview" 
        class="w-full h-[300px] object-cover group-hover:scale-110 transition-transform duration-[2s]"
      />
    </div>
  </div>

  <div class="opacity-70 flex items-center justify-between mb-6 mt-12">
    <div class="flex items-center gap-3">
      <div class="w-1.5 h-8 bg-primary rounded-full"></div>
      <h3 class="text-xl font-black uppercase tracking-tighter italic text-base-content/80">Catálogo de Platillos</h3>
    </div>
    <button onclick={() => onNavigate?.('menu')} class="btn btn-ghost btn-sm text-[10px] font-black uppercase tracking-widest text-primary">Gestionar Menú <ArrowRight size={14}/></button>
  </div>
  
  <GlassCard class="p-4 !rounded-[2.5rem] border border-white/5 shadow-xl">
    <MerchantDashboard dishes={dishStore.all} />
  </GlassCard>
</main>
