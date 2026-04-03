<script lang="ts">
  interface PlaceCardProps {
    id: number;
    nombre: string;
    tipo: string;
    descripcion: string;
    imagen: string;
    direccion: string;
    rating?: number;
    precio?: string; // "Gratis", "$120/noche", etc.
    distancia?: string;
    abierto?: boolean;
    horario?: string;
    tags?: string[];
    colorAccent?: string; // Tailwind gradient classes
    emoji?: string;
    onselect?: () => void;
  }

  let {
    id,
    nombre,
    tipo,
    descripcion,
    imagen,
    direccion,
    rating,
    precio,
    distancia,
    abierto = true,
    horario,
    tags = [],
    colorAccent = 'from-blue-400/20 to-indigo-400/10',
    emoji = '📍',
    onselect,
  }: PlaceCardProps = $props();

  // 3D Tilt action
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
        const rx = ((y - cy) / cy) * -7;
        const ry = ((x - cx) / cx) * 7;
        node.style.transform = `perspective(900px) rotateX(${rx}deg) rotateY(${ry}deg) translateY(-4px) scale(1.01)`;
        node.style.transition = 'transform 0.08s ease-out';
      });
    }
    function onLeave() {
      cancelAnimationFrame(raf);
      node.style.transition = 'transform 0.5s cubic-bezier(0.23,1,0.32,1)';
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
</script>

<!-- svelte-ignore a11y_click_events_have_key_events -->
<!-- svelte-ignore a11y_no_static_element_interactions -->
<div
  use:tilt
  onclick={onselect}
  class="group relative flex flex-col
         bg-neutral-900/60 backdrop-blur-xl
         border border-white/10
         shadow-[0_8px_32px_rgba(0,0,0,0.30)]
         hover:shadow-[0_24px_48px_rgba(99,102,241,0.15)]
         rounded-3xl overflow-hidden
         cursor-pointer will-change-transform"
  style="transform-style: preserve-3d;"
>
  <!-- Top accent line -->
  <div class="absolute inset-x-0 top-0 h-1 bg-gradient-to-r {colorAccent} opacity-80 rounded-t-3xl"></div>

  <!-- Image -->
  <figure class="relative overflow-hidden rounded-t-3xl h-44 bg-gradient-to-br {colorAccent}">
    <img
      src={imagen}
      alt={nombre}
      class="w-full h-full object-cover transform-gpu
             group-hover:scale-[1.10] group-hover:-translate-y-1
             transition-all duration-700 ease-out"
      onerror={(e) => {
        const t = e.currentTarget as HTMLImageElement;
        t.src = `https://api.dicebear.com/8.x/icons/svg?seed=${id}&backgroundType=gradientLinear`;
      }}
    />
    <!-- Overlay on hover -->
    <div class="absolute inset-0 bg-gradient-to-t from-black/60 via-black/10 to-transparent
                opacity-0 group-hover:opacity-100 transition-opacity duration-500"></div>

    <!-- Type badge top-left -->
    <div class="absolute top-3 left-3 z-10">
      <span class="px-2.5 py-1 text-xs font-bold rounded-full
                   bg-black/60 backdrop-blur-sm text-neutral-200 border border-white/10">
        {emoji} {tipo}
      </span>
    </div>

    <!-- Open/Closed badge top-right -->
    <div class="absolute top-3 right-3 z-10">
      <span class="px-2 py-1 rounded-full text-[10px] font-bold uppercase backdrop-blur-sm border
                   {abierto
                     ? 'bg-emerald-500/20 text-emerald-300 border-emerald-400/30'
                     : 'bg-neutral-700/60 text-neutral-400 border-neutral-500/30'}">
        {abierto ? '● Abierto' : '● Cerrado'}
      </span>
    </div>
  </figure>

  <!-- Body -->
  <div class="flex flex-col flex-1 p-4 gap-2">
    <h3 class="font-bold text-neutral-100 text-[15px] leading-snug line-clamp-1">{nombre}</h3>
    <p class="text-neutral-500 text-xs leading-relaxed line-clamp-2">{descripcion}</p>

    <!-- Address & Distance -->
    <div class="flex items-center gap-1.5 text-neutral-500 text-[11px] mt-0.5">
      <span>📍</span>
      <span class="line-clamp-1">{direccion}</span>
      {#if distancia}
        <span class="ml-auto flex-shrink-0 text-orange-400 font-semibold">{distancia}</span>
      {/if}
    </div>

    <!-- Tags -->
    {#if tags.length > 0}
      <div class="flex flex-wrap gap-1 mt-1">
        {#each tags.slice(0, 3) as tag}
          <span class="px-2 py-0.5 rounded-full text-[10px] font-medium
                       bg-white/5 border border-white/10 text-neutral-400">
            {tag}
          </span>
        {/each}
      </div>
    {/if}

    <!-- Footer: Rating + Price -->
    <div class="flex items-center justify-between mt-auto pt-2">
      <div class="flex items-center gap-1">
        {#if rating}
          <span class="text-amber-400 text-xs">★</span>
          <span class="text-neutral-300 text-xs font-bold">{rating}</span>
        {/if}
        {#if horario}
          <span class="text-neutral-600 text-[10px] ml-2">🕐 {horario}</span>
        {/if}
      </div>
      {#if precio}
        <span class="text-sm font-extrabold
                     {precio === 'Gratis'
                       ? 'text-emerald-400'
                       : 'text-orange-400'}">
          {precio}
        </span>
      {/if}
    </div>
  </div>

  <!-- Bottom shimmer on hover -->
  <div class="absolute inset-x-4 bottom-0 h-px bg-gradient-to-r from-transparent via-indigo-400/40 to-transparent
              opacity-0 group-hover:opacity-100 transition-opacity duration-500"></div>
</div>
