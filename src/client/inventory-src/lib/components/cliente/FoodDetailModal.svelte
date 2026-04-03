<script lang="ts">
  import MapView from "$lib/components/ui/MapView.svelte";

  interface Nutricion {
    calorias: number;
    grasas: number;
    proteinas: number;
    carbohidratos: number;
  }

  interface Comercio {
    id: number;
    nombre: string;
    categoria: string;
    direccion: string;
    rating: number;
    lat: number;
    lng: number;
    abierto: boolean;
  }

  interface Platillo {
    id: number;
    nombre: string;
    precio: number;
    restaurante: string;
    imagen: string;
    categoria: string;
    rating: number;
    likes?: number;
    descripcion?: string;
    ingredientes?: string[];
    nutricion?: Nutricion;
    comercio?: Comercio;
  }

  interface Props {
    platillo: Platillo | null;
    open: boolean;
    onclose: () => void;
  }

  let { platillo, open, onclose }: Props = $props();

  const categoryColor: Record<string, string> = {
    Mexicana:    'from-orange-500 to-red-500',
    Mariscos:    'from-blue-500 to-cyan-500',
    Vegetariano: 'from-green-500 to-emerald-500',
    Antojitos:   'from-yellow-500 to-orange-500',
    Bebidas:     'from-purple-500 to-pink-500',
    Postres:     'from-pink-500 to-rose-500',
  };

  const accent = $derived(platillo ? (categoryColor[platillo.categoria] ?? 'from-orange-500 to-amber-500') : '');

  function handleBackdrop(e: MouseEvent) {
    if (e.target === e.currentTarget) onclose();
  }

  function handleKey(e: KeyboardEvent) {
    if (e.key === 'Escape') onclose();
  }
</script>

<svelte:window onkeydown={handleKey} />

