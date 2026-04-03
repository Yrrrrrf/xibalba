<script lang="ts">
  import StatsCard from "$lib/components/admin/StatsCard.svelte";
  import DataTable from "$lib/components/admin/DataTable.svelte";

  const statsGlobales = [
    {
      title: "Comerciantes Activos",
      value: "48",
      icon: "🏪",
      trend: "up" as const,
      trendValue: "+12%",
      desc: "vs semana pasada",
      variant: "primary" as const,
    },
    {
      title: "Platillos Registrados",
      value: "312",
      icon: "🍽️",
      trend: "up" as const,
      trendValue: "+28",
      desc: "esta semana",
      variant: "secondary" as const,
    },
    {
      title: "Ventas Totales",
      value: "6,841",
      icon: "💰",
      trend: "up" as const,
      trendValue: "+8.4%",
      desc: "vs ayer",
      variant: "accent" as const,
    },
    {
      title: "Turistas Activos",
      value: "1,294",
      icon: "🧳",
      trend: "up" as const,
      trendValue: "+156",
      desc: "hoy",
      variant: "success" as const,
    },
    {
      title: "Zonas Cubiertas",
      value: "5",
      icon: "📍",
      trend: "neutral" as const,
      trendValue: "",
      desc: "de 5 zonas",
      variant: "warning" as const,
    },
    {
      title: "Tickets Soporte",
      value: "3",
      icon: "🚨",
      trend: "down" as const,
      trendValue: "-2",
      desc: "pendientes",
      variant: "error" as const,
    },
  ];

  const ventasPorZona = [
    {
      title: "Centro Histórico",
      value: "2,341",
      icon: "🏛️",
      trend: "up" as const,
      trendValue: "+15%",
      desc: "ventas",
      variant: "primary" as const,
    },
    {
      title: "Estadio Principal",
      value: "1,897",
      icon: "🏟️",
      trend: "up" as const,
      trendValue: "+22%",
      desc: "ventas",
      variant: "secondary" as const,
    },
    {
      title: "Fan Fest",
      value: "1,432",
      icon: "🎉",
      trend: "up" as const,
      trendValue: "+9%",
      desc: "ventas",
      variant: "accent" as const,
    },
    {
      title: "Costera Norte",
      value: "876",
      icon: "🏖️",
      trend: "down" as const,
      trendValue: "-3%",
      desc: "ventas",
      variant: "warning" as const,
    },
    {
      title: "Mercado Tradicional",
      value: "295",
      icon: "🛖",
      trend: "neutral" as const,
      trendValue: "0%",
      desc: "ventas",
      variant: "success" as const,
    },
  ];

  const comerciantes = [
    {
      id: 1,
      nombre: "Taquería El Campeón",
      propietario: "Carlos Ramírez",
      zona: "Zona Centro Histórico",
      categoria: "Comida Mexicana",
      platillos: 12,
      ventas: 412,
      estado: "activo" as const,
    },
    {
      id: 2,
      nombre: "La Perla del Mar",
      propietario: "Ana García",
      zona: "Zona Costera Norte",
      categoria: "Mariscos",
      platillos: 8,
      ventas: 289,
      estado: "activo" as const,
    },
    {
      id: 3,
      nombre: "Dulcería Mundial",
      propietario: "Pedro Torres",
      zona: "Zona Fan Fest",
      categoria: "Postres",
      platillos: 15,
      ventas: 198,
      estado: "activo" as const,
    },
    {
      id: 4,
      nombre: "El Birriería Jalisco",
      propietario: "Luis Mendoza",
      zona: "Zona Centro Histórico",
      categoria: "Comida Mexicana",
      platillos: 6,
      ventas: 334,
      estado: "activo" as const,
    },
    {
      id: 5,
      nombre: "Antojitos La Esquina",
      propietario: "María López",
      zona: "Zona Estadio Principal",
      categoria: "Antojitos",
      platillos: 10,
      ventas: 156,
      estado: "pendiente" as const,
    },
    {
      id: 6,
      nombre: "La Comal de Doña Rosa",
      propietario: "Rosa Jiménez",
      zona: "Zona Mercado Tradicional",
      categoria: "Comida Mexicana",
      platillos: 7,
      ventas: 95,
      estado: "activo" as const,
    },
    {
      id: 7,
      nombre: "Refresquería Fresca",
      propietario: "Jorge Peña",
      zona: "Zona Fan Fest",
      categoria: "Bebidas",
      platillos: 4,
      ventas: 421,
      estado: "activo" as const,
    },
    {
      id: 8,
      nombre: "Mariscos El Golfo",
      propietario: "Sandra Ruiz",
      zona: "Zona Costera Norte",
      categoria: "Mariscos",
      platillos: 9,
      ventas: 207,
      estado: "inactivo" as const,
    },
    {
      id: 9,
      nombre: "Veggie Garden",
      propietario: "Tomás Vera",
      zona: "Zona Centro Histórico",
      categoria: "Vegetariano",
      platillos: 11,
      ventas: 89,
      estado: "pendiente" as const,
    },
    {
      id: 10,
      nombre: "Birria de Jalisco Norte",
      propietario: "Felipe Morales",
      zona: "Zona Estadio Principal",
      categoria: "Comida Mexicana",
      platillos: 5,
      ventas: 178,
      estado: "activo" as const,
    },
  ];

  let activeSection = $state<"general" | "zonas">("general");

  const topPlatillos = [
    {
      rank: 1,
      name: "Tacos al Pastor x3",
      ventas: 412,
      restaurante: "Taquería El Campeón",
    },
    {
      rank: 2,
      name: "Agua de Jamaica 1L",
      ventas: 389,
      restaurante: "Refresquería Fresca",
    },
    {
      rank: 3,
      name: "Ceviche Mixto",
      ventas: 301,
      restaurante: "La Perla del Mar",
    },
    {
      rank: 4,
      name: "Elote Preparado",
      ventas: 267,
      restaurante: "Antojitos La Esquina",
    },
    {
      rank: 5,
      name: "Churros con Cajeta",
      ventas: 198,
      restaurante: "Dulcería Mundial",
    },
  ];

  const actividad = [
    {
      time: "hace 5min",
      msg: "Nuevo comerciante registrado",
      who: "Veggie Garden",
      type: "info",
    },
    {
      time: "hace 12min",
      msg: "Ticket de soporte abierto",
      who: "Cliente #1492",
      type: "warning",
    },
    {
      time: "hace 1h",
      msg: "Platillo aprobado",
      who: "Birria de Jalisco Norte",
      type: "success",
    },
    {
      time: "hace 2h",
      msg: "Comerciante suspendido",
      who: "Mariscos El Golfo",
      type: "error",
    },
    {
      time: "hace 3h",
      msg: "Actualización de zona",
      who: "Zona Fan Fest",
      type: "info",
    },
    {
      time: "hace 4h",
      msg: "Pico de tráfico detectado",
      who: "Zona Estadio Principal",
      type: "warning",
    },
  ];

  const activityStyle: Record<string, { dot: string; icon: string }> = {
    info: { dot: "bg-blue-400", icon: "ℹ" },
    success: { dot: "bg-emerald-400", icon: "✓" },
    warning: { dot: "bg-amber-400", icon: "⚠" },
    error: { dot: "bg-rose-400", icon: "✕" },
  };

  const rankColors = [
    "from-amber-400 to-yellow-500",
    "from-stone-400 to-stone-500",
    "from-orange-400 to-amber-500",
    "from-stone-300 to-stone-400",
    "from-stone-300 to-stone-400",
  ];
