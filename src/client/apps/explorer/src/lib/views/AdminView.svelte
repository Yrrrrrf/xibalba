<script lang="ts">
  import { authStore } from "@sdk/state";
  import { AdminDashboard, ICONS, m, GlassCard, GlassContainer } from "@sdk/ui";
  import { Activity, Shield, Cpu, Zap, Database, Globe, AlertTriangle, CheckCircle, XCircle } from "lucide-svelte";

  let adminMerchants = $state([
    { id: "m1", name: "Tacos El Rey", category: "Comida Mexicana", status: "active", reports: 0 },
    { id: "m2", name: "Helados La Michoacana", category: "Postres", status: "active", reports: 2 },
    { id: "m3", name: "Pizzería Nápoles", category: "Comida Italiana", status: "pending", reports: 0 },
    { id: "m4", name: "Cervecería Mundial", category: "Bares", status: "suspended", reports: 5 }
  ]);

  const healthMetrics = [
    { label: "Uptime", value: "99.9%", Icon: Activity, color: "text-success" },
    { label: "Latencia", value: "42ms", Icon: Zap, color: "text-success" },
    { label: "Sesiones", value: "1,234", Icon: Globe, color: "text-info" },
    { label: "Errores 24h", value: "3", Icon: AlertTriangle, color: "text-warning" },
    { label: "Caché Hit", value: "94%", Icon: Database, color: "text-success" }
  ];

  const logs = [
    { time: "14:22:01", type: "INFO", msg: "Nuevo registro de comercio: 'Café Maya'" },
    { time: "14:15:45", type: "WARN", msg: "Intento de login fallido desde IP 189.x.x.x" },
    { time: "14:10:12", type: "INFO", msg: "Backup diario completado exitosamente" },
    { time: "13:55:30", type: "ERROR", msg: "Error de conexión en servicio de mapas (reintentando...)" },
    { time: "13:45:00", type: "INFO", msg: "Actualización de certificados SSL realizada" }
  ];

  const zones = [
    { name: "Centro Histórico", value: 89 },
    { name: "Zona Rosa", value: 72 },
    { name: "Coyoacán", value: 65 },
    { name: "Santa Fe", value: 41 },
    { name: "Xochimilco", value: 28 }
  ];

  let pendingMerchants = $derived(adminMerchants.filter(m => m.status === 'pending'));
</script>

