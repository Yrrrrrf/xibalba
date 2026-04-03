<script lang="ts">
  import { type Snippet } from 'svelte';

  interface Props {
    emoji?: string;
    title: string;
    subtitle?: string;
    action?: Snippet;
  }

  let { emoji = '🍽️', title, subtitle, action }: Props = $props();
</script>

<div class="text-center py-12 text-neutral-500">
  <div class="text-5xl mb-3">{emoji}</div>
  <p class="font-bold text-neutral-300">{title}</p>
  {#if subtitle}
    <p class="text-sm">{subtitle}</p>
  {/if}
  {#if action}
    <div class="mt-4">
      {@render action()}
    </div>
  {/if}
</div>
