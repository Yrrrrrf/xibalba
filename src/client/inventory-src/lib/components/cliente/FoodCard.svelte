<script lang="ts">
  interface FoodCardProps {
    id: number;
    nombre: string;
    precio: number;
    restaurante: string;
    imagen: string;
    categoria: string;
    rating: number;
    likes?: number;
    onselect?: () => void;
  }

  let {
    id,
    nombre,
    precio,
    restaurante,
    imagen,
    categoria,
    rating,
    likes = 0,
    onselect,
  }: FoodCardProps = $props();

  let liked = $state(false);
  let localLikes = $state(likes);

  function toggleLike() {
    liked = !liked;
    localLikes = liked ? localLikes + 1 : localLikes - 1;
  }

  // ── 3D Tilt action ───────────────────────────────────────────────────
  function tilt(node: HTMLElement) {
    let raf = 0;

    function onMove(e: MouseEvent) {
      cancelAnimationFrame(raf);
      raf = requestAnimationFrame(() => {
        const rect = node.getBoundingClientRect();
        const x = e.clientX - rect.left;
        const y = e.clientY - rect.top;
        const cx = rect.width / 2;
        const cy = rect.height / 2;
        const rx = ((y - cy) / cy) * -9;
        const ry = ((x - cx) / cx) * 9;
        node.style.transform = `perspective(900px) rotateX(${rx}deg) rotateY(${ry}deg) translateY(-6px) scale(1.02)`;
        node.style.transition = 'transform 0.08s ease-out';
      });
    }

    function onLeave() {
      cancelAnimationFrame(raf);
      node.style.transition = 'transform 0.5s cubic-bezier(0.23, 1, 0.32, 1)';
      node.style.transform = 'perspective(900px) rotateX(0deg) rotateY(0deg) translateY(0px) scale(1)';
    }

    node.addEventListener('mousemove', onMove);
    node.addEventListener('mouseleave', onLeave);
    return {
      destroy() {
        node.removeEventListener('mousemove', onMove);
        node.removeEventListener('mouseleave', onLeave);
      },
    };
  }

  // Category color accent map
  const categoryColor: Record<string, string> = {
    Mexicana:    'from-orange-400/20 to-red-400/10',
    Mariscos:    'from-blue-400/20 to-cyan-400/10',
    Vegetariano: 'from-green-400/20 to-emerald-400/10',
    Antojitos:   'from-yellow-400/20 to-orange-400/10',
    Bebidas:     'from-purple-400/20 to-pink-400/10',
    Postres:     'from-pink-400/20 to-rose-400/10',
  };
  const accent = $derived(categoryColor[categoria] ?? 'from-amber-400/20 to-orange-400/10');
</script>

<!-- Card wrapper con tilt 3D -->
<!-- svelte-ignore a11y_click_events_have_key_events -->
<!-- svelte-ignore a11y_no_static_element_interactions -->
<div
  use:tilt
  onclick={onselect}
  class="group relative flex flex-col
         bg-neutral-900/60 backdrop-blur-xl
         border border-white/10
         shadow-[0_8px_32px_rgba(0,0,0,0.30)]
         hover:shadow-[0_24px_48px_rgba(234,88,12,0.18)]
         rounded-3xl overflow-hidden
         cursor-pointer will-change-transform"
  style="transform-style: preserve-3d;"
>
  <!-- Gradient shimmer top accent based on category -->
  <div class="absolute inset-x-0 top-0 h-1 bg-gradient-to-r {accent} opacity-80 rounded-t-3xl"></div>

  <!-- ── IMAGEN con efecto pop-out ──────────────────────────── -->
  <figure class="relative overflow-hidden rounded-t-3xl h-48 bg-gradient-to-br {accent}">
    <img
      src={imagen}
      alt={nombre}
      class="w-full h-full object-cover
             transform-gpu
             group-hover:scale-[1.12]
             group-hover:-translate-y-2
             group-hover:drop-shadow-[0_20px_24px_rgba(0,0,0,0.35)]
             transition-all duration-700 ease-out"
      onerror={(e) => {
        const t = e.currentTarget as HTMLImageElement;
        t.src = `https://api.dicebear.com/8.x/icons/svg?seed=${id}&backgroundType=gradientLinear`;
      }}
    />

    <!-- Dark gradient overlay for text readability -->
    <div class="absolute inset-0 bg-gradient-to-t from-black/50 via-black/10 to-transparent
                opacity-0 group-hover:opacity-100 transition-opacity duration-500"></div>

    <!-- Category badge -->
    <div class="absolute top-3 left-3 z-10">
      <span class="px-2.5 py-1 text-xs font-bold rounded-full
                   bg-black/60 backdrop-blur-sm text-neutral-200 shadow-sm border border-white/10">
        {categoria}
      </span>
    </div>

    <!-- Rating badge -->
    <div class="absolute top-3 right-3 z-10 flex items-center gap-1
                px-2 py-1 rounded-full bg-black/40 backdrop-blur-sm border border-white/20">
      <span class="text-amber-400 text-xs leading-none">★</span>
      <span class="text-white text-xs font-bold">{rating}</span>
    </div>

    <!-- Hover: restaurante floats in from bottom -->
    <div class="absolute bottom-0 inset-x-0 p-3
                translate-y-full group-hover:translate-y-0
                transition-transform duration-400 ease-out z-10">
      <p class="text-white text-xs font-medium drop-shadow">🍽️ {restaurante}</p>
    </div>
  </figure>

  <!-- ── BODY ────────────────────────────────────────────────── -->
  <div class="flex flex-col flex-1 p-4 gap-2">
    <h3 class="font-bold text-neutral-100 text-[15px] leading-snug line-clamp-2">{nombre}</h3>

    <p class="text-neutral-400 text-xs flex items-center gap-1 opacity-0 group-hover:opacity-0">
      <!-- only shown in image overlay on hover -->
    </p>

    <div class="flex items-center justify-between mt-auto pt-2">
      <!-- Price -->
      <div class="flex flex-col">
        <span class="text-orange-500 font-extrabold text-xl leading-none">
          ${precio.toFixed(2)}
        </span>
        <span class="text-neutral-500 text-[10px] tracking-wide uppercase">USD</span>
      </div>

      <!-- Like button -->
      <button
        onclick={(e) => { e.stopPropagation(); toggleLike(); }}
        class="flex items-center gap-1.5 px-3 py-2 rounded-2xl
               transition-all duration-300
               {liked
                 ? 'bg-rose-500 text-white shadow-lg shadow-rose-900/20'
                 : 'bg-white/5 border border-white/10 text-neutral-400 hover:bg-rose-500/10 hover:text-rose-400'}"
        aria-label="Me gusta"
      >
        <svg
          class="h-4 w-4 transition-transform duration-300 {liked ? 'scale-125' : ''}"
          viewBox="0 0 24 24"
          fill={liked ? 'currentColor' : 'none'}
          stroke="currentColor"
          stroke-width="2"
        >
          <path stroke-linecap="round" stroke-linejoin="round"
            d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z" />
        </svg>
        <span class="text-xs font-semibold">{localLikes}</span>
      </button>
    </div>
  </div>

  <!-- Bottom shimmer glow on hover -->
  <div class="absolute inset-x-4 bottom-0 h-px bg-gradient-to-r from-transparent via-orange-400/40 to-transparent
              opacity-0 group-hover:opacity-100 transition-opacity duration-500"></div>
</div>
