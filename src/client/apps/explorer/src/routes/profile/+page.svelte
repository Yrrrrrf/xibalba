<script lang="ts">
  import { createBusinessStore } from "@sdk/state";
  import { BusinessProfileEditor, LocationPicker } from "@sdk/ui";
  import { m } from "@sdk/ui";

  const businessStore = createBusinessStore();

  function handleSave(updated: any) {
    businessStore.updateProfile(updated);
  }

  function handleLocation(lat: number, lng: number, address?: string) {
    console.log("Location updated:", { lat, lng, address });
  }
</script>

<svelte:head>
  <title>{m.app_name()} — {m.nav_profile()}</title>
</svelte:head>

<main class="container mx-auto px-4 pt-6 pb-10 max-w-4xl">
  <div class="mb-8">
    <h1 class="text-3xl font-extrabold text-neutral-100 tracking-tight">
      {m.profile_title()} 🏪
    </h1>
    <p class="text-neutral-500 text-xs mt-1 font-medium italic">
      {m.profile_subtitle()}
    </p>
  </div>

  <div class="space-y-8 pb-12">
    <section>
      <h2
        class="text-lg font-bold text-neutral-300 mb-4 flex items-center gap-2"
      >
        <span>📋</span>
        {m.profile_general()}
      </h2>
      <BusinessProfileEditor
        profile={businessStore.profile}
        onsave={handleSave}
      />
    </section>

    <section>
      <h2
        class="text-lg font-bold text-neutral-300 mb-4 flex items-center gap-2"
      >
        <span>📍</span>
        {m.profile_location()}
      </h2>
      <div
        class="bg-neutral-900/60 backdrop-blur-xl border border-white/10 rounded-3xl p-6 shadow-xl"
      >
        <LocationPicker onlocationchange={handleLocation} />
      </div>
    </section>
  </div>
</main>
