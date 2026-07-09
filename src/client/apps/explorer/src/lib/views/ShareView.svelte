<script lang="ts">
  import { QRCode, m, ICONS, GlassCard, GlassContainer } from "@sdk/ui";
  import { Share2, Download, Printer, MessageCircle, Send, Link, Mail, BarChart3 } from "lucide-svelte";

  const appUrl = "https://xibalba.app/explore";

  const shareOptions = [
    { label: "WhatsApp", Icon: MessageCircle, color: "bg-[#25D366]", textColor: "text-white" },
    { label: "Telegram", Icon: Send, color: "bg-[#0088cc]", textColor: "text-white" },
    { label: "Email", Icon: Mail, color: "bg-base-content/10", textColor: "text-base-content" },
    { label: "Copiar Link", Icon: Link, color: "bg-primary/10", textColor: "text-primary" }
  ];

  const stats = [40, 70, 45, 90, 65, 80, 55]; // Last 7 days scans
</script>

<main class="flex-1 flex flex-col items-center justify-center px-4 py-8 bg-transparent relative overflow-hidden animate-in fade-in zoom-in duration-1000">
  <!-- 3.12.1 — Animated Background Blobs -->
  <div class="absolute top-[10%] left-[-10%] w-[40%] h-[40%] bg-primary/10 blur-[120px] rounded-full pointer-events-none animate-pulse"></div>
  <div class="absolute bottom-[-10%] right-[-10%] w-[40%] h-[40%] bg-secondary/10 blur-[120px] rounded-full pointer-events-none animate-pulse delay-700"></div>

  <div class="w-full max-w-lg space-y-10 relative z-10">
    <!-- Main QR Card -->
    <GlassCard 
      class="!rounded-[3rem] shadow-[0_50px_100px_-20px_rgba(0,0,0,0.4)] border border-white/10 p-10 flex flex-col items-center gap-8 group print:shadow-none print:border-none"
    >
      <!-- Brand mark -->
      <div class="flex items-center gap-4">
        <div class="w-14 h-14 rounded-2xl bg-primary flex items-center justify-center shadow-2xl shadow-primary/30 text-primary-content group-hover:rotate-12 transition-transform duration-500">
          <ICONS.brand size={32} />
        </div>
        <div class="text-left">
           <h1 class="text-3xl font-black italic uppercase tracking-tighter text-base-content leading-none">{m.app_name()}</h1>
           <span class="text-[10px] font-black uppercase tracking-widest opacity-40 italic">Mundial 2026 Edition</span>
        </div>
      </div>

      <!-- QR Code with Blur Halo -->
      <div class="relative p-8 bg-white rounded-[3rem] shadow-2xl group-hover:scale-105 transition-transform duration-700">
        <div class="absolute inset-0 bg-primary/10 blur-2xl rounded-full opacity-0 group-hover:opacity-100 transition-opacity"></div>
        <QRCode url={appUrl} size={280} />
      </div>

      <div class="text-center space-y-2">
         <p class="text-base-content/70 text-sm font-medium leading-relaxed italic max-w-xs mx-auto">
            "Escanea para descubrir la mejor comida local y misticismo maya durante el Mundial 2026."
         </p>
         <div class="flex items-center justify-center gap-3 py-2">
            <div class="h-px w-8 bg-base-content/10"></div>
            <span class="text-[9px] font-black uppercase tracking-[0.3em] opacity-30">Abre tu cámara</span>
            <div class="h-px w-8 bg-base-content/10"></div>
         </div>
      </div>
    </GlassCard>

    <!-- 3.11.1 — Social Share Buttons Row -->
    <div class="grid grid-cols-2 sm:grid-cols-4 gap-4">
       {#each shareOptions as { label, Icon, color, textColor }}
         <button class="group flex flex-col items-center gap-3">
            <div class="w-14 h-14 rounded-2xl {color} {textColor} flex items-center justify-center shadow-xl group-hover:-translate-y-2 transition-all duration-500 group-active:scale-95">
               <Icon size={24} />
            </div>
            <span class="text-[10px] font-black uppercase tracking-widest opacity-40 group-hover:opacity-100 transition-opacity">
               {label}
            </span>
         </button>
       {/each}
    </div>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
       <!-- 3.11.2 — Download as Image Button -->
       <button class="btn btn-outline btn-primary rounded-[2rem] h-auto py-5 px-8 font-black uppercase tracking-widest text-[10px] flex items-center gap-3 shadow-xl hover:shadow-primary/20 transition-all">
          <Download size={18} /> Descargar como Imagen
       </button>
       
       <button 
         onclick={() => window.print()}
         class="btn btn-neutral rounded-[2rem] h-auto py-5 px-8 font-black uppercase tracking-widest text-[10px] flex items-center gap-3 shadow-xl hover:shadow-neutral/20 transition-all print:hidden"
       >
          <Printer size={18} /> Imprimir Póster
       </button>
    </div>

    <!-- 3.11.3 — Usage Stats -->
    <GlassContainer class="p-8 !rounded-[3rem] border border-white/5 shadow-2xl overflow-hidden group">
       <div class="flex items-center justify-between mb-8">
          <div>
             <h3 class="text-[10px] font-black uppercase tracking-widest opacity-40 mb-1">Impacto Global</h3>
             <p class="text-xl font-black italic uppercase tracking-tighter">Alcance del QR</p>
          </div>
          <div class="text-right">
             <span class="text-3xl font-black text-primary animate-pulse">47</span>
             <span class="text-[10px] font-bold opacity-30 block uppercase tracking-widest">Escaneos Totales</span>
          </div>
       </div>

       <div class="flex items-end justify-between gap-2 h-20 px-1">
          {#each stats as h, i}
            <div class="flex-1 flex flex-col items-center gap-2">
               <div 
                 class="w-full bg-primary/20 rounded-t-lg transition-all duration-1000 ease-out delay-{i*100} group-hover:bg-primary/40" 
                 style="height: {h}%"
               ></div>
               <span class="text-[8px] font-black uppercase tracking-widest opacity-20">{"DLMMJVS"[i]}</span>
            </div>
          {/each}
       </div>
    </GlassContainer>
  </div>
</main>

<style>
  @media print {
    main {
       background: white !important;
       padding: 0 !important;
    }
  }
</style>
