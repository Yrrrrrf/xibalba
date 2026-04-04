<script lang="ts">
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
  import * as m from "../../paraglide/messages.js";

  interface Props {
    dish: Dish;
    onselect?: () => void;
  }

  let { dish, onselect }: Props = $props();

  let liked = $state(false);
  let localLikes = $state(dish.likes);

  function toggleLike() {
    liked = !liked;
    localLikes = liked ? localLikes + 1 : localLikes - 1;
  }

  const accent = $derived(
    CATEGORY_BG_ACCENTS[dish.category] ?? "from-amber-400/20 to-orange-400/10",
  );
</script>

<GlassCard
  onclick={onselect}
  use={[tilt]}
  {accent}
  class="cursor-pointer will-change-transform"
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
             group-hover:drop-shadow-[0_20px_24px_rgba(0,0,0,0.35)]
             transition-all duration-700 ease-out"
    />

    <!-- Dark gradient overlay for text readability -->
    <div
      class="absolute inset-0 bg-gradient-to-t from-black/50 via-black/10 to-transparent
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
      <p class="text-white text-xs font-medium drop-shadow">
        🍽️ {dish.restaurant}
      </p>
    </div>
  </figure>

  <!-- ── BODY ────────────────────────────────────────────────── -->
  <div class="flex flex-col flex-1 p-4 gap-2">
    <h3
      class="font-bold text-neutral-100 text-[15px] leading-snug line-clamp-2"
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
          ? 'bg-rose-500 text-white shadow-lg shadow-rose-900/20'
          : 'bg-white/5 border border-white/10 text-neutral-400 hover:bg-rose-500/10 hover:text-rose-400'}"
        aria-label={m.food_dish()}
      >
        <svg
          class="h-4 w-4 transition-transform duration-300 {liked
            ? 'scale-125'
            : ''}"
          viewBox="0 0 24 24"
          fill={liked ? "currentColor" : "none"}
          stroke="currentColor"
          stroke-width="2"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"
          />
        </svg>
        <span class="text-xs font-semibold">{localLikes}</span>
      </button>
    </div>
  </div>
</GlassCard>
