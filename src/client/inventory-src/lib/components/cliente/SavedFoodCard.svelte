<script lang="ts">
  interface SavedFoodCardProps {
    id: number;
    nombre: string;
    precio: number;
    restaurante: string;
    imagen: string;
    categoria: string;
    onremove?: (id: number) => void;
  }

  let { id, nombre, precio, restaurante, imagen, categoria, onremove }: SavedFoodCardProps = $props();
</script>

<div class="flex items-center gap-4 p-3 group cursor-pointer hover:bg-white/5 rounded-2xl transition-colors">
  <!-- Thumbnail with scale -->
  <div class="relative w-16 h-16 rounded-2xl overflow-hidden flex-shrink-0 shadow-md
              group-hover:shadow-lg transition-shadow duration-300 border border-white/10">
    <img
      src={imagen}
      alt={nombre}
      class="w-full h-full object-cover
             group-hover:scale-110 transition-transform duration-500 ease-out"
      onerror={(e) => {
        const t = e.currentTarget as HTMLImageElement;
        t.src = `https://api.dicebear.com/8.x/icons/svg?seed=${id}`;
      }}
    />
  </div>

  <!-- Info -->
  <div class="flex-1 min-w-0">
    <p class="font-bold text-neutral-100 text-sm truncate">{nombre}</p>
    <p class="text-neutral-400 text-xs truncate mt-0.5">🍽️ {restaurante}</p>
    <span class="inline-block mt-1 px-2 py-0.5 rounded-full text-[9px] font-bold uppercase
                 bg-orange-500/10 text-orange-400 border border-orange-500/20">
      {categoria}
    </span>
  </div>

  <!-- Price + remove -->
  <div class="flex flex-col items-end gap-2 flex-shrink-0">
    <span class="text-orange-400 font-extrabold text-sm">${precio.toFixed(2)}</span>
    {#if onremove}
      <button
        onclick={() => onremove(id)}
        class="w-7 h-7 rounded-xl flex items-center justify-center
               text-neutral-500 hover:text-rose-400 hover:bg-rose-500/10
               transition-all duration-200"
        aria-label="Eliminar guardado"
      >
        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
            d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
        </svg>
      </button>
    {/if}
  </div>
</div>
