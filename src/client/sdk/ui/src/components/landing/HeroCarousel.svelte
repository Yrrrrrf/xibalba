<script lang="ts">
  import { fade } from 'svelte/transition';
  import { onMount } from 'svelte';

  let currentImage = $state(0);
  const images = [
    '/images/carousel-1.png',
    '/images/carousel-2.png',
    '/images/carousel-3.png'
  ];

  onMount(() => {
    if (typeof window !== 'undefined') {
      const interval = setInterval(() => {
        currentImage = (currentImage + 1) % images.length;
      }, 5000);
      return () => clearInterval(interval);
    }
  });
</script>

<section class="min-h-screen relative overflow-hidden -mt-[72px] bg-black selection:bg-primary/30">
  
  {#each images as image, i}
    {#if currentImage === i}
      <!-- GLOBAL BACKGROUND -->
      <div 
        in:fade={{ duration: 1500 }} 
        out:fade={{ duration: 1500 }}
        class="absolute inset-0 bg-cover bg-center bg-no-repeat z-0 transform scale-105"
        style="background-image: url('{image}'); background-attachment: fixed;"
      ></div>
    {/if}
  {/each}

  <div class="relative w-full min-h-screen flex items-center">
    
    <!-- LAYER 1: Right Side (Underneath the blur, no blur here). Just the White Text. -->
    <div class="absolute inset-0 flex flex-col justify-center items-center z-10 pointer-events-none w-full">
      <div class="flex flex-col items-center md:items-start text-center md:text-left translate-x-0 w-full max-w-6xl mx-auto px-4 md:px-0 md:translate-x-[-2vw]">
        <h2 class="text-white font-black uppercase tracking-[0.4em] md:tracking-[0.5em] text-[8px] sm:text-[10px] md:text-sm mb-2 drop-shadow-xl opacity-90">App Oficial</h2>
        <h1 class="text-[13vw] font-black leading-[0.8] text-white tracking-tighter drop-shadow-2xl">XIBALBÁ</h1>
        <h1 class="text-[13vw] font-black leading-[0.8] text-white tracking-widest drop-shadow-2xl mt-2">MUNDIAL</h1>
      </div>
    </div>

    <!-- LAYER 2: Left Side (Glass Blur Panel) -->
    <!-- En móviles cubre el 60% para partir la palabra a la mitad, en desktop el 45% -->
    <div class="absolute inset-y-0 left-0 w-[60%] md:w-[45%] bg-[#081210]/40 backdrop-blur-[24px] md:backdrop-blur-[32px] z-20 flex flex-col justify-center items-center overflow-hidden shadow-2xl shadow-black border-r border-white/10">
      
      <!-- LAYER 3: Magic Cut-out Text EXACTLY matching the white text position -->
      <div class="absolute inset-0 w-[100vw] flex flex-col justify-center items-center pointer-events-none">
        {#each images as image, i}
          {#if currentImage === i}
             <div 
                in:fade={{ duration: 1500 }} 
                out:fade={{ duration: 1500 }}
                class="absolute inset-0 flex flex-col justify-center items-center w-full"
             >
               <div class="flex flex-col items-center md:items-start text-center md:text-left translate-x-0 w-full max-w-6xl mx-auto px-4 md:px-0 md:translate-x-[-2vw]">
                 <h2 class="text-transparent font-black uppercase tracking-[0.4em] md:tracking-[0.5em] text-[8px] sm:text-[10px] md:text-sm mb-2">App Oficial</h2>
                 <h1 class="text-[13vw] font-black leading-[0.8] tracking-tighter bg-cover bg-center" style="background-image: url('{image}'); background-attachment: fixed; -webkit-background-clip: text; color: transparent; -webkit-text-fill-color: transparent;">XIBALBÁ</h1>
                 <h1 class="text-[13vw] font-black leading-[0.8] tracking-widest bg-cover bg-center mt-2" style="background-image: url('{image}'); background-attachment: fixed; -webkit-background-clip: text; color: transparent; -webkit-text-fill-color: transparent;">MUNDIAL</h1>
               </div>
             </div>
          {/if}
        {/each}
      </div>
    </div>

    <!-- LAYER 4: Foreground Content (Subtitle, buttons) -->
    <!-- padding drásticamente ajustado en móviles para no encimarse -->
    <div class="absolute inset-x-0 bottom-[15%] md:inset-x-auto md:inset-y-0 md:left-0 md:w-[45%] z-30 flex flex-col justify-end px-6 md:p-16 lg:p-24 pointer-events-none">
      <div class="pointer-events-auto max-w-[280px] md:max-w-sm ml-4 md:ml-0 md:pb-12 border-l-2 md:border-l-0 border-primary pl-4 md:pl-0">
        <p class="text-white/90 md:text-white font-medium text-[11px] sm:text-xs md:text-[17px] leading-snug md:leading-relaxed mb-4 md:mb-6 drop-shadow-md">
           Una plataforma diseñada para fusionar el frenesí del <span class="text-primary font-bold">fútbol</span> con la riqueza oculta de la <span class="text-secondary font-bold">cultura local</span>.
        </p>
        <a href="#explore" class="text-white font-black tracking-[0.2em] text-[9px] md:text-xs uppercase flex items-center gap-2 md:gap-4 hover:text-primary transition-colors duration-300 w-max group">
          Descubrir
          <div class="w-6 md:w-8 h-[2px] bg-white group-hover:w-12 md:group-hover:w-16 group-hover:bg-primary transition-all duration-300"></div>
        </a>
      </div>
    </div>

    <!-- LAYER 5: Right Side Controls -->
    <!-- Cuadrados más pequeños y pegados para móviles -->
    <div class="absolute right-0 bottom-0 md:right-8 md:bottom-12 z-30 flex pointer-events-auto">
      <button aria-label="Previous image" onclick={() => { currentImage = (currentImage - 1 + images.length) % images.length; }} class="w-12 h-12 md:w-16 md:h-16 bg-[#1a1c1a]/80 hover:bg-[#2b332c] flex items-center justify-center text-white transition-colors duration-300 backdrop-blur-sm">
        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 md:h-5 md:w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18" /></svg>
      </button>
      <button aria-label="Next image" onclick={() => { currentImage = (currentImage + 1) % images.length; }} class="w-12 h-12 md:w-16 md:h-16 bg-[#2b332c]/90 hover:bg-[#3d493e] flex items-center justify-center text-white transition-colors duration-300 backdrop-blur-sm">
        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 md:h-5 md:w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 5l7 7m0 0l-7 7m7-7H3" /></svg>
      </button>
    </div>

    <!-- Carousel Nav Dots vertical -->
    <div class="absolute right-6 md:right-12 top-1/2 -translate-y-1/2 z-30 flex flex-col gap-4 md:gap-6 pointer-events-auto">
      {#each images as _, i}
        <button 
           aria-label="Ir a imagen {i+1}"
           onclick={() => currentImage = i}
           class="w-[2px] md:w-[3px] transition-all duration-500 {currentImage === i ? 'bg-primary h-8 md:h-12 shadow-[0_0_10px_rgba(var(--primary),0.5)]' : 'bg-white/30 h-3 md:h-4 hover:bg-white/60'} rounded-full"
        ></button>
      {/each}
    </div>

  </div>
</section>
