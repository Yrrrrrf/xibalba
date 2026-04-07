<script lang="ts">
  import { ICONS } from "@sdk/ui";
  import { authStore } from "@sdk/state";
</script>

<div class="space-y-8 pb-12">
  <section class="glass p-8 rounded-3xl border border-error/30 flex flex-col items-center md:items-start text-center md:text-left relative overflow-hidden">
    <div class="absolute right-0 top-0 opacity-10 blur-xl pointer-events-none transform translate-x-1/4 -translate-y-1/4">
      <ICONS.admin size={250} class="text-error" />
    </div>
    
    <h2 class="text-3xl font-black text-error flex items-center justify-center md:justify-start gap-4">
      <ICONS.admin size={32} /> Administrador Root
    </h2>
    <p class="opacity-80 mt-3 max-w-lg font-medium">Tienes permisos súper-administrativos en la plataforma local. Ten cuidado con los sistemas de alto riesgo.</p>
    <div class="mt-4 px-4 py-2 bg-error/10 text-error rounded-xl font-mono text-xs font-bold border border-error/20 inline-block">
      SESIÓN VERIFICADA EN MODO GLOBAL
    </div>
  </section>

  <section class="grid grid-cols-1 md:grid-cols-3 gap-6">
    <div class="glass p-6 rounded-3xl border border-error/10 hover:border-error/40 transition-all flex flex-col items-center text-center cursor-pointer hover:-translate-y-1 shadow-lg shadow-error/5">
      <div class="w-16 h-16 rounded-2xl bg-error/10 text-error flex items-center justify-center mb-4">
        <ICONS.clipboard size={32} />
      </div>
      <h3 class="font-black text-lg">Event Logs</h3>
      <p class="text-xs opacity-60 mt-2 font-medium">1,245 accesos y eventos anómalos detectados hoy.</p>
    </div>
    
    <div class="glass p-6 rounded-3xl border border-error/10 hover:border-error/40 transition-all flex flex-col items-center text-center cursor-pointer hover:-translate-y-1 shadow-lg shadow-error/5">
      <div class="w-16 h-16 rounded-2xl bg-error/10 text-error flex items-center justify-center mb-4">
        <ICONS.store size={32} />
      </div>
      <h3 class="font-black text-lg">Aprobación Negocios</h3>
      <p class="text-xs opacity-60 mt-2 font-medium">12 altas de comerciantes en espera de revisión fiscal.</p>
    </div>

    <div class="glass p-6 rounded-3xl border border-error/10 hover:border-error/40 transition-all flex flex-col items-center text-center cursor-pointer hover:-translate-y-1 shadow-lg shadow-error/5">
      <div class="w-16 h-16 rounded-2xl bg-error/10 text-error flex items-center justify-center mb-4">
        <ICONS.ban size={32} />
      </div>
      <h3 class="font-black text-lg">Sanitizador AI</h3>
      <p class="text-xs opacity-60 mt-2 font-medium">Listas negras de IP y filtros de contenido para Mundial.</p>
    </div>
  </section>
</div>
