<script lang="ts">
  import { ICONS, m } from "@sdk/ui";

  let { children } = $props();
</script>

<div class="min-h-screen flex flex-col items-center justify-center p-5 bg-base-100 relative overflow-hidden -mt-10">
  
  <!-- 3.12.1 — Animated Drifting Background Blobs -->
  <div class="absolute top-[10%] left-[-10%] w-[50%] h-[50%] bg-primary/20 blur-[120px] rounded-full pointer-events-none animate-blob"></div>
  <div class="absolute bottom-[-10%] right-[-10%] w-[50%] h-[50%] bg-secondary/20 blur-[120px] rounded-full pointer-events-none animate-blob animation-delay-2000"></div>
  <div class="absolute top-[40%] right-[-20%] w-[40%] h-[40%] bg-accent/10 blur-[100px] rounded-full pointer-events-none animate-blob animation-delay-4000"></div>

  <div class="w-full max-w-md animate-in fade-in slide-in-from-bottom-4 duration-700 z-10">
    <!-- Shared Brand Header -->
    <div class="text-center mb-8">
      <a href="/" class="inline-flex flex-col items-center mb-4 group transition-transform hover:scale-105">
        <div class="text-primary drop-shadow-[0_0_20px_rgba(var(--primary),0.4)] group-hover:rotate-12 transition-transform duration-500">
          <ICONS.brand size={64} />
        </div>
        <h1 class="text-3xl font-black italic uppercase tracking-tighter mt-2 text-base-content">{m.app_name()}</h1>
      </a>
    </div>

    <!-- Shared Card Shell -->
    <div class="card glass bg-base-100/40 backdrop-blur-3xl shadow-[0_40px_80px_-20px_rgba(0,0,0,0.5)] border border-white/10 relative overflow-hidden !rounded-[3rem]">
        <!-- Shine effect -->
      <div class="absolute inset-0 bg-gradient-to-br from-white/10 via-transparent to-transparent opacity-30 pointer-events-none"></div>
      
      <div class="card-body p-8 sm:p-12 relative z-10">
        {@render children()}
      </div>
    </div>

    <!-- 3.12.3 — Trust Badges -->
    <div class="mt-8 flex items-center justify-center gap-6 opacity-30 text-[9px] font-black uppercase tracking-[0.3em] text-center">
       <div class="flex items-center gap-1.5">
          <div class="w-1 h-1 rounded-full bg-success"></div>
          Conexión Segura
       </div>
       <div class="flex items-center gap-1.5">
          <div class="w-1 h-1 rounded-full bg-info"></div>
          13+ Idiomas
       </div>
       <div class="flex items-center gap-1.5">
          <div class="w-1 h-1 rounded-full bg-primary"></div>
          Carga &lt;2s
       </div>
    </div>
  </div>
</div>

<style>
  @keyframes blob {
    0% { transform: translate(0px, 0px) scale(1); }
    33% { transform: translate(30px, -50px) scale(1.1); }
    66% { transform: translate(-20px, 20px) scale(0.9); }
    100% { transform: translate(0px, 0px) scale(1); }
  }
  .animate-blob {
    animation: blob 7s infinite alternate;
  }
  .animation-delay-2000 {
    animation-delay: 2s;
  }
  .animation-delay-4000 {
    animation-delay: 4s;
  }
</style>
