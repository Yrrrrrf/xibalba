<script lang="ts">
  import { Utensils, Trash2 } from 'lucide-svelte';
  import { type Dish } from '@sdk/core';
  import { CategoryBadge, PriceTag, ImageWithFallback } from '../primitives/mod.ts';

  interface Props {
    dish: Dish;
    onremove?: (id: string) => void;
  }

  let { dish, onremove }: Props = $props();
</script>

<div class="flex items-center gap-4 p-3 group cursor-pointer hover:bg-white/5 rounded-2xl transition-colors">
  <!-- Thumbnail with scale -->
  <div class="relative w-16 h-16 rounded-2xl overflow-hidden flex-shrink-0 shadow-md
              group-hover:shadow-lg transition-shadow duration-300 border border-white/10">
    <ImageWithFallback
      src={dish.image_url}
      alt={dish.name}
      seed={dish.id}
      class="w-full h-full object-cover
             group-hover:scale-110 transition-transform duration-500 ease-out"
    />
  </div>

  <!-- Info -->
  <div class="flex-1 min-w-0">
    <p class="font-bold text-neutral-100 text-sm truncate">{dish.name}</p>
    <p class="text-neutral-400 text-xs truncate mt-0.5 flex items-center gap-1">
      <Utensils size={10} /> {dish.restaurant}
    </p>
    <div class="mt-1">
      <CategoryBadge category={dish.category} />
    </div>
  </div>

  <!-- Price + remove -->
  <div class="flex flex-col items-end gap-2 flex-shrink-0">
    <PriceTag amount={dish.price} size="sm" />
    {#if onremove}
      <button
        onclick={(e) => { e.stopPropagation(); onremove(dish.id); }}
        class="w-7 h-7 rounded-xl flex items-center justify-center
               text-neutral-500 hover:text-rose-400 hover:bg-rose-500/10
               transition-all duration-200"
        aria-label="Eliminar guardado"
      >
        <Trash2 size={16} />
      </button>
    {/if}
  </div>
</div>
