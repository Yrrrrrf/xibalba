<script lang="ts">
  import "./layout.css";
  import {
    RuneProvider as RP,
    LayoutPlugin,
    PalettesPlugin,
    MoneyPlugin,
    localStorageDriver,
  } from "rune-lab";
  import { m, DynamicBackground, Navbar, Footer, BottomNav } from "@sdk/ui";

  const RuneProvider: any = RP;

  let { children } = $props();

  const moneyConfig = {
    defaultCurrency: "USD",
    currencies: [
      { code: "USD", symbol: "$", decimals: 2 },
      { code: "MXN", symbol: "$", decimals: 2 },
      { code: "EUR", symbol: "€", decimals: 2 },
      { code: "JPY", symbol: "¥", decimals: 0 },
    ],
    exchangeRates: {
      base: "USD",
      rates: {
        MXN: 17.23,
        EUR: 0.91,
        JPY: 151.3,
      },
    },
  };

  function handleThemeChange(newTheme: string) {
    if (typeof document !== "undefined") {
      document.documentElement.setAttribute("data-theme", newTheme);
    }
  }

  function handleLanguageChange(newLang: string, oldLang: string) {
    if (typeof window !== "undefined" && oldLang && newLang !== oldLang) {
      window.location.reload();
    }
  }
</script>

<RuneProvider
  config={{
    app: { name: "Xibalbá", version: "1.0.0" },
    persistence: localStorageDriver,
    dictionary: m,
    "rune-lab.money": moneyConfig,
    "rune-lab.layout": {
      customThemes: [
        { name: "mundial", icon: "🌍" },
        { name: "argentina", icon: "🥩" },
        { name: "brasil", icon: "🍖" },
        { name: "mexico", icon: "🌮" },
        { name: "usa", icon: "🍔" },
        { name: "francia", icon: "🥐" },
        { name: "inglaterra", icon: "🥧" },
        { name: "espana", icon: "🥘" },
        { name: "alemania", icon: "🥨" },
        { name: "portugal", icon: "🍮" },
        { name: "japon", icon: "🍣" },
      ],
    },
  }}
  plugins={[LayoutPlugin, PalettesPlugin, MoneyPlugin]}
  onThemeChange={handleThemeChange}
  onLanguageChange={handleLanguageChange}
>
  <div class="min-h-screen bg-transparent text-base-content flex flex-col selection:bg-primary/30 relative z-0">
    <!-- Componente centralizado de Animación y Tramado -->
    <DynamicBackground />
    
    <!-- Componente centralizado de Barra Superior y Perfil -->
    <Navbar />

    <!-- Área de Contenido Principal -->
    <div class="flex-1 flex flex-col pb-24 md:pb-0 relative z-10">
      <div class="flex-1">
        {@render children()}
      </div>

      <!-- Componente centralizado de Pie de Página -->
      <Footer />
    </div>
  </div>

  <!-- Mobile Floating Navigation -->
  <BottomNav />
</RuneProvider>
