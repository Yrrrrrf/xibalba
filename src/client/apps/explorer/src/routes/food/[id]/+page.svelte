<script lang="ts">
  import { page } from "$app/stores";
  import { createDishStore } from "@sdk/state";
  import { DishDetailModal } from "@sdk/ui";
  import { onMount } from "svelte";
  import { goto } from "$app/navigation";

  const dishStore = createDishStore();
  const id = $page.params.id;
  const dish = $derived(dishStore.findById(id || ""));

  onMount(() => {
    if (!dish) {
      // In a real app we might fetch it, but for mock data if not found go back
      setTimeout(() => {
        if (!dish) goto("/discover");
      }, 100);
    }
  });
</script>

<svelte:head>
  <title>Xibalbá — {dish?.name ?? "Cargando..."}</title>
</svelte:head>

{#if dish}
  <!-- We use the modal as a full page by keeping it always open and handling close via navigation -->
  <DishDetailModal {dish} open={true} onclose={() => history.back()} />
{:else}
  <div class="flex-1 flex items-center justify-center bg-base-100">
    <span class="loading loading-spinner loading-lg text-primary"></span>
  </div>
{/if}
