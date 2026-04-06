<script lang="ts">
  import { type Snippet } from "svelte";

  interface Props {
    children: Snippet;
    class?: string;
    style?: string;
    accent?: string;
    onclick?: () => void;
    use?: any[]; // Kept for backward compatibility with existing components
    enableTilt?: boolean;
  }

  let {
    children,
    class: className = "",
    style = "",
    accent = "",
    onclick,
    use = [],
    enableTilt = true,
  }: Props = $props();

  // ── 3D Tilt action ───────────────────────────────────────────────────
  function tilt(node: HTMLElement) {
    if (!enableTilt) return {};
    let raf = 0;

    function onMove(e: MouseEvent) {
      // Only apply tilt if the user is hovering with a pointing device
      if (window.matchMedia("(pointer: coarse)").matches) return;

      cancelAnimationFrame(raf);
      raf = requestAnimationFrame(() => {
        const rect = node.getBoundingClientRect();
        const x = e.clientX - rect.left;
        const y = e.clientY - rect.top;
        const cx = rect.width / 2;
        const cy = rect.height / 2;
        const rx = ((y - cy) / cy) * -9;
        const ry = ((x - cx) / cx) * 9;
        node.style.transform = `perspective(900px) rotateX(${rx}deg) rotateY(${ry}deg) translateY(-6px) scale(1.02)`;
        node.style.transition = "transform 0.08s ease-out";
      });
    }

    function onLeave() {
      cancelAnimationFrame(raf);
      node.style.transition = "transform 0.5s cubic-bezier(0.23, 1, 0.32, 1)";
      node.style.transform =
        "perspective(900px) rotateX(0deg) rotateY(0deg) translateY(0px) scale(1)";
    }

    node.addEventListener("mousemove", onMove);
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
         glass backdrop-blur-2xl bg-base-100/10 hover:bg-base-100/20 transition-all duration-500
         border border-white/20 dark:border-white/10
         shadow-[0_8px_32px_0_rgba(0,0,0,0.1)] hover:shadow-2xl hover:shadow-primary/30
         rounded-3xl overflow-hidden will-change-transform
         {onclick ? 'cursor-pointer' : ''}
         {className}"
>
  {#if accent}
    <div
      class="absolute inset-x-0 top-0 h-1 bg-gradient-to-r {accent} opacity-80 rounded-t-3xl"
    ></div>
  {/if}

  {@render children()}

  <!-- Bottom shimmer glow on hover -->
  <div
    class="absolute inset-x-4 bottom-0 h-px bg-gradient-to-r from-transparent via-primary/40 to-transparent
              opacity-0 group-hover:opacity-100 transition-opacity duration-500"
  ></div>
</div>
