<script lang="ts">
  import { page } from "$app/state";
  import Navbar from "$lib/components/ui/Navbar.svelte";
  import Footer from "$lib/components/ui/Footer.svelte";
  import "../layout.css";

  let { children } = $props();

  // Obtenemos el rol desde los datos de la página (cargados en +page.ts)
  const role = $derived(page.data.role);
</script>

<!-- ═══════════════════════════════════════════════
     DARK GLASS GLOBAL BACKGROUND
════════════════════════════════════════════════ -->
<div class="fixed inset-0 -z-10 overflow-hidden pointer-events-none bg-black">
  <!-- Base dark gradient -->
  <div
    class="absolute inset-0 bg-gradient-to-br from-neutral-950 via-stone-900 to-neutral-950"
  ></div>

  <!-- Animated Blobs -->
  <div
    class="absolute -top-40 -right-40 w-[550px] h-[550px] bg-red-600/20 rounded-full blur-[100px] animate-[pulse_9s_ease-in-out_infinite]"
  ></div>
  <div
    class="absolute top-1/2 -left-32 w-[440px] h-[440px] bg-orange-500/20 rounded-full blur-[100px] animate-[pulse_12s_ease-in-out_3s_infinite]"
  ></div>
  <div
    class="absolute -bottom-20 right-1/3 w-[360px] h-[360px] bg-amber-500/15 rounded-full blur-[100px] animate-[pulse_10s_ease-in-out_1.5s_infinite]"
  ></div>

  <!-- Subtle star/dot grid -->
  <div
    class="absolute inset-0 opacity-[0.05]"
    style="background-image:radial-gradient(circle,#ffffff 1px,transparent 0);background-size:40px 40px;"
  ></div>
</div>

<div class="min-h-screen flex flex-col font-sans selection:bg-orange-500/30 selection:text-orange-200">
  <!-- Global Navbar -->
  <Navbar {role} />

  <!-- Page Content -->
  <main class="flex-1">
    {@render children()}
  </main>

  <!-- Global Footer -->
  <Footer />
</div>

<style>
  :global(html) {
    scroll-behavior: smooth;
    background-color: #000;
  }
</style>
