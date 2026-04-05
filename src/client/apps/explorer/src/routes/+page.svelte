<script lang="ts">
  import { createAuthStore } from "@sdk/state";
  import { onMount } from "svelte";
  import { goto } from "$app/navigation";
  import LabNavBar from "$lib/components/LabNavBar.svelte";

  const auth = createAuthStore();

  onMount(() => {
    if (!auth.role) {
      goto("/login");
    } else if (auth.role === "tourist") {
      goto("/discover");
    } else {
      goto("/dashboard");
    }
  });
</script>

<div class="flex-1 flex items-center justify-center bg-neutral-950">
  <span class="loading loading-spinner loading-lg text-orange-500"></span>
</div>
