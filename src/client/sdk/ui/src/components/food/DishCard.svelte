<script lang="ts">
  import { Heart, Utensils } from 'lucide-svelte';
  import { type Dish } from "@sdk/core";
  import {
    GlassCard,
    ImageWithFallback,
    CategoryBadge,
    RatingDisplay,
    PriceTag,
  } from "../primitives/mod.ts";
  import { tilt } from "../../actions/tilt.ts";
  import { CATEGORY_BG_ACCENTS } from "../../utils/category-colors.ts";
  import * as m from "../../../src/i18n/paraglide/messages.js";

  interface Props {
    dish: Dish;
    onselect?: () => void;
  }

  let { dish, onselect }: Props = $props();

  let liked = $state(false);
  let localLikes = $derived(dish.likes + (liked ? 1 : 0));

  function toggleLike() {
    liked = !liked;
  }

  const accent = $derived(
    CATEGORY_BG_ACCENTS[dish.category] ?? "from-primary/20 to-primary/10",
  );
</script>

<GlassCard
  onclick={onselect}
  use={[tilt]}
  {accent}
  class="cursor-pointer will-change-transform group"
  style="transform-style: preserve-3d;"
>
  <!-- ── IMAGEN con efecto pop-out ──────────────────────────── -->
  <figure
    class="relative overflow-hidden rounded-t-3xl h-48 bg-gradient-to-br {accent}"
  >
    <ImageWithFallback
      src={dish.image_url}
      alt={dish.name}
      seed={dish.id}
      class="w-full h-full object-cover
             transform-gpu
             group-hover:scale-[1.12]
             group-hover:-translate-y-2
             group-hover:drop-shadow-2xl
             transition-all duration-700 ease-out"
    />

    <!-- Dark gradient overlay for text readability -->
    <div
      class="absolute inset-0 bg-gradient-to-t from-base-300/50 via-base-300/10 to-transparent
                opacity-0 group-hover:opacity-100 transition-opacity duration-500"
    ></div>

    <!-- Category badge -->
    <div class="absolute top-3 left-3 z-10">
      <CategoryBadge category={dish.category} />
    </div>

    <!-- Rating badge -->
    <div class="absolute top-3 right-3 z-10">
      <RatingDisplay value={dish.rating} />
    </div>

    <!-- Hover: restaurante floats in from bottom -->
    <div
      class="absolute bottom-0 inset-x-0 p-3
                translate-y-full group-hover:translate-y-0
                transition-transform duration-400 ease-out z-10"
    >
      <p class="text-primary-content text-xs font-medium drop-shadow flex items-center gap-1.5">
        <Utensils size={12} /> {dish.restaurant}
      </p>
    </div>
  </figure>

  <!-- ── BODY ────────────────────────────────────────────────── -->
  <div class="flex flex-col flex-1 p-4 gap-2">
    <h3
      class="font-bold text-base-content text-[15px] leading-snug line-clamp-2"
    >
      {dish.name}
    </h3>

    <div class="flex items-center justify-between mt-auto pt-2">
      <!-- Price -->
      <PriceTag amount={dish.price} />

      <!-- Like button -->
      <button
        onclick={(e) => {
          e.stopPropagation();
          toggleLike();
        }}
        class="flex items-center gap-1.5 px-3 py-2 rounded-2xl
               transition-all duration-300
               {liked
          ? 'bg-error text-error-content shadow-lg shadow-error/20'
          : 'bg-base-content/5 border border-base-content/10 text-base-content/60 hover:bg-error/10 hover:text-error'}"
        aria-label={m.food_dish()}
      >
        <Heart 
          size={16} 
          class="transition-transform duration-300 {liked ? 'scale-125' : ''}"
          fill={liked ? "currentColor" : "none"} 
          strokeWidth={2}
        />
        <span class="text-xs font-semibold">{localLikes}</span>
      </button>
    </div>
  </div>
</GlassCard>
