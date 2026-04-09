<script lang="ts">
  import {
    HeroCarousel,
    RoleCards,
    Navbar,
    Footer,
    BottomNav,
    GlassContainer,
    GlassCard,
    ICONS,
    MerchantPreviewCard,
  } from "@sdk/ui";
  import { ThemeSelector, LanguageSelector, CurrencySelector } from "rune-lab";
  import AnimatedCounter from "$lib/components/AnimatedCounter.svelte";
  import CountdownTimer from "$lib/components/CountdownTimer.svelte";

  const merchants = [
    {
      id: "m1",
      name: "Tacos El Rey",
      category: "Food",
      rating: 4.8,
      isOpen: true,
    },
    {
      id: "m2",
      name: "Artesanías Mayas",
      category: "Craft",
      rating: 4.9,
      isOpen: true,
    },
    {
      id: "m3",
      name: "Café Ancestral",
      category: "Food",
      rating: 4.7,
      isOpen: false,
    },
    {
      id: "m4",
      name: "Hostal Xibalbá",
      category: "Service",
      rating: 4.6,
      isOpen: true,
    },
    {
      id: "m5",
      name: "Misticismo Maya",
      category: "Mystic",
      rating: 5.0,
      isOpen: true,
    },
    {
      id: "m6",
      name: "Ruta del Cacao",
      category: "Service",
      rating: 4.5,
      isOpen: true,
    },
  ];

  const flags = [
    { name: "Mexico", code: "🇲🇽", theme: "mexico", color: "#006341" },
    { name: "Japan", code: "🇯🇵", theme: "japan", color: "#BC002D" },
    { name: "Brazil", code: "🇧🇷", theme: "brazil", color: "#009739" },
    { name: "Germany", code: "🇩🇪", theme: "germany", color: "#000000" },
    { name: "Saudi Arabia", code: "🇸🇦", theme: "saudi-arabia", color: "#006C35" },
  ];
</script>

<div
  class="min-h-screen bg-transparent text-base-content flex flex-col selection:bg-primary/30 relative z-0"