</script>

<svelte:head>
  <title>Mundial Food — Admin</title>
  <meta
    name="description"
    content="Panel de administración y analíticas del Mundial Food"
  />
</svelte:head>

<main class="container mx-auto px-4 pt-20 pb-10 max-w-7xl">
    <!-- ── PAGE HEADER ─────────────────── -->
    <div
      class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-8"
    >
      <div>
        <p
          class="text-[10px] font-bold uppercase tracking-[0.2em] text-orange-500 mb-1"
        >
          Dashboard
        </p>
        <h1 class="text-3xl font-extrabold text-neutral-100 tracking-tight">
          Panel de Control 🛡️
        </h1>
        <p class="text-neutral-500 text-xs mt-1 font-medium italic">
          Analíticas en tiempo real · Mundial Food 2026
        </p>
      </div>

      <!-- Live indicator -->
      <div
        class="flex items-center gap-2 px-4 py-2 rounded-2xl
                  bg-neutral-900/40 backdrop-blur-sm border border-white/10 self-start sm:self-center shadow-lg"
      >
        <span class="relative flex h-2.5 w-2.5">
          <span
            class="animate-ping absolute inline-flex h-full w-full rounded-full bg-emerald-400 opacity-75"
          ></span>
          <span
            class="relative inline-flex rounded-full h-2.5 w-2.5 bg-emerald-500"
          ></span>
        </span>
        <span class="text-[10px] font-bold uppercase tracking-wider text-emerald-400">En vivo</span>
      </div>
    </div>

    <!-- ── ALERT BANNER ─────────────────── -->
    <div
      class="flex items-center gap-3 p-4 mb-6 rounded-2xl
                bg-amber-500/10 backdrop-blur-sm
                border border-amber-500/20
                shadow-[0_4px_20px_rgba(245,158,11,0.1)]"
    >
      <div
        class="w-9 h-9 rounded-xl bg-amber-500 flex items-center justify-center text-white text-sm flex-shrink-0 shadow-lg shadow-amber-900/20"
      >
        ⚠️
      </div>
      <p class="text-sm text-amber-200/80 flex-1 italic leading-relaxed">
        <strong>2 comerciantes</strong> pendientes · 
        <strong>3 tickets</strong> sin resolver
      </p>
      <button
        class="px-4 py-1.5 rounded-xl text-[10px] font-bold uppercase tracking-wider
                     bg-amber-500 text-white hover:bg-amber-600
                     transition-transform duration-200 hover:scale-105 active:scale-95 flex-shrink-0"
      >
        Revisar
      </button>
    </div>

    <!-- ── STATS TABS ────────────────────── -->
    <div
      class="flex gap-2 p-1.5 bg-neutral-900/40 backdrop-blur-md border border-white/10
                rounded-2xl shadow-xl w-fit mb-6"
    >
      {#each [{ id: "general", label: "📊 General" }, { id: "zonas", label: "🗺️ Por Zonas" }] as s}
        <button
          onclick={() => {
            activeSection = s.id as typeof activeSection;
          }}
          class="px-4 py-2 rounded-xl text-[10px] font-bold uppercase tracking-widest transition-all duration-400
                 {activeSection === s.id
            ? 'bg-orange-500 text-white shadow-lg shadow-orange-950/20'
            : 'text-neutral-500 hover:text-neutral-300 hover:bg-white/5'}"
        >
          {s.label}
        </button>
      {/each}
    </div>

    <!-- Stats grid -->
    {#if activeSection === "general"}
      <div class="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-6 gap-4 mb-8">
        {#each statsGlobales as stat}
          <StatsCard {...stat} />
        {/each}
      </div>
    {:else}
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-4 mb-8">
        {#each ventasPorZona as stat}
          <StatsCard {...stat} />
        {/each}
      </div>
    {/if}

    <!-- ── CHARTS ROW ─────────────────────── -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-8">
      <!-- Top platillos -->
      <div
        class="bg-neutral-900/60 backdrop-blur-xl border border-white/10
                  shadow-2xl rounded-2xl p-5"
      >
        <h2 class="font-bold text-neutral-100 mb-6 flex items-center gap-2">
          <span class="text-lg">🏆</span> Top Platillos
        </h2>
        <div class="space-y-3">
          {#each topPlatillos as item}
            <div class="flex items-center gap-3 group">
              <div
                class="w-8 h-8 rounded-xl flex items-center justify-center text-xs font-extrabold
                          text-white bg-gradient-to-br {rankColors[
                  item.rank - 1
                ]}
                          shadow-sm flex-shrink-0
                          group-hover:scale-110 transition-transform duration-200"
              >
                {item.rank}
              </div>
              <div class="flex-1 min-w-0">
                <p class="text-sm font-bold text-neutral-100 truncate">
                  {item.name}
                </p>
                <p class="text-[10px] font-bold uppercase tracking-tight text-neutral-500 truncate">
                  {item.restaurante}
                </p>
              </div>
              <span class="text-sm font-extrabold text-orange-500 flex-shrink-0"
                >{item.ventas}</span
              >
            </div>
          {/each}
        </div>
      </div>

      <!-- Actividad reciente -->
      <div
        class="lg:col-span-2 bg-neutral-900/60 backdrop-blur-xl border border-white/10
                  shadow-2xl rounded-2xl p-5"
      >
        <h2 class="font-bold text-neutral-100 mb-6 flex items-center gap-2">
          <span class="text-lg">🕒</span> Actividad Reciente
        </h2>
        <div class="space-y-0 divide-y divide-stone-100/80">
          {#each actividad as ev}
            {@const style = activityStyle[ev.type]}
            <div class="flex items-start gap-3 py-3 group">
              <div
                class="w-6 h-6 rounded-full {style.dot} flex items-center justify-center
                          text-white text-[10px] font-bold flex-shrink-0 mt-0.5"
              >
                {style.icon}
              </div>
              <div class="flex-1 min-w-0">
                <p class="text-sm text-stone-700">
                  {ev.msg} ·
                  <span class="font-semibold">{ev.who}</span>
                </p>
                <p class="text-[11px] text-stone-400 mt-0.5">{ev.time}</p>
              </div>
            </div>
          {/each}
        </div>
      </div>
    </div>

    <!-- ── DATA TABLE ─────────────────────── -->
    <div
      class="bg-neutral-900/60 backdrop-blur-xl border border-white/10
                shadow-2xl rounded-2xl p-5 mb-8"
    >
      <div class="flex items-center justify-between mb-6">
        <h2 class="font-bold text-neutral-100 flex items-center gap-2">
          <span>📋</span> Comerciantes Registrados
        </h2>
        <button
          class="px-4 py-2 rounded-xl text-xs font-bold
                       bg-orange-500 text-white hover:bg-orange-600
                       transition-colors duration-200 shadow-sm"
        >
          + Registrar
        </button>
      </div>
      <DataTable data={comerciantes} />
    </div>
  </main>
