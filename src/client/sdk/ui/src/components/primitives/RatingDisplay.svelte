<script lang="ts">
  interface Props {
    value: number;
    class?: string;
  }

  let { value, class: className = '' }: Props = $props();
</script>

<div class="flex items-center gap-1 px-2 py-1 rounded-full bg-black/40 backdrop-blur-sm border border-white/20 {className}">
  <span class="text-amber-400 text-xs leading-none">★</span>
  <span class="text-white text-xs font-bold">{value}</span>
</div>
