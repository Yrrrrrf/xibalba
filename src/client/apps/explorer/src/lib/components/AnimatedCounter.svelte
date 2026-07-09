<script lang="ts">
  import { onMount } from "svelte";

  let { target = 0, duration = 2000, class: className = "" } = $props();

  let count = $state(0);

  onMount(() => {
    let start = 0;
    const end = target;
    const totalSteps = duration / 16;
    const increment = (end - start) / totalSteps;

    const timer = setInterval(() => {
      start += increment;
      if (start >= end) {
        count = end;
        clearInterval(timer);
      } else {
        count = Math.floor(start);
      }
    }, 16);

    return () => clearInterval(timer);
  });
</script>

<span class={className}>
  {count.toLocaleString()}
</span>
