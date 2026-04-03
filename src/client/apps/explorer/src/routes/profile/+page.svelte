<script lang="ts">
  // @ts-ignore
  import { createBusinessStore } from "@sdk/state";
  import { BusinessProfileEditor, LocationPicker } from "@sdk/ui";

  const businessStore = createBusinessStore();

  function handleSave(updated: any) {
    console.log('Profile saved:', updated);
    // In a real app, call store.updateProfile(updated)
  }

  function handleLocation(lat: number, lng: number, address?: string) {
    console.log('Location updated:', { lat, lng, address });
  }
</script>

<svelte:head>
  <title>Xibalbá — Perfil</title>
</svelte:head>

<main class="container mx-auto px-4 pt-6 pb-10 max-w-4xl">
  <div class="mb-8">
    <h1 class="text-3xl font-extrabold text-neutral-100 tracking-tight">
      Perfil del Negocio 🏪
    </h1>
    <p class="text-neutral-500 text-xs mt-1 font-medium italic">
      Actualiza la información y ubicación de tu establecimiento
    </p>
  </div>

  <div class="space-y-8 pb-12">
    <section>
      <h2 class="text-lg font-bold text-neutral-300 mb-4 flex items-center gap-2">
        <span>📋</span> Datos Generales
      </h2>
      <BusinessProfileEditor
        profile={businessStore.profile}
        onsave={handleSave}
      />
    </section>

    <section>
      <h2 class="text-lg font-bold text-neutral-300 mb-4 flex items-center gap-2">
        <span>📍</span> Ubicación en el Mapa
      </h2>
      <div class="bg-neutral-900/60 backdrop-blur-xl border border-white/10 rounded-3xl p-6 shadow-xl">
        <LocationPicker
          onlocationchange={handleLocation}
        />
      </div>
    </section>
  </div>
</main>
