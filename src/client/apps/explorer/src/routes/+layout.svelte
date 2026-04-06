<script lang="ts">
  import "./layout.css";
  import {
    RuneProvider as RP,
    MoneyPlugin,
    localStorageDriver,
    ThemeSelector,
    LanguageSelector,
    CurrencySelector,
  } from "rune-lab";
  import { createAuthStore } from "@sdk/state";
  import { goto } from "$app/navigation";
  import { m, ICONS } from "@sdk/ui";
  import { setLocale } from "$lib/paraglide/runtime";

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
</script>

<RuneProvider
  config={{
    app: { name: "Xibalbá", version: "1.0.0" },
    persistence: localStorageDriver,
    dictionary: m,
    "rune-lab.money": moneyConfig,
  }}
  plugins={[MoneyPlugin]}
  onLanguageChange={(l) => setLocale(l.code)}
>
  <div
    class="min-h-screen bg-base-100 text-base-content flex flex-col selection:bg-primary/30"
  >
    <!-- Top Brand Bar -->
    <header
      class="sticky top-0 z-[100] bg-base-100/80 backdrop-blur-xl border-b border-base-content/5 px-4 py-3"
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
