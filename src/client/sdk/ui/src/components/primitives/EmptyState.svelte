<script lang="ts">
  import { type Snippet, type Component } from 'svelte';
  import { Utensils } from 'lucide-svelte';

  interface Props {
    icon?: any; // Use any to support both Svelte 4 and 5 component types from lucide-svelte
    title: string;
    subtitle?: string;
    action?: Snippet;
  }

  let { icon: Icon = Utensils, title, subtitle, action }: Props = $props();
</script>

<div class="flex flex-col items-center justify-center py-12 text-center text-neutral-500">
  <div class="mb-3 text-neutral-600">
    <Icon size={48} strokeWidth={1.5} />
  </div>
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
