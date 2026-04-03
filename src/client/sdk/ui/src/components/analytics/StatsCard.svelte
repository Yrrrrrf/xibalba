<script lang="ts">
  import type { StatSnapshot } from '@sdk/core';
  import { GlassCard } from '../primitives/mod.ts';

  interface Props extends StatSnapshot {}

  let {
    title,
    value,
    desc = "",
    icon = "📊",
    trend = "neutral",
    trendValue = "",
    variant = "primary",
  }: Props = $props();

  const variantGradient: Record<string, string> = {
    primary: "from-orange-400 to-amber-500",
    secondary: "from-violet-400 to-purple-500",
    accent: "from-cyan-400 to-blue-500",
    success: "from-emerald-400 to-green-500",
    warning: "from-yellow-400 to-amber-400",
    error: "from-rose-400 to-red-500",
  };

  const variantText: Record<string, string> = {
    primary: "text-orange-400",
    secondary: "text-violet-400",
    accent: "text-cyan-400",
    success: "text-emerald-400",
    warning: "text-amber-400",
    error: "text-rose-400",
  };

  const trendIcon = $derived(
    trend === "up" ? "▲" : trend === "down" ? "▼" : "—",
  );
  const trendColor = $derived(
    trend === "up"
      ? "text-emerald-500"
      : trend === "down"
        ? "text-rose-500"
        : "text-stone-400",
  );
  const gradient = $derived(
    variantGradient[variant] ?? variantGradient.primary,
  );
  const textColor = $derived(variantText[variant] ?? variantText.primary);
</script>

<GlassCard
  accent={gradient}
  class="p-5 hover:-translate-y-1 transition-all duration-400 ease-out"
>
  <!-- Icon circle -->
  <div
    class="w-11 h-11 rounded-xl flex items-center justify-center text-xl mb-3
              bg-gradient-to-br {gradient} shadow-md text-white
              group-hover:scale-110 group-hover:rotate-3
              transition-transform duration-300"
  >
    {icon}
  </div>

  <!-- Title -->
  <p class="text-[10px] font-bold uppercase tracking-widest text-neutral-500 mb-1">
    {title}
  </p>

  <!-- Value -->
  <p class="text-3xl font-extrabold {textColor} leading-none mb-2">{value}</p>

  <!-- Trend + desc -->
  <div class="flex items-center gap-1.5 flex-wrap">
    {#if trendValue}
      <span class="text-xs font-bold {trendColor}">
        {trendIcon}
        {trendValue}
      </span>
    {/if}
    {#if desc}
      <span class="text-xs text-neutral-500">{desc}</span>
    {/if}
  </div>

  <!-- Hover glow background -->
  <div
    class="absolute inset-0 bg-gradient-to-br {gradient} opacity-0
              group-hover:opacity-[0.04] transition-opacity duration-400"
  ></div>
</GlassCard>
