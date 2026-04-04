<script lang="ts">
  import { type Snippet } from 'svelte';

  interface Props {
    children: Snippet;
    class?: string;
    style?: string;
    accent?: string;
    onclick?: () => void;
    use?: any[];
  }

  let { children, class: className = '', style = '', accent = '', onclick, use = [] }: Props = $props();
</script>

<!-- svelte-ignore a11y_click_events_have_key_events -->
<!-- svelte-ignore a11y_no_static_element_interactions -->
<div
  {onclick}
  {style}
  class="group relative flex flex-col
         bg-neutral-900/60 backdrop-blur-xl
         border border-white/10
         shadow-[0_8px_32px_rgba(0,0,0,0.30)]
         rounded-3xl overflow-hidden
         {className}"
>
  {#if accent}
    <div class="absolute inset-x-0 top-0 h-1 bg-gradient-to-r {accent} opacity-80 rounded-t-3xl"></div>
  {/if}

  {@render children()}

  <!-- Bottom shimmer glow on hover -->
  <div class="absolute inset-x-4 bottom-0 h-px bg-gradient-to-r from-transparent via-orange-400/40 to-transparent
              opacity-0 group-hover:opacity-100 transition-opacity duration-500"></div>
</div>
