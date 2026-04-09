<script lang="ts">
  import { ICONS, m } from "@sdk/ui";
  import { authStore } from "@sdk/state";
  import MerchantProfile from "./MerchantProfile.svelte";
  import TouristProfile from "./TouristProfile.svelte";
  import AdminProfile from "./AdminProfile.svelte";
</script>

<svelte:head>
  <title>{m.app_name()} — {m.nav_profile()}</title>
</svelte:head>

<main class="container mx-auto px-4 pt-6 pb-24 lg:pb-10 max-w-4xl">
  <div class="mb-8 border-b border-white/5 pb-6">
    <h1 class="text-3xl font-extrabold text-base-content tracking-tight flex items-center gap-3">
      {m.profile_title()} 
      {#if authStore.role === 'admin'}
        <ICONS.admin size={32} class="text-error drop-shadow-[0_0_10px_rgba(255,0,0,0.5)]" />
      {:else if authStore.role === 'business'}
        <ICONS.nav_profile size={32} class="text-primary drop-shadow-[0_0_10px_rgba(249,115,22,0.5)]" />
      {:else}
        <ICONS.user size={32} class="text-secondary drop-shadow-[0_0_10px_rgba(236,72,153,0.5)]" />
      {/if}
    </h1>
    <p class="text-base-content/50 text-xs md:text-sm mt-2 font-medium italic">
      {m.profile_subtitle()}
    </p>
  </div>

  <!-- Dynamic Profile Interface Container -->
  {#if authStore.role === 'business'}
    <MerchantProfile />
  {:else if authStore.role === 'admin'}
    <AdminProfile />
  {:else}
    <!-- Default to tourist/explorer interface for normal users or unauthenticated view gracefully handling -->
    <TouristProfile />
  {/if}
</main>
