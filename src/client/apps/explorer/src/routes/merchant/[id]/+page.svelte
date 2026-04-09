<script lang="ts">
  import { page } from "$app/stores";
  import { DishCard, GlassCard, GlassContainer, ICONS, m } from "@sdk/ui";
  import { createDishStore } from "@sdk/state";
  import { MapPin, Star, Clock, Info, MessageSquare, Navigation, CreditCard, Wallet, Coins } from "lucide-svelte";
  import type { Dish } from "@sdk/core";
  import { DISH_CATEGORIES } from "@sdk/core";
  import { onMount } from "svelte";

  const dishStore = createDishStore();
  const merchantId = $page.params.id;

  // Mocked Merchant Context based on param string for demonstration
  const merchant = {
    name: merchantId === "tacos-el-rey" ? "Tacos El Rey" : "Comercio Local",
    description: "Auténtica comida callejera con las recetas de la abuela. Especialidad en tacos, gringas y quesadillas.",
    rating: 4.8,
    reviews: 124,
    distance: "1.2 km",
    open: true,
    image_url: "https://images.unsplash.com/photo-1555396273-367ea4eb4db5?q=80&w=1200&auto=format&fit=crop",
    hours: [
      { day: "Lun - Vie", time: "10:00 - 22:00" },
      { day: "Sábado", time: "12:00 - 23:00" },
      { day: "Domingo", time: "12:00 - 20:00" }
    ]
  };

  // Mocked Dishes filtered
  const merchantDishes = $derived(
    dishStore.all.slice(0, 10) // Fallback: just grab some global mock dishes 
  );

  let scrollY = $state(0);
  let showStickyBar = $derived(scrollY > 400);

  const mockReviews = [
    { name: "Carlos M.", rating: 5, text: "Los mejores tacos al pastor que he probado en mucho tiempo. La salsa es increíble.", date: "Hace 2 días" },
    { name: "Elena R.", rating: 4, text: "Muy buena atención y los precios son razonables. Recomiendo las gringas.", date: "Hace 1 semana" },
    { name: "John D.", rating: 5, text: "Great authentic experience! The staff was very helpful with translations.", date: "Hace 2 semanas" }
  ];
</script>

<svelte:window bind:scrollY />

<svelte:head>
  <title>{merchant.name} — Menú</title>
</svelte:head>

<!-- 3.6.2 — Merchant Info Bar (Sticky) -->
<div 
  class="fixed top-0 left-0 right-0 z-[100] transition-all duration-500 transform {showStickyBar ? 'translate-y-0 opacity-100' : '-translate-y-full opacity-0'}"
>
  <div class="bg-base-100/60 backdrop-blur-2xl border-b border-white/10 px-4 py-3">
    <div class="container mx-auto max-w-5xl flex items-center justify-between">
       <div class="flex items-center gap-4">
         <button onclick={() => history.back()} class="btn btn-circle btn-sm btn-ghost">
            <ICONS.chevron_left size={20} />
         </button>
         <div>
           <h3 class="font-black uppercase tracking-tighter text-lg leading-none">{merchant.name}</h3>
           <div class="flex items-center gap-2 mt-0.5">
              <div class="flex items-center gap-1">
                 <Star size={10} class="text-warning fill-warning" />
                 <span class="text-[10px] font-bold">{merchant.rating}</span>
              </div>
              <div class="w-1 h-1 rounded-full bg-base-content/20"></div>
              <span class="text-[10px] font-bold {merchant.open ? 'text-success' : 'text-error'} uppercase">
                {merchant.open ? 'Abierto' : 'Cerrado'}
              </span>
           </div>
         </div>
       </div>
       <button class="btn btn-primary btn-sm rounded-xl font-black uppercase tracking-widest text-[10px] px-6">
          <Navigation size={14} /> Cómo Llegar
       </button>
    </div>
  </div>
</div>

