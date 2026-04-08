<script lang="ts">
  import { QRCode, m, ICONS } from "@sdk/ui";

  const appUrl = "http://3.141.197.76:4173";
</script>

<svelte:head>
  <title>Comparte Xibalbá</title>
</svelte:head>

<div
  class="flex-1 flex flex-col items-center justify-center px-4 py-12 bg-gradient-to-b from-base-100 to-base-200"
>
  <!-- Card -->
  <div
    class="bg-base-100 rounded-3xl shadow-2xl shadow-primary/10 border border-base-content/5 p-8 md:p-12 max-w-sm w-full flex flex-col items-center gap-6 print:shadow-none print:border-none"
  >
    <!-- Brand mark -->
    <div class="flex items-center gap-2">
      <div
        class="w-10 h-10 rounded-xl bg-primary flex items-center justify-center shadow-lg shadow-primary/20 text-primary-content"
      >
        <ICONS.brand size={22} />
      </div>
      <span class="text-2xl font-black tracking-tighter text-base-content">
        {m.app_name()}
      </span>
    </div>

    <!-- Headline -->
    <p class="text-center text-base-content/70 text-sm leading-relaxed">
      Escanea para descubrir la mejor comida local durante el Mundial 2026
    </p>

    <!-- QR Code -->
    <QRCode url={appUrl} size={300} />

    <!-- CTA hint -->
    <div
      class="flex items-center gap-2 text-xs text-base-content/40 font-medium"
    >
      <span class="inline-block w-5 h-px bg-base-content/20"></span>
      Abre la cámara y apunta aquí
      <span class="inline-block w-5 h-px bg-base-content/20"></span>
    </div>

    <!-- URL fallback for print -->
    <p
      class="hidden print:block text-[10px] text-base-content/50 break-all text-center"
    >
      {appUrl}
    </p>
  </div>

  <!-- Print button (hidden on print) -->
  <button
    onclick={() => window.print()}
    class="mt-6 btn btn-sm btn-ghost text-base-content/50 print:hidden"
  >
    Imprimir para póster / tarjeta de mesa
  </button>
</div>
