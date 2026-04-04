<script lang="ts">
  import { Star } from 'lucide-svelte';

  interface Props {
    value: number;
    class?: string;
  }

  let { value, class: className = '' }: Props = $props();
</script>

<div class="flex items-center gap-1 px-2 py-1 rounded-full bg-black/40 backdrop-blur-sm border border-white/20 {className}">
  <Star size={10} class="text-amber-400 fill-amber-400" />
  <span class="text-white text-xs font-bold leading-none">{value}</span>
</div>
