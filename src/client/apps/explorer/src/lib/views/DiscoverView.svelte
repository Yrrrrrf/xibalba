<script lang="ts">
  import {
    createDishStore,
    createGeoStore,
    createBusinessStore,
  } from "@sdk/state";
  import { DishCard, DishDetailModal, ZoneSelector, MapView, BusinessDetailModal, ICONS, GlassContainer, GlassCard } from "@sdk/ui";
  import { DISH_CATEGORIES } from "@sdk/core";
  import type { Dish, Business } from "@sdk/core";
  import { m } from "@sdk/ui";

  const dishStore = createDishStore();
  const geoStore = createGeoStore();
  const businessStore = createBusinessStore();

  let selectedDish = $state<Dish | null>(null);
  let isDetailOpen = $state(false);
  
  let selectedBusiness = $state<Business | null>(null);
  let isBusinessModalOpen = $state(false);
  
  let categoriaActiva = $state("Todos");
  let vibeActiva = $state("Todos");
  let searchQuery = $state("");
  let showMagicToast = $state(false);

  const VIBES = [
    { key: "Todos", label: "Cualquier Vibe", icon: ICONS.radio },
    { key: "Mystical", label: "Místico", icon: ICONS.star },
    { key: "Energetic", label: "Energético", icon: ICONS.flame },
    { key: "Relax", label: "Relax", icon: ICONS.info },
    { key: "Ancestral", label: "Ancestral", icon: ICONS.book_menu },
  ];

  const CATEGORIES = [
    { key: "Todos", label: m.discover_all(), Icon: ICONS.search, color: "oklch(var(--p))" },
    { key: "Food", label: "Gastronomía", Icon: ICONS.cat_mexican, color: "#10b981" },
    { key: "Service", label: "Servicios", Icon: ICONS.clipboard, color: "#3b82f6" },
    { key: "Craft", label: "Artesanías", Icon: ICONS.wave, color: "#f59e0b" },
    { key: "Mystic", label: "Misticismo", Icon: ICONS.star, color: "#a855f7" },
  ];

  // Dynamic businesses state
  let businesses = $state<(Business & { vibe: string; color: string })[]>([]);

  function generateMockData(centerLat = 19.4326, centerLng = -99.1332) {
    const newItems = Array.from({ length: 25 }).map((_, i) => {
      const cat = CATEGORIES[1 + Math.floor(Math.random() * 4)];
      return {
        id: `kron-${Math.random().toString(36).substr(2, 9)}`,
        name: `${cat.label} ${['Ancestral', 'Xibalba', 'Solar', 'Lunar', 'Maya'][Math.floor(Math.random() * 5)]} ${i + 1}`,
        category: cat.key as any,
        address: `Sector ${Math.floor(Math.random() * 9) + 1}, Zona Central`,
        rating: 4.0 + Math.random(),
        lat: centerLat + (Math.random() - 0.5) * 0.03,
        lng: centerLng + (Math.random() - 0.5) * 0.03,
        open: Math.random() > 0.3,
        vibe: VIBES[1 + Math.floor(Math.random() * 4)].key,
        color: cat.color
      };
    });
    businesses = newItems;
  }

  $effect(() => {
    generateMockData();
  });

  $effect(() => {
    const timer = setTimeout(() => {
      showMagicToast = true;
      setTimeout(() => { showMagicToast = false; }, 4000);
    }, 1000);
    return () => clearTimeout(timer);
  });

  const filteredItems = $derived(
    businesses.filter(b => {
      const matchCat = categoriaActiva === "Todos" || b.category === categoriaActiva;
      const matchVibe = vibeActiva === "Todos" || b.vibe === vibeActiva;
      const matchSearch = b.name.toLowerCase().includes(searchQuery.toLowerCase()) || 
                          b.category.toLowerCase().includes(searchQuery.toLowerCase());
      return matchCat && matchVibe && matchSearch;
    })
  );

  function openBusiness(b: Business) {
    selectedBusiness = b;
    isBusinessModalOpen = true;
  }
</script>

