<script lang="ts">
  import { createDishStore } from "@sdk/state";
  import { GlassCard, GlassContainer, PriceTag, StatusBadge, ICONS, DishForm, m } from "@sdk/ui";
  import { Plus, Search, Filter, GripVertical, Edit3, Trash2, Eye, EyeOff, MoreVertical, ArrowRight } from 'lucide-svelte';
  import { DISH_CATEGORIES } from "@sdk/core";

  const { onNavigate } = $props<{ onNavigate?: (tab: string) => void }>();

  const dishStore = createDishStore();
  let isAddModalOpen = $state(false);

  const menuStats = $derived({
    total: dishStore.all.length,
    active: dishStore.all.filter(d => d.available).length,
    paused: dishStore.all.filter(d => !d.available).length,
    avgPrice: Math.round(dishStore.all.reduce((acc, d) => acc + d.price, 0) / (dishStore.all.length || 1))
  });
</script>

<main class="container mx-auto px-4 pt-6 pb-24 max-w-5xl animate-in fade-in slide-in-from-bottom-4 duration-700">
  
  <div class="flex flex-col md:flex-row md:items-end justify-between gap-6 mb-10">
    <div>
      <div class="flex items-center gap-3 mb-2">
         <div class="w-1.5 h-8 bg-primary rounded-full"></div>
         <h1 class="text-4xl md:text-6xl font-black italic uppercase tracking-tighter text-transparent bg-clip-text bg-gradient-to-br from-base-content to-base-content/40">
           {m.menu_title()}
         </h1>
      </div>
      <p class="text-base-content/50 text-xs md:text-sm font-bold italic uppercase tracking-widest pl-5">
        Gestiona tu oferta gastronómica para el mundo
      </p>
    </div>
    <button
      onclick={() => isAddModalOpen = true}
      class="btn btn-primary font-black rounded-[2rem] shadow-2xl shadow-primary/30 gap-2 h-auto py-4 px-8 uppercase tracking-widest text-xs hover:scale-105 transition-transform"
    >
      <Plus size={20} /> {m.menu_add()}
    </button>
  </div>

  <!-- 3.4.4 — Menu Stats Summary Bar -->
  <GlassContainer class="mb-10 p-6 !rounded-[2.5rem] border border-white/5 shadow-2xl">
     <div class="flex flex-wrap items-center justify-between gap-6 px-4">
        <div class="flex items-center gap-3">
           <div class="w-10 h-10 rounded-2xl bg-primary/10 text-primary flex items-center justify-center shadow-inner">
              <ICONS.nav_menu size={20} />
           </div>
           <div>
              <span class="text-[10px] font-black uppercase tracking-widest opacity-40 block">Total</span>
              <span class="text-xl font-black italic uppercase tracking-tighter">{menuStats.total} Platillos</span>
           </div>
        </div>

        <div class="w-px h-10 bg-base-content/5 hidden md:block"></div>

        <div class="flex items-center gap-3">
           <div class="w-10 h-10 rounded-2xl bg-success/10 text-success flex items-center justify-center shadow-inner">
              <Eye size={20} />
           </div>
           <div>
              <span class="text-[10px] font-black uppercase tracking-widest opacity-40 block">Activos</span>
              <span class="text-xl font-black italic uppercase tracking-tighter">{menuStats.active}</span>
           </div>
        </div>

        <div class="w-px h-10 bg-base-content/5 hidden md:block"></div>

        <div class="flex items-center gap-3">
           <div class="w-10 h-10 rounded-2xl bg-error/10 text-error flex items-center justify-center shadow-inner">
              <EyeOff size={20} />
           </div>
           <div>
              <span class="text-[10px] font-black uppercase tracking-widest opacity-40 block">Pausados</span>
              <span class="text-xl font-black italic uppercase tracking-tighter">{menuStats.paused}</span>
           </div>
        </div>

        <div class="w-px h-10 bg-base-content/5 hidden md:block"></div>

        <div class="flex items-center gap-3">
           <div class="w-10 h-10 rounded-2xl bg-secondary/10 text-secondary flex items-center justify-center shadow-inner">
              <ICONS.money size={20} />
           </div>
           <div>
              <span class="text-[10px] font-black uppercase tracking-widest opacity-40 block">Precio Promedio</span>
              <span class="text-xl font-black italic uppercase tracking-tighter">${menuStats.avgPrice} <span class="text-[10px] opacity-40">MXN</span></span>
           </div>
        </div>
     </div>
  </GlassContainer>

  <!-- 3.4.1 — Menu Header with Search & Filters -->
  <div class="flex flex-col md:flex-row gap-4 mb-8">
     <div class="flex-1 relative group">
        <div class="absolute inset-y-0 left-5 flex items-center pointer-events-none text-base-content/30 group-focus-within:text-primary transition-colors">
           <Search size={20} />
        </div>
        <input 
          type="text" 
          placeholder="Busca un platillo..." 
          class="w-full pl-14 pr-6 py-5 rounded-[2rem] bg-base-100/40 border border-white/10 backdrop-blur-xl focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary/30 transition-all font-bold text-sm shadow-xl"
        />
     </div>
     <div class="flex overflow-x-auto gap-2 pb-2 scrollbar-hide">
        <button class="px-6 py-4 rounded-full bg-primary text-primary-content font-black uppercase tracking-widest text-[10px] shadow-lg shadow-primary/20 transition-all">
           Todos
        </button>
        {#each DISH_CATEGORIES.slice(0, 4) as cat}
          <button class="px-6 py-4 rounded-full bg-base-100/60 backdrop-blur-xl border border-white/10 text-base-content/60 font-black uppercase tracking-widest text-[10px] hover:bg-base-100 hover:text-base-content transition-all">
             {cat}
          </button>
        {/each}
        <button class="px-4 py-4 rounded-full bg-base-100/60 backdrop-blur-xl border border-white/10 text-base-content/60 font-black uppercase tracking-widest text-[10px]">
           <Filter size={14} />
        </button>
     </div>
  </div>

  <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8 pb-12">
    {#each dishStore.all as dish}
      <!-- 3.4.2 — Enhanced Dish Cards -->
      <GlassCard class="p-4 group relative !rounded-[2.5rem] border border-white/5 shadow-2xl hover:-translate-y-2 transition-all duration-500 overflow-hidden">
        <!-- Drag Handle Indicator -->
        <div class="absolute left-3 top-1/2 -translate-y-1/2 opacity-10 group-hover:opacity-100 cursor-grab active:cursor-grabbing transition-opacity text-base-content">
           <GripVertical size={24} />
        </div>

        <div class="pl-8 relative z-10">
           <!-- Placeholder Image Area -->
           <div class="w-full h-40 rounded-[2rem] bg-gradient-to-br from-primary/10 to-secondary/10 mb-5 relative overflow-hidden flex items-center justify-center border border-white/10 shadow-inner group/img">
              <div class="absolute inset-0 bg-neutral/10 opacity-0 group-hover/img:opacity-100 transition-opacity"></div>
              <ICONS.nav_menu size={48} strokeWidth={1} class="text-base-content/10 group-hover/img:scale-125 transition-transform duration-700" />
              <div class="absolute top-3 right-3">
                 <StatusBadge status={dish.available ? "active_food" : "hidden_food"} />
              </div>
           </div>

           <div class="space-y-4">
              <div class="flex items-start justify-between">
                <div class="flex-1 min-w-0">
                  <span class="text-[10px] font-black uppercase tracking-widest text-primary mb-1 block">{dish.category}</span>
                  <h3 class="font-black italic uppercase tracking-tighter text-2xl text-base-content truncate group-hover:text-primary transition-colors">
                    {dish.name}
                  </h3>
                </div>
                <div class="dropdown dropdown-end">
                   <div tabindex="0" role="button" class="btn btn-ghost btn-circle btn-sm opacity-40 hover:opacity-100"><MoreVertical size={16}/></div>
                   <!-- svelte-ignore a11y_no_noninteractive_tabindex -->
                   <ul tabindex="0" class="dropdown-content z-[1] menu p-2 shadow-2xl bg-base-100 border border-white/10 rounded-2xl w-40 backdrop-blur-xl">
                     <li><button class="text-xs font-bold"><Edit3 size={14} /> Editar</button></li>
                     <li><button class="text-xs font-bold text-error"><Trash2 size={14} /> Eliminar</button></li>
                   </ul>
                </div>
              </div>

              <div class="flex items-center justify-between pt-2 border-t border-base-content/5">
                <PriceTag amount={dish.price} size="lg" />
                <div class="flex gap-1">
                  <button class="btn btn-sm btn-circle btn-ghost bg-primary/10 text-primary shadow-sm hover:scale-110 transition-transform">
                    <Edit3 size={16} />
                  </button>
                  <button class="btn btn-sm btn-circle btn-ghost {dish.available ? 'bg-success/10 text-success' : 'bg-error/10 text-error'} shadow-sm hover:scale-110 transition-transform">
                    {#if dish.available}
                      <Eye size={16} />
                    {:else}
                      <EyeOff size={16} />
                    {/if}
                  </button>
                </div>
              </div>
           </div>
        </div>
      </GlassCard>
    {/each}

    {#if dishStore.all.length === 0}
      <div class="col-span-full">
         <GlassCard class="p-20 text-center flex flex-col items-center justify-center !rounded-[3rem] bg-base-100/30 border-dashed border-2 border-primary/20">
            <div class="w-20 h-20 rounded-[2rem] bg-primary/5 flex items-center justify-center text-primary/30 mb-6 shadow-inner">
               <ICONS.nav_menu size={48} strokeWidth={1} />
            </div>
            <h3 class="text-2xl font-black italic uppercase tracking-tighter mb-2">{m.merchant_no_dishes()}</h3>
            <p class="text-sm opacity-60 mb-8 max-w-xs">{m.merchant_no_dishes_sub()}</p>
            <button onclick={() => isAddModalOpen = true} class="btn btn-primary rounded-[1.5rem] px-8 font-black uppercase tracking-widest text-[10px]">
               {m.menu_add()} <Plus size={14} />
            </button>
         </GlassCard>
      </div>
    {/if}
  </div>

  <div class="mt-12 text-center">
     <button onclick={() => onNavigate?.('dashboard')} class="btn btn-ghost text-[10px] font-black uppercase tracking-widest opacity-40 hover:opacity-100">
        Volver al Panel Central <ArrowRight size={14} />
     </button>
  </div>
</main>

{#if isAddModalOpen}
  <div class="modal modal-open">
    <div class="modal-box max-w-2xl bg-base-100/90 backdrop-blur-2xl border border-white/10 rounded-[2.5rem] p-0 overflow-hidden shadow-2xl">
      <div class="p-8 border-b border-white/5 bg-gradient-to-r from-primary/10 to-transparent">
        <h3 class="text-3xl font-black italic uppercase tracking-tighter">{m.menu_add()}</h3>
        <p class="text-xs font-bold opacity-50 uppercase tracking-widest mt-1">Crea un nuevo platillo en tu menú</p>
      </div>
      <div class="p-8">
        <DishForm onsubmit={() => isAddModalOpen = false} oncancel={() => isAddModalOpen = false} />
      </div>
    </div>
    <button class="modal-backdrop" onclick={() => isAddModalOpen = false}>close</button>
  </div>
{/if}