<!-- 3.6.1 — Parallax-Depth Hero -->
<div class="relative h-[60vh] min-h-[450px] bg-neutral overflow-hidden">
  <img 
    src={merchant.image_url} 
    alt={merchant.name}
    class="w-full h-full object-cover transition-transform duration-100 scale-110"
    style="transform: translateY({scrollY * 0.4}px) scale(1.1)"
  />
  <div class="absolute inset-0 bg-gradient-to-t from-base-100 via-base-100/40 to-transparent"></div>
  <div class="absolute inset-0 bg-black/20"></div>
  
  <div class="absolute inset-0 flex flex-col justify-end p-6 pb-16 container mx-auto max-w-5xl">
    <button onclick={() => history.back()} class="absolute top-8 left-6 btn btn-circle btn-md btn-ghost bg-base-100/20 backdrop-blur-xl border border-white/10 text-white shadow-2xl hover:scale-110 transition-transform">
      <ICONS.chevron_left size={24} />
    </button>

    <div class="flex flex-col md:flex-row md:items-end justify-between gap-6 relative z-10">
      <div class="text-white max-w-2xl animate-in fade-in slide-in-from-left-8 duration-1000">
        <div class="flex items-center gap-3 mb-4">
           <span class="px-4 py-1.5 rounded-full bg-primary text-primary-content text-xs font-black uppercase tracking-widest shadow-xl shadow-primary/30">
             Local Recomendado
           </span>
           <div class="flex items-center gap-1.5 px-3 py-1.5 rounded-full bg-white/10 backdrop-blur-xl border border-white/20 font-bold text-xs">
              <Star size={14} class="text-warning fill-warning" />
              {merchant.rating} <span class="opacity-60 font-normal">({merchant.reviews})</span>
            </div>
        </div>
        <h1 class="text-6xl md:text-8xl font-black italic uppercase tracking-tighter drop-shadow-2xl leading-[0.85] mb-6">
          {merchant.name}
        </h1>
        <p class="text-lg md:text-xl text-white/90 font-medium drop-shadow-lg max-w-xl leading-relaxed">
          {merchant.description}
        </p>
      </div>

      <div class="hidden md:flex flex-col items-end gap-4 animate-in fade-in slide-in-from-right-8 duration-1000">
        <div class="flex items-center gap-3 px-6 py-4 rounded-[2rem] bg-white/10 backdrop-blur-2xl border border-white/20 shadow-2xl">
           <div class="text-right">
              <span class="text-[10px] font-black uppercase tracking-widest text-white/60 block mb-0.5">Ubicación</span>
              <span class="text-sm font-bold text-white block">{merchant.distance} de ti</span>
           </div>
           <div class="w-10 h-10 rounded-xl bg-white/10 flex items-center justify-center text-white">
              <MapPin size={20} />
           </div>
        </div>
        <div class="flex items-center gap-3 px-6 py-4 rounded-[2rem] bg-white/10 backdrop-blur-2xl border border-white/20 shadow-2xl">
           <div class="text-right">
              <span class="text-[10px] font-black uppercase tracking-widest text-white/60 block mb-0.5">Horario</span>
              <span class="text-sm font-bold {merchant.open ? 'text-success-content' : 'text-error-content'} block">
                {merchant.open ? 'Abierto Ahora' : 'Cerrado'}
              </span>
           </div>
           <div class="w-10 h-10 rounded-xl bg-white/10 flex items-center justify-center text-white">
              <Clock size={20} />
           </div>
        </div>
      </div>
    </div>
  </div>
</div>

