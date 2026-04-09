<script lang="ts">
  import { createBusinessStore } from "@sdk/state";
  import { BusinessProfileEditor, LocationPicker, ICONS, m } from "@sdk/ui";

  const businessStore = createBusinessStore();

  function handleSave(updated: any) {
    businessStore.updateProfile(updated);
  }

  function handleLocation(lat: number, lng: number, address?: string) {
    console.log("Location updated:", { lat, lng, address });
  }
</script>

<div class="space-y-8 pb-12">
  <section>
    <h2 class="text-lg font-bold text-base-content/80 mb-4 flex items-center gap-2">
      <ICONS.clipboard size={20} class="text-primary" />
      {m.profile_general()}
    </h2>
    <BusinessProfileEditor profile={businessStore.profile} onsave={handleSave} />
  </section>

  <section>
    <h2 class="text-lg font-bold text-base-content/80 mb-4 flex items-center gap-2">
      <ICONS.map_pin size={20} class="text-primary" />
      {m.profile_location()}
    </h2>
    <div class="bg-base-200/60 backdrop-blur-xl border border-base-content/10 rounded-3xl p-6 shadow-xl">
      <LocationPicker onlocationchange={handleLocation} />
    </div>
  </section>
</div>
