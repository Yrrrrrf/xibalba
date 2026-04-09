<script lang="ts">
  import "./layout.css";
  import {
    RuneProvider,
    LayoutPlugin,
    PalettesPlugin,
    MoneyPlugin,
    type NavigationSection,
    version,
  } from "rune-lab";
  import { setLocale } from "$lib/i18n/paraglide/runtime";

  let { children } = $props();
</script>

<!-- <RuneProvider
  config={{
    app: { name: "Xibalbá", version: "1.0.0" },
    persistence: localStorageDriver,
    dictionary: m,
    "rune-lab.money": moneyConfig,
    // "rune-lab.layout": {
    //   customThemes: [
    //     { name: "mundial", icon: "🌍" },
    //     { name: "argentina", icon: "🥩" },
    //     { name: "brasil", icon: "🍖" },
    //     { name: "mexico", icon: "🌮" },
    //     { name: "usa", icon: "🍔" },
    //     { name: "francia", icon: "🥐" },
    //     { name: "inglaterra", icon: "🥧" },
    //     { name: "espana", icon: "🥘" },
    //     { name: "alemania", icon: "🥨" },
    //     { name: "portugal", icon: "🍮" },
    //     { name: "japon", icon: "🍣" },
    //   ],
    // },
  }}
  plugins={[MoneyPlugin, PalettesPlugin]}
  onLanguageChange={(l: any) => setLocale(l.code)}
> -->

<RuneProvider
  config={{
    favicon: "/img/rune.png",
    app: {
      name: "Rune Lab",
      author: "Yrrrrrf",
    },
  }}
  plugins={[LayoutPlugin, PalettesPlugin, MoneyPlugin]}
  onLanguageChange={(l) => setLocale(l)}
>
  {@render children()}
</RuneProvider>