<main class="relative min-h-screen pb-20 bg-base-100 overflow-x-hidden">
  <!-- THE KRON BACKDROP: Fixed the blur and made it high-clarity -->
  <div class="h-[70vh] w-full relative perspective-1000 z-10">
    <div class="absolute inset-0">
      <MapView 
        businesses={filteredItems} 
        height="100%" 
        onbusinessselect={openBusiness}
        onlocationfound={(lat, lng) => generateMockData(lat, lng)}
      />
    </div>
    
    <!-- Gradient mask to blend map -->
    <div class="absolute inset-x-0 bottom-0 h-64 bg-gradient-to-t from-base-100 via-base-100/60 to-transparent z-10 pointer-events-none"></div>

    <!-- THE KRON HUD: Hovering over the map -->
    <div class="absolute inset-x-0 bottom-12 p-4 sm:p-8 z-[20] flex flex-col items-center gap-6">
      <div class="w-full max-w-5xl transform translate-y-4 hover:translate-y-0 transition-transform duration-700 ease-out">
        <GlassContainer class="shadow-[0_40px_80px_-20px_rgba(0,0,0,0.6)] border-t-[3px] border-white/30 p-6 !rounded-[4rem]">
          <div class="flex flex-col gap-6">
            
            <div class="flex flex-col md:flex-row gap-4 items-center">
              <div class="relative flex-1 group w-full">
                <div class="absolute inset-0 bg-primary/20 blur-2xl group-focus-within:bg-primary/40 transition-all duration-500 rounded-full"></div>
                <div class="relative flex items-center bg-base-100/60 backdrop-blur-2xl border-2 border-white/10 rounded-full px-6 py-4 focus-within:border-primary/50 transition-all">
                  <ICONS.search class="text-primary mr-4 animate-pulse" size={24} />
                  <input 
                    type="text" 
                    bind:value={searchQuery}
                    placeholder="Busca misticismo, comida, arte..." 
                    class="bg-transparent border-none outline-none w-full text-base-content font-bold placeholder:text-base-content/30"
                  />
                  {#if searchQuery}
                    <button onclick={() => searchQuery = ""} class="p-1 hover:bg-base-content/10 rounded-full">
                      <ICONS.close size={20} />
                    </button>
                  {/if}
                </div>
              </div>

              <div class="flex gap-4 w-full md:w-auto">
                <ZoneSelector
                  zones={geoStore.allZones}
                  selectedZoneId={geoStore.currentZone?.id ?? ""}
                  onchange={(id) => geoStore.setZone(id)}
                />
              </div>
            </div>

            <div class="flex flex-col gap-4">
              <div class="flex gap-3 overflow-x-auto pb-1 scrollbar-hide mask-fade-right">
                {#each CATEGORIES as { key, label, Icon, color }}
                  <button
                    onclick={() => categoriaActiva = key}
                    class="flex items-center gap-2.5 px-6 py-3.5 rounded-3xl text-[14px] font-black uppercase tracking-tighter
                             flex-shrink-0 border-2 transition-all duration-500
                             {categoriaActiva === key
                      ? 'bg-primary text-primary-content border-primary shadow-xl shadow-primary/40 -translate-y-1'
                      : 'bg-base-100/20 backdrop-blur-xl text-base-content/60 border-white/10 hover:border-white/40'}"
                  >
                    <div class="p-1.5 rounded-xl bg-white/10" style="color: {categoriaActiva === key ? 'inherit' : color}">
                       <Icon size={18} strokeWidth={3} />
                    </div>
                    <span>{label}</span>
                  </button>
                {/each}
              </div>

              <div class="flex items-center gap-4 bg-base-content/5 p-2 rounded-[2.5rem] w-fit border border-white/5">
                 <span class="text-[10px] font-black uppercase tracking-widest opacity-40 ml-4">Vibe:</span>
                 <div class="flex gap-1">
                   {#each VIBES as vibe}
                     <button
                       onclick={() => vibeActiva = vibe.key}
                       class="px-4 py-2 rounded-full text-[11px] font-bold uppercase transition-all
                              {vibeActiva === vibe.key ? 'bg-base-content text-base-100 shadow-lg' : 'hover:bg-base-content/10 opacity-50'}"
                     >
                       {vibe.label}
                     </button>
                   {/each}
                 </div>
              </div>
            </div>
          </div>
        </GlassContainer>
      </div>
    </div>
  </div>

  <div class="container mx-auto px-6 mt-16 max-w-[90rem] z-[5] relative">
    <div class="flex items-end justify-between mb-12 px-4">
      <div class="space-y-2">
        <h2 class="text-6xl font-black uppercase tracking-[calc(-0.05em)] italic leading-[0.85] text-transparent bg-clip-text bg-gradient-to-br from-base-content to-base-content/40">
          Explora lo Cercano
        </h2>
        <div class="h-2 w-48 bg-primary rounded-full animate-width"></div>
      </div>
      <div class="flex flex-col items-end">
        <span class="text-[12px] font-black uppercase tracking-[0.3em] opacity-20 italic">Command Center V1</span>
        <div class="flex items-center gap-4 mt-2">
           <div class="text-right">
             <p class="text-[10px] font-bold opacity-40 leading-none uppercase">Showing</p>
             <p class="text-2xl font-black">{filteredItems.length}</p>
           </div>
           <div class="h-10 w-px bg-base-content/10"></div>
           <div class="badge badge-lg bg-primary text-primary-content h-12 px-6 border-none font-black tracking-widest">LIVE</div>
        </div>
      </div>
    </div>

    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 2xl:grid-cols-5 gap-10 pb-32 px-4">
      {#each filteredItems as item}
        <GlassCard 
          onclick={() => openBusiness(item)}
          glowColor={item.color}
          class="p-4 h-full"
        >
          <div class="relative h-60 rounded-[2rem] overflow-hidden mb-6">
             <img 
               src="https://picsum.photos/seed/{item.id}/600/600" 
               alt={item.name}
               class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-1000"
             />
             <div class="absolute inset-0 bg-gradient-to-t from-base-900 to-transparent opacity-60"></div>
             
             <div class="absolute top-4 inset-x-4 flex justify-between items-start">
                <div class="px-4 py-1.5 rounded-full bg-black/40 backdrop-blur-md border border-white/20 text-[10px] font-black uppercase tracking-widest text-white shadow-xl">
                  {item.category}
                </div>
                <div class="bg-base-100 p-2 rounded-2xl shadow-xl flex flex-col items-center">
                   <ICONS.star size={16} class="text-warning fill-warning" />
                   <span class="text-[10px] font-black mt-0.5">{item.rating.toFixed(1)}</span>
                </div>
             </div>

             <div class="absolute bottom-4 left-4">
                <span class="px-3 py-1 rounded-lg bg-primary/80 backdrop-blur-xl text-[9px] font-black uppercase text-primary-content tracking-widest">
                  {item.vibe}
                </span>
             </div>
          </div>

          <div class="px-2 pb-2 h-full flex flex-col">
            <h3 class="text-xl font-black tracking-tight leading-tight mb-2 group-hover:text-primary transition-colors line-clamp-1">{item.name}</h3>
            <div class="flex items-center gap-2 opacity-50 text-[11px] font-bold">
               <ICONS.map_pin size={12} />
               <span class="truncate">{item.address}</span>
            </div>
            
            <div class="mt-auto flex items-center justify-between border-t border-white/5 pt-4">
               <div class="flex items-center gap-2">
                  <div class="w-2 h-2 rounded-full {item.open ? 'bg-success animate-pulse' : 'bg-base-content/20'}"></div>
                  <span class="text-[10px] font-black uppercase tracking-widest opacity-40">{item.open ? 'Open Now' : 'Closed'}</span>
               </div>
               <div class="bg-primary/10 p-2 rounded-xl group-hover:bg-primary group-hover:text-primary-content transition-all duration-500">
                  <ICONS.chevron_right size={20} strokeWidth={3} />
               </div>
            </div>
          </div>
        </GlassCard>
      {/each}
    </div>
  </div>

  {#if showMagicToast}
    <div class="fixed top-10 left-1/2 -translate-x-1/2 z-[2000] animate-in fade-in zoom-in slide-in-from-top-10 duration-1000">
      <div class="alert bg-primary text-primary-content border-none shadow-[0_30px_60px_-15px_oklch(var(--p)/0.5)] flex items-center gap-4 px-8 py-5 rounded-[2rem]">
        <div class="bg-primary-content/20 p-3 rounded-full animate-bounce">
          <ICONS.info size={24} strokeWidth={3} />
        </div>
        <div>
          <h3 class="font-black text-lg uppercase tracking-tight">Kron Mode Active</h3>
          <p class="text-xs font-bold opacity-80 italic leading-tight">Proximity logic engaged. Radar scanning nearby digital auras.</p>
        </div>
      </div>
    </div>
  {/if}
</main>

<DishDetailModal
  dish={selectedDish}
  open={isDetailOpen}
  onclose={() => isDetailOpen = false}
/>

<BusinessDetailModal
  business={selectedBusiness}
  open={isBusinessModalOpen}
  onclose={() => isBusinessModalOpen = false}
/>

<style>
  :global(.mask-fade-right) {
    mask-image: linear-gradient(to right, black 85%, transparent 100%);
  }

  @keyframes width {
    from { width: 0; }
    to { width: 12rem; }
  }
  .animate-width {
    animation: width 1.5s cubic-bezier(0.16, 1, 0.3, 1) forwards;
  }
</style>
