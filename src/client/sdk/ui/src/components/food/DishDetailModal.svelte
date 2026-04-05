<script lang="ts">
  import { X, BarChart3, CookingPot, ShoppingCart } from 'lucide-svelte';
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
          "from-primary to-primary/80")
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
           bg-base-300/80 backdrop-blur-sm"
    onclick={handleBackdrop}
  >
    <!-- Modal Panel -->
    <div
      class="relative w-full max-w-3xl max-h-[92vh] overflow-y-auto
             bg-base-100 backdrop-blur-2xl
             border border-base-content/10
             rounded-3xl shadow-2xl
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
          class="absolute inset-0 bg-gradient-to-t from-base-100 via-base-100/40 to-transparent"
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
                 bg-base-200/50 backdrop-blur-md border border-base-content/10
                 flex items-center justify-center
                 text-base-content/60 hover:text-base-content hover:bg-base-200/80
                 transition-all duration-200"
          aria-label={m.detail_close()}
        >
          <X size={18} strokeWidth={2.5} />
        </button>

        <!-- Category & Rating badges -->
        <div class="absolute top-4 left-4 flex gap-2">
          <CategoryBadge category={dish.category} />
        </div>

        <!-- Name + price over image bottom -->
        <div class="absolute bottom-0 inset-x-0 p-5">
          <h2
            class="text-2xl font-extrabold text-base-content tracking-tight leading-tight mb-1"
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
            class="text-base-content/60 text-sm leading-relaxed italic border-l-2 border-primary/40 pl-3"
          >
            {dish.description}
          </p>
        {/if}

        <!-- Nutrition + Ingredients Grid -->
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <!-- Nutrition Panel -->
          {#if dish.nutrition}
            <div
              class="bg-base-200/60 border border-base-content/5 rounded-2xl p-4"
            >
              <p
                class="text-[10px] font-bold uppercase tracking-widest text-primary mb-3 flex items-center gap-1.5"
              >
                <BarChart3 size={12} /> {m.food_nutrition()}
              </p>
              <div class="grid grid-cols-2 gap-3">
                {#each [{ label: m.food_calories(), value: dish.nutrition.calories, unit: "kcal", color: "text-primary" }, { label: m.food_protein(), value: dish.nutrition.protein, unit: "g", color: "text-info" }, { label: m.food_fat(), value: dish.nutrition.fat, unit: "g", color: "text-warning" }, { label: m.food_carbs(), value: dish.nutrition.carbs, unit: "g", color: "text-success" }] as stat}
                  <div class="bg-base-300/50 rounded-xl p-3 text-center">
                    <p
                      class="text-[10px] text-base-content/50 uppercase tracking-wider mb-1"
                    >
                      {stat.label}
                    </p>
                    <p class="font-extrabold text-lg {stat.color} leading-none">
                      {stat.value}
                    </p>
                    <p class="text-[10px] text-base-content/40">{stat.unit}</p>
                  </div>
                {/each}
              </div>
            </div>
          {/if}

          <!-- Ingredients Panel -->
          {#if dish.ingredients && dish.ingredients.length > 0}
            <div
              class="bg-base-200/60 border border-base-content/5 rounded-2xl p-4"
            >
              <p
                class="text-[10px] font-bold uppercase tracking-widest text-primary mb-3 flex items-center gap-1.5"
              >
                <CookingPot size={12} /> {m.food_ingredients()}
              </p>
              <div class="flex flex-wrap gap-1.5">
                {#each dish.ingredients as ing}
                  <span
                    class="px-2.5 py-1 rounded-full text-[11px] font-medium
                               bg-base-content/5 border border-base-content/10 text-base-content/70"
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
            class="flex-1 btn btn-primary font-bold text-[13px] uppercase tracking-wider rounded-2xl h-auto py-3
                   shadow-lg shadow-primary/20 transition-all duration-200 hover:-translate-y-0.5"
          >
            <ShoppingCart size={18} /> {m.detail_order()}
          </button>
          <button
            onclick={onclose}
            class="px-5 btn btn-ghost font-bold text-[13px] uppercase tracking-wider rounded-2xl h-auto py-3
                   bg-base-content/5 border border-base-content/10 text-base-content/60
                   hover:bg-base-content/10 hover:text-base-content
                   transition-all duration-200"
          >
            {m.detail_close()}
          </button>
        </div>
      </div>
    </div>
  </div>
{/if}