<main class="container mx-auto px-4 pt-4 pb-24 max-w-5xl -mt-10 relative z-10">
  
  <!-- 3.6.3 — Category Tab Navigation -->
  <div class="mb-10 flex overflow-x-auto gap-3 pb-4 scrollbar-hide px-2">
     <button class="flex-shrink-0 px-8 py-4 rounded-full bg-primary text-primary-content font-black uppercase tracking-widest text-[10px] shadow-2xl shadow-primary/40 -translate-y-1 transition-all">
        Todos
     </button>
     {#each DISH_CATEGORIES.slice(0, 6) as cat}
       <button class="flex-shrink-0 px-8 py-4 rounded-full bg-base-100/60 backdrop-blur-xl border border-white/10 text-base-content/60 font-black uppercase tracking-widest text-[10px] hover:bg-base-100 hover:text-base-content transition-all">
          {cat}
       </button>
     {/each}
  </div>

  <div class="grid grid-cols-1 lg:grid-cols-3 gap-10">
     <div class="lg:col-span-2 space-y-12">
        <section>
          <div class="flex items-center justify-between mb-8">
            <div class="flex items-center gap-4">
               <div class="w-2 h-10 bg-primary rounded-full"></div>
               <h2 class="text-4xl font-black italic uppercase tracking-tighter">Menú de la Casa</h2>
            </div>
            <div class="flex gap-2">
              <button class="btn btn-md btn-circle bg-base-200/50 backdrop-blur-md border border-white/10 shadow-lg hover:scale-110 transition-transform">
                <ICONS.search size={20}/>
              </button>
            </div>
          </div>

          <!-- Food grid -->
          <div class="grid grid-cols-1 sm:grid-cols-2 gap-8">
            {#each merchantDishes as dish}
              <DishCard {dish} onselect={() => console.log('Open Modal', dish.id)} />
            {/each}
          </div>

          {#if merchantDishes.length === 0}
            <div class="text-center py-20 flex flex-col items-center justify-center">
              <GlassCard class="p-12 items-center bg-base-100/30 !rounded-[3rem]">
                <ICONS.nav_menu size={64} strokeWidth={1} class="text-base-content/20 mb-4 animate-pulse" />
                <p class="text-xl font-black italic uppercase tracking-widest text-base-content/40">Sin platillos aún</p>
                <p class="text-sm opacity-60 mt-2 max-w-xs">El comercio aún no ha subido platillos a su menú digital.</p>
              </GlassCard>
            </div>
          {/if}
        </section>

        <!-- 3.6.5 — Reviews Preview Section -->
        <section>
           <div class="flex items-center justify-between mb-8">
              <div class="flex items-center gap-4">
                 <div class="w-2 h-10 bg-warning rounded-full"></div>
                 <h2 class="text-4xl font-black italic uppercase tracking-tighter">Lo que dicen</h2>
              </div>
              <button class="text-[10px] font-black uppercase tracking-widest text-primary hover:underline">Ver todas las reseñas ({merchant.reviews})</button>
           </div>

           <GlassContainer class="!rounded-[3rem] border border-white/5 shadow-2xl p-8">
              <div class="space-y-8">
                 {#each mockReviews as review}
                    <div class="group flex flex-col gap-3">
                       <div class="flex items-center justify-between">
                          <div class="flex items-center gap-3">
                             <div class="w-10 h-10 rounded-full bg-gradient-to-br from-base-300 to-base-200 flex items-center justify-center font-black text-xs">
                                {review.name[0]}
                             </div>
                             <div>
                                <p class="text-sm font-black uppercase tracking-tight">{review.name}</p>
                                <div class="flex items-center gap-0.5 mt-0.5">
                                   {#each Array(review.rating) as _}
                                      <Star size={10} class="text-warning fill-warning" />
                                   {/each}
                                </div>
                             </div>
                          </div>
                          <span class="text-[10px] font-bold opacity-30">{review.date}</span>
                       </div>
                       <p class="text-sm font-medium text-base-content/70 leading-relaxed italic">
                         "{review.text}"
                       </p>
                       <div class="h-px bg-base-content/5 group-last:hidden"></div>
                    </div>
                 {/each}
              </div>
           </GlassContainer>
        </section>
     </div>

     <div class="lg:col-span-1 space-y-8">
        <!-- 3.6.4 — "About This Place" Section -->
        <GlassCard class="p-8 !rounded-[3rem] border border-white/5 shadow-2xl space-y-8" enable3D={true}>
           <div>
              <h3 class="text-[10px] font-black uppercase tracking-widest opacity-40 mb-4 flex items-center gap-2">
                 <Info size={14} /> Información del Local
              </h3>
              <p class="text-sm font-medium text-base-content/80 leading-relaxed">
                {merchant.description}
              </p>
           </div>

           <div class="space-y-4">
              <h4 class="text-[10px] font-black uppercase tracking-widest opacity-40 flex items-center gap-2">
                 <Clock size={14} /> Horarios de Atención
              </h4>
              <div class="space-y-3">
                 {#each merchant.hours as h}
                    <div class="flex items-center justify-between text-xs">
                       <span class="font-bold opacity-60">{h.day}</span>
                       <span class="font-black uppercase tracking-tighter">{h.time}</span>
                    </div>
                 {/each}
              </div>
           </div>

           <div class="space-y-4">
              <h4 class="text-[10px] font-black uppercase tracking-widest opacity-40 flex items-center gap-2">
                 <CreditCard size={14} /> Métodos de Pago
              </h4>
              <div class="flex gap-4">
                 <div class="flex flex-col items-center gap-1.5 opacity-60 hover:opacity-100 transition-opacity">
                    <div class="w-10 h-10 rounded-xl bg-base-200 flex items-center justify-center shadow-inner">
                       <Wallet size={18} />
                    </div>
                    <span class="text-[8px] font-black uppercase tracking-widest text-center">Efectivo</span>
                 </div>
                 <div class="flex flex-col items-center gap-1.5 opacity-60 hover:opacity-100 transition-opacity text-primary">
                    <div class="w-10 h-10 rounded-xl bg-primary/10 flex items-center justify-center shadow-inner">
                       <CreditCard size={18} />
                    </div>
                    <span class="text-[8px] font-black uppercase tracking-widest text-center">Tarjeta</span>
                 </div>
                 <div class="flex flex-col items-center gap-1.5 opacity-60 hover:opacity-100 transition-opacity text-secondary">
                    <div class="w-10 h-10 rounded-xl bg-secondary/10 flex items-center justify-center shadow-inner">
                       <ICONS.money size={18} />
                    </div>
                    <span class="text-[8px] font-black uppercase tracking-widest text-center">QR Pay</span>
                 </div>
              </div>
           </div>

           <div class="pt-4">
              <div class="w-full h-40 rounded-[2rem] bg-base-200 border border-white/10 overflow-hidden relative group">
                 <div class="absolute inset-0 bg-gradient-to-t from-neutral/60 to-transparent z-10"></div>
                 <div class="absolute bottom-4 left-4 z-20">
                    <span class="text-[10px] font-black uppercase tracking-widest text-white block mb-0.5">Mapa</span>
                    <span class="text-xs font-bold text-white/80 block">Centro Histórico, CDMX</span>
                 </div>
                 <img 
                   src="https://images.unsplash.com/photo-1524661135-423995f22d0b?q=80&w=400&auto=format&fit=crop" 
                   alt="Map Preview" 
                   class="w-full h-full object-cover group-hover:scale-125 transition-transform duration-[5s]"
                 />
              </div>
           </div>
        </GlassCard>
     </div>
  </div>
</main>

