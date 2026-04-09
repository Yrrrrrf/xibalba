<script lang="ts">
  import { authStore } from "@sdk/state";
  import { AdminDashboard, ICONS, m } from "@sdk/ui";



  let adminMerchants = $state([
    { id: "m1", name: "Tacos El Rey", category: "Comida Mexicana", status: "active", reports: 0 },
    { id: "m2", name: "Helados La Michoacana", category: "Postres", status: "active", reports: 2 },
    { id: "m3", name: "Pizzería Nápoles", category: "Comida Italiana", status: "pending", reports: 0 },
    { id: "m4", name: "Cervecería Mundial", category: "Bares", status: "suspended", reports: 5 }
  ]);
</script>

<svelte:head>
  <title>Panel de Administración — {m.app_name()}</title>
</svelte:head>

<main class="container mx-auto px-4 pt-6 pb-10 max-w-5xl animate-in fade-in slide-in-from-bottom-4 duration-700">
  <div class="mb-8 flex items-center justify-between">
    <div>
      <h1 class="text-3xl font-extrabold text-base-content tracking-tight flex items-center gap-3">
        Centro de Control General
        <ICONS.admin size={32} class="text-error" />
      </h1>
      <p class="text-base-content/50 text-xs mt-1 font-medium italic">
        Supervisión global de la plataforma Xibalbá
      </p>
    </div>
  </div>

  <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-8">
    <!-- Quick Stats Cards for Admin -->
    <div class="card bg-base-100 shadow-xl border border-white/5">
      <div class="card-body p-5 flex flex-row items-center gap-4">
        <div class="w-12 h-12 rounded-xl bg-primary/20 text-primary flex items-center justify-center">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" /></svg>
        </div>
        <div>
          <p class="text-[10px] font-bold uppercase tracking-widest text-base-content/50">Usuarios Activos</p>
          <p class="text-3xl font-black">12,450</p>
        </div>
      </div>
    </div>
    
    <div class="card bg-base-100 shadow-xl border border-white/5">
      <div class="card-body p-5 flex flex-row items-center gap-4">
        <div class="w-12 h-12 rounded-xl bg-secondary/20 text-secondary flex items-center justify-center">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" /></svg>
        </div>
        <div>
          <p class="text-[10px] font-bold uppercase tracking-widest text-base-content/50">Negocios en Plataforma</p>
          <p class="text-3xl font-black">{adminMerchants.length}</p>
        </div>
      </div>
    </div>
    
    <div class="card bg-base-100 shadow-xl border border-white/5">
      <div class="card-body p-5 flex flex-row items-center gap-4">
        <div class="w-12 h-12 rounded-xl bg-error/20 text-error flex items-center justify-center">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" /></svg>
        </div>
        <div>
          <p class="text-[10px] font-bold uppercase tracking-widest text-base-content/50">Reportes Pendientes</p>
          <p class="text-3xl font-black">{adminMerchants.reduce((a, b) => a + (b.reports || 0), 0)}</p>
        </div>
      </div>
    </div>
  </div>

  <div class="card glass bg-base-100/50 shadow-2xl border border-white/10">
    <div class="card-body p-6">
      <div class="mb-4">
        <h2 class="card-title text-xl font-bold">Gestión de Comercios</h2>
        <p class="text-xs text-base-content/60">Aprueba o suspende cuentas que infrinjan políticas.</p>
      </div>
      <AdminDashboard 
        merchants={adminMerchants as any}
        onApprove={(id) => adminMerchants = adminMerchants.map(m => m.id === id ? {...m, status: 'active'} : m)}
        onSuspend={(id) => adminMerchants = adminMerchants.map(m => m.id === id ? {...m, status: 'suspended'} : m)}
      />
    </div>
  </div>
</main>
