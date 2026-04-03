<script lang="ts">
  interface Producto {
    id: number;
    nombre: string;
    precio: number;
    categoria: string;
    ventas: number;
    disponible: boolean;
  }

  interface Props {
    productos?: Producto[];
  }

  let { productos = [] }: Props = $props();

  const totalVentas = $derived(productos.reduce((acc, p) => acc + p.ventas, 0));
  const disponibles = $derived(productos.filter((p) => p.disponible).length);
</script>

<div class="space-y-4">
  <!-- Resumen -->
  <div class="stats stats-horizontal shadow-xl w-full bg-neutral-900/60 backdrop-blur-xl border border-white/10">
    <div class="stat place-items-center">
      <div class="stat-title text-[10px] uppercase font-bold tracking-widest text-neutral-500">Total Platillos</div>
      <div class="stat-value text-orange-400 text-2xl">{productos.length}</div>
    </div>
    <div class="stat place-items-center border-l border-white/5">
      <div class="stat-title text-[10px] uppercase font-bold tracking-widest text-neutral-500">Disponibles</div>
      <div class="stat-value text-emerald-400 text-2xl">{disponibles}</div>
    </div>
    <div class="stat place-items-center border-l border-white/5">
      <div class="stat-title text-[10px] uppercase font-bold tracking-widest text-neutral-500">Ventas Totales</div>
      <div class="stat-value text-cyan-400 text-2xl">{totalVentas}</div>
    </div>
  </div>

  <!-- Grid de productos -->
  {#if productos.length === 0}
    <div class="text-center py-12 text-base-content/40">
      <div class="text-5xl mb-3">🍽️</div>
      <p>No tienes platillos registrados aún.</p>
      <p class="text-sm">¡Añade tu primer platillo!</p>
    </div>
  {:else}
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
      {#each productos as prod}
        <div class="card bg-neutral-900/40 backdrop-blur-md border border-white/10 shadow-lg hover:shadow-orange-500/10 transition-all duration-300 hover:-translate-y-1">
          <div class="card-body p-4">
            <div class="flex items-start justify-between gap-2">
              <h3 class="font-bold text-neutral-100 text-sm leading-tight">{prod.nombre}</h3>
              <div class="badge {prod.disponible ? 'badge-success' : 'badge-ghost'} badge-sm flex-shrink-0 font-bold uppercase text-[9px]">
                {prod.disponible ? 'Activo' : 'Oculto'}
              </div>
            </div>
            <p class="text-xs text-neutral-400">{prod.categoria}</p>

            <div class="flex items-center justify-between mt-3">
              <span class="text-orange-400 font-extrabold">${prod.precio.toFixed(2)}</span>
              <span class="text-[10px] text-neutral-500 flex items-center gap-1 font-bold uppercase">
                📦 {prod.ventas} ventas
              </span>
            </div>

            <div class="card-actions justify-end mt-2">
              <button class="btn btn-xs btn-outline btn-warning border-orange-500/20 text-orange-400 hover:bg-orange-500/10">Editar</button>
              <button class="btn btn-xs btn-outline btn-error border-rose-500/20 text-rose-400 hover:bg-rose-500/10">Pausar</button>
            </div>
          </div>
        </div>
      {/each}
    </div>
  {/if}
</div>
