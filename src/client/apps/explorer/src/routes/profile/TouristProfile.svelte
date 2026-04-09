<script lang="ts">
  import { ICONS, m } from "@sdk/ui";
  import { authStore } from "@sdk/state";
</script>

<div class="space-y-8 pb-12">
  <section class="glass p-6 md:p-10 rounded-3xl border border-white/5 shadow-2xl flex flex-col md:flex-row items-center gap-6">
    <div class="w-24 h-24 md:w-32 md:h-32 rounded-full bg-secondary/20 flex items-center justify-center border-4 border-secondary/50 shadow-[0_0_20px_rgba(var(--secondary),0.3)]">
      <ICONS.user size={48} class="text-secondary" />
    </div>
    <div class="text-center md:text-left">
      <h2 class="text-3xl font-black tracking-tight">{authStore.user?.email || "Turista Aventurero"}</h2>
      <div class="mt-3 flex flex-wrap gap-2 justify-center md:justify-start">
        <span class="badge badge-secondary badge-lg font-bold">Nivel 1</span>
        <span class="badge badge-outline border-white/20">Explorador Novato</span>
      </div>
    </div>
  </section>

  <section class="grid grid-cols-1 md:grid-cols-2 gap-6">
    <div class="glass p-6 rounded-3xl border border-white/5 hover:border-secondary/30 transition-colors group cursor-pointer">
      <div class="w-12 h-12 rounded-xl bg-secondary/20 flex items-center justify-center mb-4 group-hover:scale-110 transition-transform">
        <ICONS.star size={24} class="text-secondary"/>
      </div>
      <h3 class="font-bold text-xl mb-2">Tus Favoritos</h3>
      <p class="text-sm opacity-60">Agrega negocios y menús a tu lista para visitar durante el evento.</p>
      <a href="/saved" class="btn btn-secondary btn-sm mt-6 w-full md:w-auto">Ver Colección</a>
    </div>
    
    <div class="glass p-6 rounded-3xl border border-white/5 hover:border-accent/30 transition-colors group cursor-pointer">
      <div class="w-12 h-12 rounded-xl bg-accent/20 flex items-center justify-center mb-4 group-hover:scale-110 transition-transform">
        <ICONS.radio size={24} class="text-accent"/>
      </div>
      <h3 class="font-bold text-xl mb-2">Alertas e Intereses</h3>
      <p class="text-sm opacity-60">Personaliza tus notificaciones sobre comida cerca del estadio.</p>
      <button class="btn btn-outline btn-accent btn-sm mt-6 w-full md:w-auto">Configurar</button>
    </div>
  </section>
</div>
