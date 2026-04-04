<script lang="ts">
  import { type Dish } from "@sdk/core";
  import { MapView } from "../map/mod.ts";
  import {
    CategoryBadge,
    RatingDisplay,
    PriceTag,
    ImageWithFallback,
  } from "../primitives/mod.ts";
  import { CATEGORY_GRADIENT_ACCENTS } from "../../utils/category-colors.ts";
  import * as m from "../../../src/i18n/paraglide/messages.js";

  interface Props {
    dish: Dish | null;
    open: boolean;
    onclose: () => void;
  }

  let { dish, open, onclose }: Props = $props();

  const accent = $derived(
    dish
      ? (CATEGORY_GRADIENT_ACCENTS[dish.category] ??
          "from-orange-500 to-amber-500")
      : "",
  );

  function handleBackdrop(e: MouseEvent) {
    if (e.target === e.currentTarget) onclose();
  }

  function handleKey(e: KeyboardEvent) {
    if (e.key === "Escape") onclose();
  }
</script>

<svelte:window onkeydown={handleKey} />

{#if open && dish}
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
      <div
        class="relative h-64 sm:h-72 flex-shrink-0 overflow-hidden rounded-t-3xl"
      >
        <ImageWithFallback
          src={dish.image_url}
          alt={dish.name}
          seed={dish.id}
          class="w-full h-full object-cover"
        />
        <!-- Gradient overlay -->
        <div
          class="absolute inset-0 bg-gradient-to-t from-neutral-950 via-neutral-950/40 to-transparent"
        ></div>

        <!-- Top accent bar -->
        <div
          class="absolute top-0 inset-x-0 h-1 bg-gradient-to-r {accent}"
        ></div>

        <!-- Close button -->
        <button
          onclick={onclose}
          class="absolute top-4 right-4 z-10
                 w-9 h-9 rounded-full
                 bg-black/50 backdrop-blur-md border border-white/20
                 flex items-center justify-center
                 text-neutral-300 hover:text-white hover:bg-black/70
                 transition-all duration-200"
          aria-label={m.detail_close()}
        >
          <svg
            class="w-4 h-4"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
            stroke-width="2.5"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              d="M6 18L18 6M6 6l12 12"
            />
          </svg>
        </button>

        <!-- Category & Rating badges -->
        <div class="absolute top-4 left-4 flex gap-2">
          <CategoryBadge category={dish.category} />
        </div>

        <!-- Name + price over image bottom -->
        <div class="absolute bottom-0 inset-x-0 p-5">
          <h2
            class="text-2xl font-extrabold text-white tracking-tight leading-tight mb-1"
          >
            {dish.name}
          </h2>
          <div class="flex items-center gap-3">
            <PriceTag amount={dish.price} />
            <RatingDisplay value={dish.rating} />
          </div>
        </div>
      </div>

      <!-- ── CONTENT ─────────────────────────────────────── -->
      <div class="flex flex-col gap-6 p-5 sm:p-6">
        <!-- Description -->
        {#if dish.description}
          <p
            class="text-neutral-400 text-sm leading-relaxed italic border-l-2 border-orange-500/40 pl-3"
          >
            {dish.description}
          </p>
        {/if}

        <!-- Nutrition + Ingredients Grid -->
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <!-- Nutrition Panel -->
          {#if dish.nutrition}
            <div
              class="bg-neutral-900/60 border border-white/8 rounded-2xl p-4"
            >
              <p
                class="text-[10px] font-bold uppercase tracking-widest text-orange-400 mb-3"
              >
                📊 {m.food_nutrition()}
              </p>
              <div class="grid grid-cols-2 gap-3">
                {#each [{ label: m.food_calories(), value: dish.nutrition.calories, unit: "kcal", color: "text-orange-400" }, { label: m.food_protein(), value: dish.nutrition.protein, unit: "g", color: "text-blue-400" }, { label: m.food_fat(), value: dish.nutrition.fat, unit: "g", color: "text-yellow-400" }, { label: m.food_carbs(), value: dish.nutrition.carbs, unit: "g", color: "text-green-400" }] as stat}
                  <div class="bg-neutral-800/50 rounded-xl p-3 text-center">
                    <p
                      class="text-[10px] text-neutral-500 uppercase tracking-wider mb-1"
                    >
                      {stat.label}
                    </p>
                    <p class="font-extrabold text-lg {stat.color} leading-none">
                      {stat.value}
                    </p>
                    <p class="text-[10px] text-neutral-600">{stat.unit}</p>
                  </div>
                {/each}
              </div>
            </div>
          {/if}

          <!-- Ingredients Panel -->
          {#if dish.ingredients && dish.ingredients.length > 0}
            <div
              class="bg-neutral-900/60 border border-white/8 rounded-2xl p-4"
            >
              <p
                class="text-[10px] font-bold uppercase tracking-widest text-orange-400 mb-3"
              >
                🧂 {m.food_ingredients()}
              </p>
              <div class="flex flex-wrap gap-1.5">
                {#each dish.ingredients as ing}
                  <span
                    class="px-2.5 py-1 rounded-full text-[11px] font-medium
                               bg-white/5 border border-white/10 text-neutral-300"
                  >
                    {ing}
                  </span>
                {/each}
              </div>
            </div>
          {/if}
        </div>

        <!-- Mini Map -->
        <!-- TODO: pass actual business data for location if available in Dish entity or fetch it -->

        <!-- Action Buttons -->
        <div class="flex gap-3 pb-1">
          <button
            class="flex-1 py-3 rounded-2xl font-bold text-[13px] uppercase tracking-wider
                   bg-orange-500 hover:bg-orange-600 text-white
                   shadow-lg shadow-orange-900/20 transition-all duration-200 hover:-translate-y-0.5"
          >
            🛒 {m.detail_order()}
          </button>
          <button
            onclick={onclose}
            class="px-5 py-3 rounded-2xl font-bold text-[13px] uppercase tracking-wider
                   bg-white/5 border border-white/10 text-neutral-400
                   hover:bg-white/10 hover:text-neutral-200
                   transition-all duration-200"
          >
            {m.detail_close()}
          </button>
        </div>
      </div>
    </div>
  </div>
{/if}
