<script lang="ts">
  import "./layout.css";
  import {
    RuneProvider as RP,
    LayoutPlugin,
    PalettesPlugin,
    MoneyPlugin,
    localStorageDriver,
    ThemeSelector,
    LanguageSelector,
    CurrencySelector,
  } from "rune-lab";
  import { createAuthStore } from "@sdk/state";
  import { goto } from "$app/navigation";
  import { m, ICONS } from "@sdk/ui";

  const RuneProvider: any = RP;

  let { children } = $props();
  const auth = createAuthStore();

  const moneyConfig = {
    defaultCurrency: "USD",
    // Provide explicit currency definitions to ensure the store is not empty
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
      customThemes: [{ name: "mundial", icon: "🌐" }],
    },
  }}
  plugins={[LayoutPlugin, PalettesPlugin, MoneyPlugin]}
  onThemeChange={handleThemeChange}
  onLanguageChange={handleLanguageChange}
>
  <div
    class="min-h-screen bg-transparent text-base-content flex flex-col selection:bg-primary/30 relative z-0"
  >
    <!-- GLOBAL DYNAMIC BACKGROUND (Optimized & Theme-Aware) -->
    <div
      class="fixed inset-0 -z-10 overflow-hidden pointer-events-none bg-base-100"
    >
      <div
        class="absolute inset-0 bg-gradient-to-br from-base-100 via-base-200 to-base-100 dark:from-base-300 dark:via-base-200"
      ></div>

      <!-- Animated Blobs using GPU acceleration and semantic DaisyUI colors -->
      <div
        class="absolute -top-40 -right-40 w-[550px] h-[550px] bg-primary/20 rounded-full blur-[100px] animate-[pulse_9s_ease-in-out_infinite] transform-gpu"
      ></div>
      <div
        class="absolute top-1/2 -left-32 w-[440px] h-[440px] bg-secondary/20 rounded-full blur-[100px] animate-[pulse_12s_ease-in-out_3s_infinite] transform-gpu"
      ></div>
      <div
        class="absolute -bottom-20 right-1/3 w-[360px] h-[360px] bg-accent/15 rounded-full blur-[100px] animate-[pulse_10s_ease-in-out_1.5s_infinite] transform-gpu"
      ></div>

      <!-- Semantic dot grid using theme's base-content color -->
      <div
        class="absolute inset-0 opacity-[0.03] dark:opacity-[0.05]"
        style="background-image: radial-gradient(circle, var(--fallback-bc,oklch(var(--bc)/1)) 1px, transparent 0); background-size: 40px 40px;"
      ></div>
    </div>
    <!-- Top Brand Bar -->
    <header
      class="sticky top-0 z-[100] bg-base-100/20 backdrop-blur-xl border-b border-base-content/5 px-4 py-3"
    >
      <div class="container mx-auto flex items-center justify-between">
        <div class="flex items-center gap-2">
          <div
            class="w-8 h-8 rounded-lg bg-primary flex items-center justify-center shadow-lg shadow-primary/20 text-primary-content"
          >
            <ICONS.brand size={18} />
          </div>
          <span class="text-xl font-black tracking-tighter text-base-content">
            {m.app_name()}
          </span>
        </div>

        <div class="flex items-center gap-3">
          <!-- Rune Lab Global Selectors -->
          <div
            class="flex items-center gap-1 bg-base-content/5 rounded-xl border border-base-content/10 px-1 py-0.5"
          >
            <ThemeSelector />
            <LanguageSelector />
            <CurrencySelector />
          </div>

          <button
            onclick={() => {
              auth.logout();
              goto("/login");
            }}
            class="text-[10px] font-bold uppercase tracking-widest px-3 py-1.5 rounded-xl bg-base-content/5 border border-base-content/10 hover:bg-error/10 hover:text-error transition-all duration-300"
          >
            {m.nav_logout()}
          </button>
        </div>
      </div>
    </header>

    <!-- Main Content Area -->
    <div class="flex-1 flex flex-col pb-20 md:pb-0">
      {@render children()}
    </div>
  </div>
</RuneProvider>
