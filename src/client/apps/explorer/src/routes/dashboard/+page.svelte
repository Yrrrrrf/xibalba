<script lang="ts">
  import { createDishStore, authStore } from "@sdk/state";
  import { MerchantDashboard, BusinessProfileEditor, StatsCard, ICONS } from "@sdk/ui";
  import { Plus } from "lucide-svelte";
  import { m } from "@sdk/ui";

  const dishStore = createDishStore();


  const stats = $derived([
    {
      title: m.merchant_total_dishes(),
      value: dishStore.all.length,
      icon: ICONS.nav_menu,
      variant: "primary" as const,
      trend: "neutral" as const,
    },
    {
      title: m.merchant_total_sales(),
      value: dishStore.all.reduce(
        (acc: number, d: any) => acc + d.sales_count,
        0,
      ),
      icon: ICONS.money,
      variant: "success" as const,
      trend: "up" as const,
      trendValue: "+5%",
    },
  ]);
</script>

<svelte:head>
  <title>{m.app_name()} — {m.nav_dashboard()}</title>
</svelte:head>

<main class="container mx-auto px-4 pt-6 pb-10 max-w-5xl animate-in fade-in slide-in-from-bottom-4 duration-700">
  <div class="mb-8 flex items-center justify-between">
    <div>
      <h1 class="text-3xl font-extrabold text-base-content tracking-tight flex items-center gap-3">
        {m.dashboard_title()}
        <ICONS.nav_menu size={32} class="text-primary" />
      </h1>
      <p class="text-base-content/50 text-xs mt-1 font-medium italic">
        {m.dashboard_subtitle()}
      </p>
    </div>
    <a href="/menu/new" class="btn btn-primary font-bold shadow-lg shadow-primary/30 rounded-2xl hidden sm:flex">
      <Plus size={18} /> Añadir Platillo
    </a>
  </div>

  <!-- Botón móvil para añadir platillos -->
  <a href="/menu/new" class="btn btn-primary btn-block font-bold shadow-lg shadow-primary/30 rounded-2xl mb-6 sm:hidden">
    <Plus size={18} /> Añadir Platillo
  </a>

  <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 mb-8">
    {#each stats as stat}
      <StatsCard {...stat} />
    {/each}
  </div>

  <div class="mb-8">
    <div class="opacity-70 flex items-center justify-between mb-4">
      <h3 class="text-sm font-bold uppercase tracking-widest text-base-content/80">Tu Perfil</h3>
    </div>
    <!-- Editor inyectable para que el comercio configure su local y ubicación -->
    <BusinessProfileEditor 
      profile={{
        name: "Tu Comercio",
        category: "Categoría General",
        owner_name: "Propietario",
        zone: "Centro",
        address: "123 Calle Principal",
        phone: "555-1234",
        email: "contacto@negocio.com",
        hours: "09:00 - 18:00",
        description: "Ofrecemos los mejores platillos de la zona."
      }} 
    />
  </div>

  <div class="opacity-70 flex items-center justify-between mb-4 mt-8">
    <h3 class="text-sm font-bold uppercase tracking-widest text-base-content/80">Catálogo Activo</h3>
    <a href="/menu" class="text-xs font-bold text-primary hover:underline">Ver Todo</a>
  </div>
  <MerchantDashboard dishes={dishStore.all} />
</main>
