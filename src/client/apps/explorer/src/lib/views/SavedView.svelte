<script lang="ts">
  import { createDishStore, createVisitorStore } from "@sdk/state";
  import { SavedDishCard, ICONS, GlassCard, GlassContainer, m } from "@sdk/ui";
  import type { Dish } from "@sdk/core";
  import { MapPin, ArrowRight, Filter } from "lucide-svelte";

  const { onNavigate } = $props<{ onNavigate?: (tab: string) => void }>();

  const dishStore = createDishStore();
  const visitorStore = createVisitorStore();

  const savedDishes = $derived(
    visitorStore.saved
      .map((s: any) => dishStore.findById(s.dish_id))
      .filter((d: Dish | undefined) => d !== undefined) as Dish[]
  );

  // 3.10.2 — Group by Merchant (Mocked grouping for demonstration)
  const groupedDishes = $derived(
    savedDishes.reduce((acc: Record<string, Dish[]>, dish) => {
      const merchantName = dish.category === "Food" ? "Tacos El Rey" : "Artesanías Mayas";
      if (!acc[merchantName]) acc[merchantName] = [];
      acc[merchantName].push(dish);
      return acc;
    }, {} as Record<string, Dish[]>)
  );
</script>

<main class="container mx-auto px-4 pt-10 pb-24 max-w-2xl animate-in fade-in slide-in-from-bottom-4 duration-700">
  
  <!-- 3.10.1 — Collection Header with Count & Sort -->
  <div class="mb-12 flex flex-col md:flex-row md:items-end justify-between gap-6">
    <div>
      <div class="flex items-center gap-4 mb-3">
         <div class="w-2 h-10 bg-error rounded-full"></div>
         <h1 class="text-4xl md:text-6xl font-black italic uppercase tracking-tighter text-transparent bg-clip-text bg-gradient-to-br from-base-content to-base-content/40">
           {m.saved_title()}
         </h1>
      </div>
      <p class="text-base-content/50 text-xs md:text-sm font-bold italic uppercase tracking-widest pl-6">
        Tu bitácora gastronómica para el mundial
      </p>
    </div>

    {#if savedDishes.length > 0}
      <div class="flex items-center gap-3 bg-base-100/40 backdrop-blur-xl p-2 rounded-2xl border border-white/10 shadow-xl">
         <div class="px-4 py-2 rounded-xl bg-error/10 text-error font-black text-xs uppercase tracking-widest">
            {savedDishes.length} Guardados
         </div>
         <button class="btn btn-ghost btn-square btn-sm opacity-40 hover:opacity-100 transition-opacity">
            <Filter size={16} />
         </button>
      </div>
    {/if}
  </div>

  <div class="space-y-12 pb-12">
    {#each Object.entries(groupedDishes) as [merchant, dishes]}
      <section class="space-y-6">
        <!-- 3.10.2 — Merchant Header -->
        <div class="flex items-center justify-between px-4 group cursor-pointer">
           <div class="flex items-center gap-3">
              <div class="w-10 h-10 rounded-xl bg-base-content/5 flex items-center justify-center text-primary group-hover:scale-110 transition-transform">
                 <ICONS.store size={20} />
              </div>
              <div>
                 <h2 class="text-xl font-black italic uppercase tracking-tighter text-base-content/80 group-hover:text-primary transition-colors">{merchant}</h2>
                 <div class="flex items-center gap-2">
                    <span class="text-[10px] font-bold opacity-30 uppercase tracking-widest">Ver Perfil del Local</span>
                    <ArrowRight size={10} class="opacity-30" />
                 </div>
              </div>
           </div>
           <div class="badge badge-ghost font-black text-[10px] tracking-widest opacity-40">{dishes.length} PLATILLOS</div>
        </div>

        <div class="grid grid-cols-1 gap-4">
           {#each dishes as dish (dish.id)}
              <div class="group relative">
                <div class="absolute inset-0 bg-error/5 blur-xl opacity-0 group-hover:opacity-100 transition-opacity"></div>
                <GlassCard class="relative !rounded-[2rem] border border-white/5 shadow-xl hover:-translate-y-1 transition-all duration-300 overflow-hidden">
                   <SavedDishCard {dish} onremove={(id) => visitorStore.remove(id)} />
                </GlassCard>
              </div>
           {/each}
        </div>
      </section>
    {/each}

    <!-- 3.10.3 — Empty State Enhancement -->
    {#if savedDishes.length === 0}
      <div class="text-center py-32 flex flex-col items-center justify-center relative overflow-hidden">
        <div class="absolute inset-0 bg-gradient-radial from-error/5 to-transparent opacity-50"></div>
        <div class="relative z-10 space-y-6">
          <div class="w-32 h-32 rounded-[3rem] bg-base-100/50 backdrop-blur-3xl border border-white/10 flex items-center justify-center text-error/20 mx-auto shadow-2xl group-hover:rotate-12 transition-transform duration-1000">
            <ICONS.nav_saved size={64} strokeWidth={1} />
          </div>
          <div class="space-y-2">
            <h3 class="text-3xl font-black italic uppercase tracking-tighter text-transparent bg-clip-text bg-gradient-to-br from-base-content to-base-content/40">
              Tu Plato está Vacío
            </h3>
            <p class="text-sm font-medium text-base-content/50 italic max-w-xs mx-auto">
              {m.saved_empty()} Explora el mapa y guarda los tesoros culinarios que encuentres.
            </p>
          </div>
          <button 
            onclick={() => onNavigate?.('discover')}
            class="btn btn-primary rounded-full px-12 font-black tracking-widest uppercase shadow-xl shadow-primary/30 hover:scale-105 active:scale-95 transition-all mt-4 animate-pulse"
          >
            {m.saved_explore()}
          </button>
        </div>
      </div>
    {/if}
  </div>

  <!-- 3.10.4 — "Plan My Route" CTA -->
  {#if savedDishes.length > 0}
    <div class="fixed bottom-24 left-1/2 -translate-x-1/2 w-full max-w-lg px-6 z-[60]">
       <GlassContainer class="!rounded-[2.5rem] p-6 shadow-[0_30px_60px_-15px_rgba(0,0,0,0.4)] border border-white/10 bg-gradient-to-r from-error/10 to-transparent">
          <div class="flex items-center justify-between gap-6">
             <div class="flex items-center gap-4">
                <div class="w-12 h-12 rounded-2xl bg-error/20 text-error flex items-center justify-center shadow-inner">
                   <MapPin size={24} />
                </div>
                <div>
                   <h4 class="text-sm font-black uppercase tracking-widest italic text-base-content">¿Listo para tu ruta?</h4>
                   <p class="text-[10px] font-bold opacity-40 uppercase tracking-widest">Optimizar recorrido gastronómico</p>
                </div>
             </div>
             <button class="btn btn-error btn-circle shadow-lg shadow-error/20 hover:scale-110 transition-transform">
                <ArrowRight size={24} />
             </button>
          </div>
       </GlassContainer>
    </div>
  {/if}
</main>
