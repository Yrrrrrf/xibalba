<script lang="ts">
    import { onMount } from "svelte";
    import { goto } from "$app/navigation";

    onMount(() => {
        goto("/overview");
    });
</script>

<div class="hero min-h-screen">
    <div class="hero-content text-center flex flex-col items-center">
        <span class="loading loading-spinner loading-lg text-primary"></span>
        <p class="mt-4 font-medium opacity-70">
            Redirecting to your workspace...
        </p>
    </div>
</div>