{#if open && platillo}
  <!-- Backdrop -->
  <!-- svelte-ignore a11y_click_events_have_key_events -->
  <!-- svelte-ignore a11y_no_static_element_interactions -->
  <div
    class="fixed inset-0 z-[1000] flex items-center justify-center p-4
           bg-black/70 backdrop-blur-sm"
    onclick={handleBackdrop}
  >
    <!-- Modal Panel -->
    <div
      class="relative w-full max-w-3xl max-h-[92vh] overflow-y-auto
             bg-neutral-950/95 backdrop-blur-2xl
             border border-white/10
             rounded-3xl shadow-[0_32px_80px_rgba(0,0,0,0.6)]
             flex flex-col"
    >
      <!-- ── HERO IMAGE ─────────────────────────────────── -->
      <div class="relative h-64 sm:h-72 flex-shrink-0 overflow-hidden rounded-t-3xl">
        <img
          src={platillo.imagen}
          alt={platillo.nombre}
          class="w-full h-full object-cover"
          onerror={(e) => {
            const t = e.currentTarget as HTMLImageElement;
            t.src = `https://api.dicebear.com/8.x/icons/svg?seed=${platillo!.id}&backgroundType=gradientLinear`;
          }}
        />
        <!-- Gradient overlay -->
        <div class="absolute inset-0 bg-gradient-to-t from-neutral-950 via-neutral-950/40 to-transparent"></div>

        <!-- Top accent bar -->
        <div class="absolute top-0 inset-x-0 h-1 bg-gradient-to-r {accent}"></div>

        <!-- Close button -->
        <button
          onclick={onclose}
          class="absolute top-4 right-4 z-10
                 w-9 h-9 rounded-full
                 bg-black/50 backdrop-blur-md border border-white/20
                 flex items-center justify-center
                 text-neutral-300 hover:text-white hover:bg-black/70
                 transition-all duration-200"
          aria-label="Cerrar"
        >
          <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">
            <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
          </svg>
        </button>

        <!-- Category & Rating badges -->
        <div class="absolute top-4 left-4 flex gap-2">
          <span class="px-2.5 py-1 text-[10px] font-bold uppercase tracking-widest rounded-full
                       bg-black/60 backdrop-blur-sm text-neutral-200 border border-white/10">
            {platillo.categoria}
          </span>
        </div>

        <!-- Name + price over image bottom -->
        <div class="absolute bottom-0 inset-x-0 p-5">
          <h2 class="text-2xl font-extrabold text-white tracking-tight leading-tight mb-1">
            {platillo.nombre}
          </h2>
          <div class="flex items-center gap-3">
            <span class="text-orange-400 font-extrabold text-xl">
              ${platillo.precio.toFixed(2)} <span class="text-xs font-normal text-neutral-400">USD</span>
            </span>
            <span class="flex items-center gap-1 px-2 py-0.5 rounded-full bg-amber-400/10 border border-amber-400/20 text-[11px] font-bold text-amber-400">
              ★ {platillo.rating}
            </span>
          </div>
        </div>
      </div>

      <!-- ── CONTENT ─────────────────────────────────────── -->
      <div class="flex flex-col gap-6 p-5 sm:p-6">

        <!-- Description -->
        {#if platillo.descripcion}
          <p class="text-neutral-400 text-sm leading-relaxed italic border-l-2 border-orange-500/40 pl-3">
            {platillo.descripcion}
          </p>
        {/if}

        <!-- Nutrition + Ingredients Grid -->
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">

          <!-- Nutrition Panel -->
          {#if platillo.nutricion}
            <div class="bg-neutral-900/60 border border-white/8 rounded-2xl p-4">
              <p class="text-[10px] font-bold uppercase tracking-widest text-orange-400 mb-3">
                📊 Información Nutricional
              </p>
              <div class="grid grid-cols-2 gap-3">
                {#each [
                  { label: 'Calorías', value: platillo.nutricion.calorias, unit: 'kcal', color: 'text-orange-400' },
                  { label: 'Proteínas', value: platillo.nutricion.proteinas, unit: 'g', color: 'text-blue-400' },
                  { label: 'Grasas', value: platillo.nutricion.grasas, unit: 'g', color: 'text-yellow-400' },
                  { label: 'Carbohidratos', value: platillo.nutricion.carbohidratos, unit: 'g', color: 'text-green-400' },
                ] as stat}
                  <div class="bg-neutral-800/50 rounded-xl p-3 text-center">
                    <p class="text-[10px] text-neutral-500 uppercase tracking-wider mb-1">{stat.label}</p>
                    <p class="font-extrabold text-lg {stat.color} leading-none">{stat.value}</p>
                    <p class="text-[10px] text-neutral-600">{stat.unit}</p>
                  </div>
                {/each}
              </div>
            </div>
          {/if}

          <!-- Ingredients Panel -->
          {#if platillo.ingredientes && platillo.ingredientes.length > 0}
            <div class="bg-neutral-900/60 border border-white/8 rounded-2xl p-4">
              <p class="text-[10px] font-bold uppercase tracking-widest text-orange-400 mb-3">
                🧂 Ingredientes
              </p>
              <div class="flex flex-wrap gap-1.5">
                {#each platillo.ingredientes as ing}
                  <span class="px-2.5 py-1 rounded-full text-[11px] font-medium
                               bg-white/5 border border-white/10 text-neutral-300">
                    {ing}
                  </span>
                {/each}
              </div>
            </div>
          {/if}
        </div>

        <!-- Establishment Info -->
        {#if platillo.comercio}
          <div class="bg-neutral-900/60 border border-white/8 rounded-2xl p-4">
            <p class="text-[10px] font-bold uppercase tracking-widest text-orange-400 mb-3">
              🏪 Establecimiento
            </p>
            <div class="flex items-start justify-between gap-4">
              <div>
                <p class="font-bold text-neutral-100 text-sm">{platillo.comercio.nombre}</p>
                <p class="text-neutral-500 text-xs mt-0.5">📍 {platillo.comercio.direccion}</p>
                <p class="text-neutral-500 text-xs mt-0.5">🍽️ {platillo.comercio.categoria}</p>
              </div>
              <div class="flex flex-col items-end gap-1.5">
                <span class="flex items-center gap-1 text-amber-400 text-xs font-bold">
                  ★ {platillo.comercio.rating}
                </span>
                <span class="px-2.5 py-0.5 rounded-full text-[10px] font-bold uppercase tracking-wider
                             {platillo.comercio.abierto
                               ? 'bg-emerald-500/10 text-emerald-400 border border-emerald-500/20'
                               : 'bg-neutral-700/40 text-neutral-400 border border-neutral-600/30'}">
                  {platillo.comercio.abierto ? '● Abierto' : '● Cerrado'}
                </span>
              </div>
            </div>
          </div>
        {/if}

        <!-- Mini Map -->
        {#if platillo.comercio}
          <div class="rounded-2xl overflow-hidden border border-white/10 shadow-xl" style="height: 260px;">
            <MapView
              comercios={[platillo.comercio]}
              height="260px"
              showUserLocation={true}
            />
          </div>
        {/if}

        <!-- Action Buttons -->
        <div class="flex gap-3 pb-1">
          <button
            class="flex-1 py-3 rounded-2xl font-bold text-[13px] uppercase tracking-wider
                   bg-orange-500 hover:bg-orange-600 text-white
                   shadow-lg shadow-orange-900/20 transition-all duration-200 hover:-translate-y-0.5"
          >
            🛒 Ordenar ahora
          </button>
          <button
            onclick={onclose}
            class="px-5 py-3 rounded-2xl font-bold text-[13px] uppercase tracking-wider
                   bg-white/5 border border-white/10 text-neutral-400
                   hover:bg-white/10 hover:text-neutral-200
                   transition-all duration-200"
          >
            Cerrar
          </button>
        </div>
      </div>
    </div>
  </div>
{/if}
