<script lang="ts">
  import { HeroCarousel, RoleCards, Navbar, Footer, BottomNav } from "@sdk/ui";
  import { ThemeSelector, LanguageSelector, CurrencySelector } from "rune-lab";
</script>

<div
  class="min-h-screen bg-transparent text-base-content flex flex-col selection:bg-primary/30 relative z-0"
>
  <!-- Componente centralizado de Animación y Tramado -->
  <ThemeSelector />
  <LanguageSelector />
  <CurrencySelector />

  <!-- Componente centralizado de Barra Superior y Perfil -->
  <Navbar />

  <!-- Área de Contenido Principal -->
  <div class="flex-1 flex flex-col pb-24 md:pb-0 relative z-10">
    <div class="flex flex-col w-full">
      <HeroCarousel />
      <RoleCards />
    </div>

    <!-- Componente centralizado de Pie de Página -->
    <Footer />
  </div>
</div>

<!-- Mobile Floating Navigation -->
<BottomNav />

<!-- </RuneProvider> -->

<style>
  :global(html) {
    scroll-behavior: smooth;
  }
</style>
