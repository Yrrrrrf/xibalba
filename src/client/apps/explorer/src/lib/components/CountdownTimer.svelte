<script lang="ts">
  import { onMount } from "svelte";
  import { GlassCard } from "@sdk/ui";

  let { targetDate = "2026-06-11T00:00:00" } = $props();

  let days = $state(0);
  let hours = $state(0);
  let minutes = $state(0);
  let seconds = $state(0);

  function updateCountdown() {
    const target = new Date(targetDate).getTime();
    const now = new Date().getTime();
    const distance = target - now;

    if (distance < 0) return;

    days = Math.floor(distance / (1000 * 60 * 60 * 24));
    hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
    minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
    seconds = Math.floor((distance % (1000 * 60)) / 1000);
  }

  onMount(() => {
    updateCountdown();
    const interval = setInterval(updateCountdown, 1000);
    return () => clearInterval(interval);
  });
</script>

<div class="flex gap-4 justify-center items-center">
  {#each [ { label: "Días", value: days }, { label: "Horas", value: hours }, { label: "Minutos", value: minutes }, { label: "Segundos", value: seconds } ] as item}
    <div class="flex flex-col items-center gap-2">
      <GlassCard class="w-20 h-24 sm:w-28 sm:h-32 flex items-center justify-center !rounded-2xl">
        <span class="text-3xl sm:text-5xl font-black font-mono text-primary drop-shadow-[0_0_10px_rgba(var(--primary),0.3)]">
          {item.value.toString().padStart(2, '0')}
        </span>
      </GlassCard>
      <span class="text-[10px] font-black uppercase tracking-widest opacity-40">
        {item.label}
      </span>
    </div>
  {/each}
</div>
