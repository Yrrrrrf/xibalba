<script lang="ts">
  import { type Snippet } from "svelte";

  interface Props {
    children: Snippet;
    class?: string;
    style?: string;
    accent?: string;
    onclick?: () => void;
    use?: any[]; // Kept for backward compatibility
    enableTilt?: boolean;
    enableShimmer?: boolean;
  }

  let {
    children,
    class: className = "",
    style = "",
    accent = "",
    onclick,
    use = [],
    enableTilt = true,
    enableShimmer = true,
  }: Props = $props();

  // ── Optimized Tilt action for Performance ───────────────────────────
  function tilt(node: HTMLElement) {
    if (!enableTilt) return {};
    
    // Bail out immediately on mobile/touch - no listeners added at all
    const isMobile = window.matchMedia("(pointer: coarse)").matches;
    if (isMobile) return {};

    let raf = 0;

    function onMove(e: MouseEvent) {
      cancelAnimationFrame(raf);
      raf = requestAnimationFrame(() => {
        const rect = node.getBoundingClientRect();
        const x = e.clientX - rect.left;
        const y = e.clientY - rect.top;
        const cx = rect.width / 2;
        const cy = rect.height / 2;
        const rx = ((y - cy) / cy) * -8; // Slightly reduced angle
        const ry = ((x - cx) / cx) * 8;
        node.style.transform = `perspective(1000px) rotateX(${rx}deg) rotateY(${ry}deg) translateY(-4px) scale(1.01)`;
        node.style.transition = "transform 0.1s ease-out";
      });
    }

    function onLeave() {
      cancelAnimationFrame(raf);
      node.style.transition = "transform 0.6s cubic-bezier(0.23, 1, 0.32, 1)";
      node.style.transform = "perspective(1000px) rotateX(0deg) rotateY(0deg) translateY(0px) scale(1)";
    }

    node.addEventListener("mousemove", onMove, { passive: true });
    node.addEventListener("mouseleave", onLeave);

    return {
      destroy() {
        node.removeEventListener("mousemove", onMove);
        node.removeEventListener("mouseleave", onLeave);
      },
    };
  }
</script>

<!-- svelte-ignore a11y_click_events_have_key_events -->
<!-- svelte-ignore a11y_no_static_element_interactions -->
<div
  use:tilt
  {onclick}
  style="transform-style: preserve-3d; {style}"
  class="group relative flex flex-col
         glass backdrop-blur-2xl bg-base-100/[0.08] hover:bg-base-100/[0.12] transition-all duration-500
         border border-white/[0.08] dark:border-white/[0.05]
         shadow-[0_8px_32px_-12px_rgba(0,0,0,0.4)] hover:shadow-2xl hover:shadow-primary/10
         rounded-3xl overflow-hidden will-change-transform
         {onclick ? 'cursor-pointer' : ''}
         {className}"
>
  <!-- PREMIUM GLASS REFLEX (Reflejo diagonal optimizado) -->
  {#if enableShimmer}
    <div class="absolute inset-0 pointer-events-none overflow-hidden rounded-3xl z-0">
      <!-- Main subtle diagonal reflex -->
      <div 
        class="absolute inset-0 bg-gradient-to-br from-white/[0.12] via-transparent to-transparent 
               opacity-30 group-hover:opacity-50 transition-opacity duration-1000"
      ></div>
      
      <!-- Sharp moving shimmer line - Optimized with slower cycle -->
      <div 
        class="absolute inset-0 opacity-[0.02] group-hover:opacity-[0.06] transition-opacity duration-1000
               bg-[linear-gradient(110deg,transparent_40%,rgba(255,255,255,0.5)_50%,transparent_60%)]
               bg-[length:200%_100%] animate-[shimmer_15s_linear_infinite]"
      ></div>
      
      <!-- Outer rim light -->
      <div class="absolute inset-0 border border-white/[0.03] rounded-3xl pointer-events-none"></div>
    </div>
  {/if}

  {#if accent}
    <div
      class="absolute inset-x-0 top-0 h-1 bg-gradient-to-r {accent} opacity-90 rounded-t-3xl z-20"
    ></div>
  {/if}

  <div class="relative z-10 h-full flex flex-col">
    {@render children()}
  </div>

  <!-- Bottom shimmer glow on hover -->
  <div
    class="absolute inset-x-6 bottom-0 h-px bg-gradient-to-r from-transparent via-primary/40 to-transparent
           opacity-0 group-hover:opacity-80 transition-opacity duration-700 z-20"
  ></div>
</div>
