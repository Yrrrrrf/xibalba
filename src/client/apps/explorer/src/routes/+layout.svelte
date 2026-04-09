<script lang="ts">
  import "./layout.css";
  import {
    RuneProvider,
    LayoutPlugin,
    PalettesPlugin,
    MoneyPlugin,
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
      "rune-lab.layout": {
        customThemes: [
          // --- Group A ---
          { name: "mexico", icon: "🇲🇽" },
          { name: "south-africa", icon: "🇿🇦" },
          { name: "south-korea", icon: "🇰🇷" },
          { name: "playoff-d", icon: "⚽" },

          // --- Group B ---
          { name: "canada", icon: "🇨🇦" },
          { name: "playoff-a", icon: "⚽" },
          { name: "qatar", icon: "🇶🇦" },
          { name: "switzerland", icon: "🇨🇭" },

          // --- Group C ---
          { name: "brazil", icon: "🇧🇷" },
          { name: "morocco", icon: "🇲🇦" },
          { name: "haiti", icon: "🇭🇹" },
          { name: "scotland", icon: "🏴󠁧󠁢󠁳󠁣󠁴󠁿" },

          // --- Group D ---
          { name: "usa", icon: "🇺🇸" },
          { name: "paraguay", icon: "🇵🇾" },
          { name: "australia", icon: "🇦🇺" },
          { name: "playoff-c", icon: "⚽" },

          // --- Group E ---
          { name: "germany", icon: "🇩🇪" },
          { name: "curacao", icon: "🇨🇼" },
          { name: "ivory-coast", icon: "🇨🇮" },
          { name: "ecuador", icon: "🇪🇨" },

          // --- Group F ---
          { name: "netherlands", icon: "🇳🇱" },
          { name: "japan", icon: "🇯🇵" },
          { name: "playoff-b", icon: "⚽" },
          { name: "tunisia", icon: "🇹🇳" },

          // --- Group G ---
          { name: "belgium", icon: "🇧🇪" },
          { name: "egypt", icon: "🇪🇬" },
          { name: "iran", icon: "🇮🇷" },
          { name: "new-zealand", icon: "🇳🇿" },

          // --- Group H ---
          { name: "spain", icon: "🇪🇸" },
          { name: "cape-verde", icon: "🇨🇻" },
          { name: "saudi-arabia", icon: "🇸🇦" },
          { name: "uruguay", icon: "🇺🇾" },

          // --- Group I ---
          { name: "france", icon: "🇫🇷" },
          { name: "senegal", icon: "🇸🇳" },
          { name: "playoff-ic2", icon: "⚽" },
          { name: "norway", icon: "🇳🇴" },

          // --- Group J ---
          { name: "argentina", icon: "🇦🇷" },
          { name: "algeria", icon: "🇩🇿" },
          { name: "austria", icon: "🇦🇹" },
          { name: "jordan", icon: "🇯🇴" },

          // --- Group K ---
          { name: "portugal", icon: "🇵🇹" },
          { name: "playoff-ic1", icon: "⚽" },
          { name: "uzbekistan", icon: "🇺🇿" },
          { name: "colombia", icon: "🇨🇴" },

          // --- Group L ---
          { name: "england", icon: "🏴󠁧󠁢󠁥󠁮󠁧󠁿" },
          { name: "croatia", icon: "🇭🇷" },
          { name: "ghana", icon: "🇬🇭" },
          { name: "panama", icon: "🇵🇦" },
        ],
      },
    },
  }}
  plugins={[LayoutPlugin, PalettesPlugin, MoneyPlugin]}
  onLanguageChange={(l) => setLocale(l)}
>
  {@render children()}
</RuneProvider>