<main class="container mx-auto px-4 pt-6 pb-20 max-w-6xl animate-in fade-in slide-in-from-bottom-4 duration-700">
  
  <!-- 3.3.1 — Admin Hero Banner -->
  <div class="mb-10 p-10 rounded-[3rem] bg-gradient-to-r from-error/20 via-neutral/90 to-error/10 border border-error/20 backdrop-blur-2xl relative overflow-hidden group shadow-2xl shadow-error/10">
    <div class="absolute -right-20 -top-20 w-80 h-80 bg-error/20 blur-[120px] rounded-full group-hover:scale-150 transition-transform duration-1000"></div>
    <div class="absolute inset-0 opacity-10 pointer-events-none" style="background-image: radial-gradient(circle at 1px 1px, white 1px, transparent 0); background-size: 20px 20px;"></div>
    
    <div class="relative z-10 flex flex-col md:flex-row items-center gap-10">
      <div class="w-32 h-32 rounded-[2.5rem] bg-error/20 flex items-center justify-center border border-error/30 shadow-2xl group-hover:rotate-12 transition-transform duration-500 drop-shadow-[0_0_20px_rgba(255,0,0,0.4)]">
        <ICONS.admin size={64} class="text-error" strokeWidth={2.5} />
      </div>
      <div>
        <div class="flex items-center gap-3 mb-3">
          <span class="px-4 py-1.5 rounded-full bg-error text-error-content text-[10px] font-black uppercase tracking-[0.2em] border border-error/50">
            Sesión Root Activa
          </span>
          <div class="flex items-center gap-2">
             <div class="w-2 h-2 rounded-full bg-error animate-pulse"></div>
             <span class="text-[10px] font-bold text-error uppercase tracking-widest">Nivel de Acceso: Máximo</span>
          </div>
        </div>
        <h1 class="text-4xl md:text-6xl font-black italic uppercase tracking-[0.2em] text-white mb-2 leading-none">
          Centro de Control
        </h1>
        <p class="text-white/40 font-mono text-xs md:text-sm tracking-widest">
          SYSTEM_VERSION: KRON_V1.2 // SECTOR: GLOBAL_CORE // STATUS: STABLE
        </p>
      </div>
    </div>
  </div>

  <!-- 3.3.2 — Platform Health Dashboard Row -->
  <div class="grid grid-cols-2 md:grid-cols-5 gap-4 mb-10">
    {#each healthMetrics as { label, value, Icon, color }}
      <GlassCard class="p-5 flex flex-col items-center text-center !rounded-[2rem] border border-white/5 shadow-xl hover:-translate-y-1 transition-all duration-300">
        <div class="w-10 h-10 rounded-xl bg-base-content/5 flex items-center justify-center mb-3">
          <Icon size={20} class={color} />
        </div>
        <p class="text-[10px] font-black uppercase tracking-widest opacity-40 mb-1">{label}</p>
        <p class="text-2xl font-black italic tracking-tighter">{value}</p>
      </GlassCard>
    {/each}
  </div>

  <div class="grid grid-cols-1 lg:grid-cols-3 gap-8 mb-12">
    <!-- 3.3.4 — System Event Log Panel -->
    <div class="lg:col-span-1">
      <GlassContainer class="h-full !rounded-[3rem] border border-white/5 shadow-2xl p-8">
        <div class="flex items-center justify-between mb-4">
           <h3 class="text-[10px] font-black uppercase tracking-widest opacity-40">Event Stream</h3>
        </div>
        <div class="mt-4 mb-4 flex items-center gap-2">
          <div class="w-2 h-2 rounded-full bg-success animate-pulse"></div>
          <span class="text-[10px] font-black uppercase tracking-widest opacity-40">Live Log Monitoring</span>
        </div>
        <div class="bg-neutral/90 rounded-[2rem] p-6 font-mono text-[10px] space-y-3 border border-white/10 h-[320px] overflow-hidden relative">
          <div class="absolute inset-x-0 bottom-0 h-20 bg-gradient-to-t from-neutral to-transparent z-10"></div>
          {#each logs as log}
            <div class="flex gap-3">
              <span class="opacity-30 flex-shrink-0">[{log.time}]</span>
              <span class={log.type === 'ERROR' ? 'text-error' : log.type === 'WARN' ? 'text-warning' : 'text-info'}>{log.type}</span>
              <span class="text-white/60 truncate">{log.msg}</span>
            </div>
          {/each}
          <div class="flex gap-3 animate-pulse">
            <span class="opacity-30 flex-shrink-0">[{new Date().toLocaleTimeString()}]</span>
            <span class="text-success">READY</span>
            <span class="text-white/60">Awaiting system broadcast...</span>
          </div>
        </div>
      </GlassContainer>
    </div>

    <!-- 3.3.5 — Geographic Heat Indicator & Other Metrics -->
    <div class="lg:col-span-2 space-y-8">
      <GlassCard class="p-8 !rounded-[3rem] border border-white/5 shadow-2xl overflow-hidden group">
        <div class="flex items-center justify-between mb-8">
           <div>
             <h3 class="text-[10px] font-black uppercase tracking-widest opacity-40 mb-1">Análisis Espacial</h3>
             <p class="text-2xl font-black italic uppercase tracking-tighter">Zonas Más Activas</p>
           </div>
           <Globe class="text-primary opacity-20 group-hover:rotate-12 transition-transform duration-1000" size={48} />
        </div>

        <div class="space-y-6">
          {#each zones as zone}
            <div class="space-y-2">
              <div class="flex justify-between items-end">
                <span class="text-xs font-black uppercase tracking-widest">{zone.name}</span>
                <span class="text-[10px] font-bold opacity-40">{zone.value}% Actividad</span>
              </div>
              <div class="h-3 w-full bg-base-content/5 rounded-full overflow-hidden border border-white/5">
                <div 
                  class="h-full bg-gradient-to-r from-primary/60 to-primary rounded-full transition-all duration-1000 ease-out"
                  style="width: {zone.value}%"
                ></div>
              </div>
            </div>
          {/each}
        </div>
      </GlassCard>

      <div class="grid grid-cols-2 gap-8">
         <GlassCard class="p-6 !rounded-[2.5rem] bg-warning/5 border border-warning/10">
            <div class="flex items-center gap-4 mb-4">
               <div class="w-12 h-12 rounded-2xl bg-warning/20 text-warning flex items-center justify-center">
                  <Shield size={24} />
               </div>
               <div>
                  <p class="text-[10px] font-black uppercase tracking-widest opacity-40">Integridad</p>
                  <p class="text-xl font-black">Nivel 4</p>
               </div>
            </div>
            <p class="text-[10px] font-bold opacity-50 italic">Todos los protocolos de seguridad están activos y verificados.</p>
         </GlassCard>
         <GlassCard class="p-6 !rounded-[2.5rem] bg-info/5 border border-info/10">
            <div class="flex items-center gap-4 mb-4">
               <div class="w-12 h-12 rounded-2xl bg-info/20 text-info flex items-center justify-center">
                  <Cpu size={24} />
               </div>
               <div>
                  <p class="text-[10px] font-black uppercase tracking-widest opacity-40">Carga CPU</p>
                  <p class="text-xl font-black">12%</p>
               </div>
            </div>
            <p class="text-[10px] font-bold opacity-50 italic">Recursos del sistema optimizados. Latencia mínima detectada.</p>
         </GlassCard>
      </div>
    </div>
  </div>

  <!-- 3.3.3 — Merchant Approval Queue with Rich Cards -->
  {#if pendingMerchants.length > 0}
    <div class="mb-12">
      <div class="flex items-center gap-3 mb-8">
        <div class="w-2 h-8 bg-warning rounded-full"></div>
        <h2 class="text-3xl font-black italic uppercase tracking-tighter">Pendientes de Aprobación</h2>
        <span class="badge badge-warning font-black tracking-widest">{pendingMerchants.length}</span>
      </div>

      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        {#each pendingMerchants as m}
          <GlassCard class="p-6 !rounded-[2.5rem] border-l-4 border-warning shadow-xl hover:shadow-warning/10 transition-all group">
            <div class="flex justify-between items-start mb-4">
              <div>
                <h3 class="text-xl font-black italic uppercase tracking-tight group-hover:text-warning transition-colors">{m.name}</h3>
                <p class="text-[10px] font-black uppercase tracking-widest opacity-40">{m.category}</p>
              </div>
              <div class="text-[10px] font-bold opacity-30 italic">Registrado hoy</div>
            </div>
            <p class="text-xs opacity-60 mb-6 leading-relaxed line-clamp-2">
              Solicitud de registro para un nuevo comercio en la categoría {m.category}. Verificar documentos y ubicación antes de aprobar.
            </p>
            <div class="flex gap-3">
              <button class="btn btn-success btn-sm rounded-xl flex-1 font-black uppercase tracking-widest text-[10px] gap-2">
                <CheckCircle size={14} /> Aprobar
              </button>
              <button class="btn btn-error btn-outline btn-sm rounded-xl flex-1 font-black uppercase tracking-widest text-[10px] gap-2">
                <XCircle size={14} /> Rechazar
              </button>
            </div>
          </GlassCard>
        {/each}
      </div>
    </div>
  {/if}

  <!-- Existing Dashboard Table -->
  <div class="opacity-80 flex items-center justify-between mb-8">
    <div class="flex items-center gap-3">
      <div class="w-2 h-8 bg-primary rounded-full"></div>
      <h2 class="text-3xl font-black italic uppercase tracking-tighter">Gestión de Comercios</h2>
    </div>
  </div>
  
  <GlassCard class="p-6 !rounded-[3rem] border border-white/10 shadow-2xl overflow-hidden">
    <div class="mb-6">
      <p class="text-xs text-base-content/60 font-medium italic">Base de datos maestra de negocios registrados en la red Xibalbá.</p>
    </div>
    <AdminDashboard 
      merchants={adminMerchants as any}
      onApprove={(id) => adminMerchants = adminMerchants.map(m => m.id === id ? {...m, status: 'active'} : m)}
      onSuspend={(id) => adminMerchants = adminMerchants.map(m => m.id === id ? {...m, status: 'suspended'} : m)}
    />
  </GlassCard>
</main>
