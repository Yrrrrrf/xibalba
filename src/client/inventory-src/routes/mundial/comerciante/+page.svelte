<script lang="ts">
  import Modal from "$lib/components/ui/Modal.svelte";
  import BusinessProfile from "$lib/components/comerciante/BusinessProfile.svelte";
  import ProductForm from "$lib/components/comerciante/ProductForm.svelte";
  import MerchantDashboard from "$lib/components/comerciante/MerchantDashboard.svelte";
  import LocationPicker from "$lib/components/comerciante/LocationPicker.svelte";

  interface Producto {
    id: number;
    nombre: string;
    precio: number;
    categoria: string;
    ventas: number;
    disponible: boolean;
  }

  let showModal = $state(false);
  let activeTab = $state<"dashboard" | "perfil" | "ubicacion">("dashboard");

  // Estado de ubicación del negocio
  let ubicacionGuardada = $state<{
    lat: number;
    lng: number;
    address: string;
  } | null>(null);

  function onLocationSaved(lat: number, lng: number, address: string = "") {
    ubicacionGuardada = { lat, lng, address };
  }

  let productos = $state<Producto[]>([
    {
      id: 1,
      nombre: "Tacos al Pastor x3",
      precio: 7.5,
      categoria: "Comida Mexicana",
      ventas: 142,
      disponible: true,
    },
    {
      id: 2,
      nombre: "Quesadilla de Queso",
      precio: 4.0,
      categoria: "Comida Mexicana",
      ventas: 89,
      disponible: true,
    },
    {
      id: 3,
      nombre: "Agua de Jamaica 1L",
      precio: 2.0,
      categoria: "Bebidas",
      ventas: 201,
      disponible: true,
    },
    {
      id: 4,
      nombre: "Orden de Salsas",
      precio: 1.5,
      categoria: "Extras",
      ventas: 310,
      disponible: false,
    },
    {
      id: 5,
      nombre: "Taco de Canasta x5",
      precio: 6.5,
      categoria: "Comida Mexicana",
      ventas: 77,
      disponible: true,
    },
  ]);

  let nextId = $state(6);

  function agregarProducto(data: Omit<Producto, "id" | "ventas">) {
    productos = [...productos, { ...data, id: nextId++, ventas: 0 }];
    showModal = false;
  }
</script>

<svelte:head>
  <title>Mundial Food — Comerciante</title>
  <meta
    name="description"
    content="Panel de gestión para comerciantes del Mundial"
  />
</svelte:head>

<main class="container mx-auto px-4 pt-20 pb-10 max-w-5xl">
  <!-- Header -->
  <div
    class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-8"
  >
    <div>
      <p
        class="text-[10px] font-bold uppercase tracking-[0.2em] text-orange-500 mb-1"
      >
        Mi Panel
      </p>
      <h1 class="text-3xl font-extrabold text-neutral-100 tracking-tight">
        Mi Negocio 🍽️
      </h1>
      <p class="text-neutral-500 text-xs mt-1 font-medium italic">
        Gestiona tus platillos, perfil y ubicación
      </p>
    </div>
    <button
      onclick={() => {
        showModal = true;
      }}
      class="flex items-center gap-2 px-5 py-3 rounded-2xl
               bg-orange-500 hover:bg-orange-600
               text-white font-bold text-[13px] uppercase tracking-wider
               shadow-lg shadow-orange-900/20 hover:shadow-orange-900/40
               transition-all duration-300 hover:-translate-y-0.5
               self-start sm:self-center"
    >
      <svg
        xmlns="http://www.w3.org/2000/svg"
        class="h-5 w-5"
        fill="none"
        viewBox="0 0 24 24"
        stroke="currentColor"
      >
        <path
          stroke-linecap="round"
          stroke-linejoin="round"
          stroke-width="2"
          d="M12 4v16m8-8H4"
        />
      </svg>
      Añadir Platillo
    </button>
  </div>

  <!-- Glass pill tabs -->
  <div
    class="flex gap-2 p-1.5 bg-neutral-900/60 backdrop-blur-md border border-white/10
                rounded-2xl shadow-xl w-fit mb-6"
  >
    {#each [{ id: "dashboard", label: "📦 Mis Platillos" }, { id: "perfil", label: "🏪 Mi Perfil" }, { id: "ubicacion", label: "📍 Ubicación" }] as tab}
      <button
        onclick={() => {
          activeTab = tab.id as typeof activeTab;
        }}
        class="relative px-4 py-2 rounded-xl text-[10px] font-bold uppercase tracking-widest
                 transition-all duration-400
                 {activeTab === tab.id
          ? 'bg-orange-500 text-white shadow-lg shadow-orange-950/20'
          : 'text-neutral-500 hover:text-neutral-300 hover:bg-white/5'}"
      >
        {tab.label}
        {#if tab.id === "ubicacion" && ubicacionGuardada}
          <span
            class="absolute -top-1 -right-1 w-2.5 h-2.5 rounded-full bg-emerald-500 border-2 border-neutral-900 shadow-sm"
          ></span>
        {/if}
      </button>
    {/each}
  </div>

  {#if activeTab === "dashboard"}
    <MerchantDashboard {productos} />
  {:else if activeTab === "perfil"}
    <div
      class="bg-neutral-900/40 backdrop-blur-xl border border-white/10
                  shadow-2xl rounded-2xl overflow-hidden"
    >
      <BusinessProfile />
    </div>
  {:else}
    <!-- Tab ubicación -->
    <div
      class="bg-neutral-900/60 backdrop-blur-xl border border-white/10
                  shadow-2xl rounded-2xl p-6"
    >
      <div class="flex items-center justify-between mb-6">
        <h2 class="font-bold text-neutral-100 flex items-center gap-2">
          <span>📍</span> Ubicación de tu negocio
        </h2>
        {#if ubicacionGuardada}
          <span
            class="px-3 py-1 rounded-full text-[10px] font-bold uppercase tracking-widest
                         bg-emerald-500/10 text-emerald-400 border border-emerald-500/20"
          >
            ✓ Guardada
          </span>
        {/if}
      </div>

      {#if ubicacionGuardada}
        <div
          class="flex items-start gap-3 p-4 rounded-xl
                      bg-emerald-500/5 border border-emerald-500/10 mb-6 text-sm"
        >
          <span class="text-emerald-500 text-lg">✓</span>
          <div>
            <p class="font-bold text-emerald-400">
              ¡Ubicación guardada exitosamente!
            </p>
            <p class="text-xs text-neutral-500 mt-1 italic leading-snug">
              {ubicacionGuardada.address}
            </p>
          </div>
        </div>
      {/if}

      <LocationPicker
        height="360px"
        initialLat={19.4326}
        initialLng={-99.1332}
        onlocationchange={onLocationSaved}
      />
    </div>
  {/if}
</main>

<Modal
  open={showModal}
  title="➕ Nuevo Platillo"
  onclose={() => {
    showModal = false;
  }}
>
  <ProductForm
    onsubmit={agregarProducto}
    oncancel={() => {
      showModal = false;
    }}
  />
</Modal>
