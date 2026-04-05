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
  }}
  plugins={[LayoutPlugin, PalettesPlugin, MoneyPlugin]}
  onThemeChange={handleThemeChange}
  onLanguageChange={handleLanguageChange}
>
  <div
    class="min-h-screen bg-neutral-950 text-neutral-100 flex flex-col selection:bg-orange-500/30"
  >
    <!-- Top Brand Bar -->
    <header
      class="sticky top-0 z-[100] bg-neutral-950/80 backdrop-blur-xl border-b border-white/5 px-4 py-3"
    >
      <div class="container mx-auto flex items-center justify-between">
        <div class="flex items-center gap-2">
          <div
            class="w-8 h-8 rounded-lg bg-gradient-to-br from-orange-500 to-amber-600 flex items-center justify-center shadow-lg shadow-orange-900/20 text-white"
          >
            <ICONS.brand size={18} />
          </div>
          <span
            class="text-xl font-black tracking-tighter bg-gradient-to-r from-white to-neutral-400 bg-clip-text text-transparent"
          >
            {m.app_name()}
          </span>
        </div>

        <div class="flex items-center gap-3">
          <!-- Rune Lab Global Selectors -->
          <div
            class="flex items-center gap-1 bg-white/5 rounded-xl border border-white/10 px-1 py-0.5"
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
            class="text-[10px] font-bold uppercase tracking-widest px-3 py-1.5 rounded-xl bg-white/5 border border-white/10 hover:bg-rose-500/10 hover:text-rose-400 transition-all duration-300"
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