>
  <!-- Componente centralizado de Animación y Tramado -->
  <ThemeSelector />
  <LanguageSelector />
  <CurrencySelector />

  <!-- Componente centralizado de Barra Superior y Perfil -->
  <Navbar />

  <!-- Área de Contenido Principal -->
  <div class="flex-1 flex flex-col pb-24 md:pb-0 relative z-10">
    <div class="flex flex-col w-full gap-24">
      <div>
        <HeroCarousel />
        
        <!-- 3.1.1 Live Pulse Stats Bar -->
        <div class="container mx-auto px-6 -mt-12 relative z-20">
          <GlassContainer class="!rounded-[3rem] shadow-[0_30px_60px_-15px_rgba(0,0,0,0.3)] border border-white/10 p-8">
            <div class="grid grid-cols-2 md:grid-cols-4 gap-8">
              {#each [ 
                { label: "Negocios Activos", target: 847, Icon: ICONS.store }, 
                { label: "Turistas Conectados", target: 12430, Icon: ICONS.user }, 
                { label: "Platillos Disponibles", target: 3562, Icon: ICONS.cat_mexican }, 
                { label: "Países Representados", target: 48, Icon: ICONS.nav_discover } 
              ] as { label, target, Icon }}
                <div class="flex flex-col items-center md:items-start gap-2">
                  <div class="flex items-center gap-3 text-primary">
                    <Icon size={24} strokeWidth={3} />
                    <AnimatedCounter {target} class="text-3xl md:text-4xl font-black italic tracking-tighter" />
                  </div>
                  <span class="text-[10px] font-black uppercase tracking-[0.2em] opacity-40">{label}</span>
                </div>
              {/each}
            </div>
          </GlassContainer>
        </div>
      </div>

      <RoleCards />

      <!-- 3.1.2 "How It Works" Triple-Step Section -->
      <section class="container mx-auto px-6 py-12">
        <div class="text-center mb-16 space-y-4">
          <h2 class="text-4xl md:text-6xl font-black uppercase tracking-tight italic text-transparent bg-clip-text bg-gradient-to-br from-base-content to-base-content/40">
            ¿Cómo Funciona?
          </h2>
          <div class="h-1.5 w-48 bg-primary rounded-full mx-auto animate-width"></div>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-12 relative">
          <!-- Connecting line (desktop) -->
          <div class="hidden md:block absolute top-1/2 left-0 w-full h-px border-t-2 border-dashed border-primary/20 -translate-y-16"></div>
          
          {#each [
            { step: 1, title: "Explora", desc: "Encuentra lo mejor cerca de ti con nuestro radar de misticismo.", Icon: ICONS.search },
            { step: 2, title: "Elige", desc: "Filtra por vibe, categoría o país y guarda tus favoritos.", Icon: ICONS.star },
            { step: 3, title: "Visita", desc: "Navega hasta el local y vive una experiencia única.", Icon: ICONS.map_pin }
          ] as { step, title, desc, Icon }}
            <GlassCard class="relative p-10 flex flex-col items-center text-center !rounded-[2.5rem]" enable3D={true}>
              <div class="w-16 h-16 rounded-full bg-primary/20 text-primary flex items-center justify-center text-2xl font-black mb-6 border border-primary/20">
                {step}
              </div>
              <Icon size={48} class="text-primary mb-6 animate-pulse" strokeWidth={1.5} />
              <h3 class="text-2xl font-black uppercase italic mb-4">{title}</h3>
              <p class="text-sm opacity-60 leading-relaxed">{desc}</p>
            </GlassCard>
          {/each}
        </div>
      </section>

      <!-- 3.1.3 World Cup Countdown Timer -->
      <section class="w-full py-24 bg-neutral/10 relative overflow-hidden">
        <div class="absolute inset-0 bg-gradient-to-br from-primary/5 via-transparent to-secondary/5"></div>
        <div class="container mx-auto px-6 relative z-10 text-center">
          <div class="mb-12 space-y-4">
             <h2 class="text-4xl md:text-5xl font-black uppercase tracking-tighter italic">
               El mundo viene a <span class="text-primary">México</span>
             </h2>
             <p class="text-xl font-bold opacity-60 italic">¿Tu negocio está listo para la fiesta?</p>
          </div>
          
          <CountdownTimer />
          
          <div class="mt-16">
            <a href="/merchant/register" class="btn btn-primary btn-lg rounded-full px-12 font-black tracking-widest uppercase shadow-xl shadow-primary/30 hover:scale-105 active:scale-95 transition-all">
              Registra tu Comercio
            </a>
          </div>
        </div>
      </section>

      <!-- 3.1.4 Featured Merchants Carousel -->
      <section class="container mx-auto px-6 py-12">
        <div class="flex items-end justify-between mb-12">
          <div class="space-y-4">
            <h2 class="text-4xl md:text-6xl font-black uppercase tracking-tight italic text-transparent bg-clip-text bg-gradient-to-br from-base-content to-base-content/40">
              Negocios Destacados
            </h2>
            <div class="h-1.5 w-48 bg-primary rounded-full animate-width"></div>
          </div>
        </div>
        
        <div class="flex gap-8 overflow-x-auto pb-12 scrollbar-hide snap-x snap-mandatory mask-fade-right -mx-4 px-4">
          {#each merchants as merchant}
            <MerchantPreviewCard {merchant} />
          {/each}
        </div>
      </section>

      <!-- 3.1.5 Cultural Adaptivity Showcase -->
      <section class="w-full bg-neutral py-24 text-neutral-content relative overflow-hidden">
         <div class="absolute inset-0 opacity-10 pointer-events-none">
            <!-- Grid Pattern -->
            <div class="absolute inset-0" style="background-image: radial-gradient(circle at 1px 1px, white 1px, transparent 0); background-size: 40px 40px;"></div>
         </div>
         
         <div class="container mx-auto px-6 relative z-10">
            <div class="text-center mb-16">
               <h2 class="text-4xl md:text-6xl font-black uppercase tracking-tight italic text-transparent bg-clip-text bg-gradient-to-br from-primary to-secondary">
                 Tu País, Tu Experiencia
               </h2>
               <p class="mt-4 opacity-60 font-bold italic tracking-widest uppercase text-xs">Adaptación Cultural Dinámica</p>
            </div>

            <div class="grid grid-cols-2 md:grid-cols-5 gap-8">
               {#each flags as flag}
                 <GlassCard class="p-8 flex flex-col items-center gap-6 !rounded-[2rem] border-white/5 hover:border-white/20 transition-all group" enable3D={true}>
                    <div class="text-6xl group-hover:scale-125 transition-transform duration-500 drop-shadow-2xl">{flag.code}</div>
                    <div class="text-center">
                       <p class="font-black uppercase tracking-widest text-[10px] mb-2">{flag.name}</p>
                       <div class="w-full h-1 rounded-full opacity-40" style="background-color: {flag.color}"></div>
                    </div>
                 </GlassCard>
               {/each}
            </div>
         </div>
      </section>

      <!-- 3.1.6 Testimonials -->
      <section class="container mx-auto px-6 py-24 mb-12">
        <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
           {#each [
             { name: "María G.", role: "Taquera en CDMX", quote: "Xibalbá puso mi negocio en el mapa de los turistas. ¡Mis ventas subieron un 40%!", color: "primary" },
             { name: "John D.", role: "Turista de USA", quote: "Finding local gems was never this easy. The cultural themes make me feel at home.", color: "secondary" },
             { name: "Chen W.", role: "Guía Turístico", quote: "La mejor herramienta para recomendar lugares auténticos a mis grupos.", color: "accent" }
           ] as t}
             <GlassCard class="p-10 !rounded-[2.5rem] border-l-4 border-{t.color}" enable3D={true}>
                <div class="flex items-center gap-4 mb-6">
                   <div class="w-12 h-12 rounded-full bg-{t.color}/20 flex items-center justify-center text-primary">
                      <ICONS.user size={24} />
                   </div>
                   <div>
                      <p class="font-black italic">{t.name}</p>
                      <p class="text-[10px] uppercase font-black tracking-widest opacity-40">{t.role}</p>
                   </div>
                </div>
                <p class="text-lg font-bold italic opacity-80 leading-relaxed">"{t.quote}"</p>
             </GlassCard>
           {/each}
        </div>
      </section>

      <!-- Componente centralizado de Pie de Página -->
      <Footer />
    </div>
  </div>
</div>

<!-- Mobile Floating Navigation -->
<BottomNav />

<!-- </RuneProvider> -->

<style>
  :global(html) {
    scroll-behavior: smooth;
  }
</style>
