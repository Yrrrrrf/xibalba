<script lang="ts">
  import {
    getThemeStore,
    getLanguageStore,
    getCurrencyStore,
    AppSettingSelector,
  } from "rune-lab";
  // We can also import setLocale from our own SDK if preferred, 
  // but rune-lab's internal paraglide is also an option.
  // Using the one from @sdk/ui is safer as it's the one we configured in layout.
  import { deLocalizeUrl } from "@sdk/ui";
  import { goto } from "$app/navigation";
  import { page } from "$app/stores";

  const themeStore = getThemeStore();
  const languageStore = getLanguageStore();
  const currencyStore = getCurrencyStore();

  // Helper to get active item from any config store
  function getActive(store: any) {
    return store.get(store.current) ?? store.available[0];
  }

  function handleLanguageChange(code: string) {
    languageStore.set(code);
    // Navigate to the same page but with the new locale prefix if needed
    // However, since we are using localStorage strategy in Vite, 
    // simply reloading or setting the cookie might be enough.
    // For now, we follow the standard paraglide pattern:
    const newPath = deLocalizeUrl(new URL($page.url.href), code as any);
    goto(newPath, { invalidateAll: true });
  }
</script>

<div
  class="bg-neutral-900/80 backdrop-blur-xl border-b border-white/5 px-4 py-1.5 flex items-center justify-center gap-6 overflow-x-auto no-scrollbar shadow-lg shadow-black/20"
>
  <!-- Theme Selector -->
  <div class="flex items-center gap-2">
    <AppSettingSelector
      value={getActive(themeStore)}
      options={themeStore.available}
      tooltip="Change Theme"
    >
      {#snippet triggerLabel(active)}
        <span class="text-lg">{active?.icon ?? "🎨"}</span>
      {/snippet}
      {#snippet item(t)}
        <button
          class="flex items-center gap-3 w-full px-2 py-1 hover:bg-white/5 transition-colors text-left"
          onclick={() => themeStore.set(t.name)}
        >
          <span class="text-lg">{t.icon}</span>
          <span class="capitalize text-xs">{t.name}</span>
        </button>
      {/snippet}
    </AppSettingSelector>
  </div>

  <div class="w-px h-4 bg-white/10"></div>

  <!-- Language Selector -->
  <div class="flex items-center gap-2">
    <AppSettingSelector
      value={getActive(languageStore)}
      options={languageStore.available}
      tooltip="Change Language"
    >
      {#snippet triggerLabel(active)}
        <span class="text-lg">{active?.flag ?? "🌐"}</span>
      {/snippet}
      {#snippet item(l)}
        <button
          class="flex items-center gap-3 w-full px-2 py-1 hover:bg-white/5 transition-colors text-left"
          onclick={() => handleLanguageChange(l.code)}
        >
          <span class="text-lg">{l.flag}</span>
          <span class="text-xs uppercase font-bold">{l.code}</span>
        </button>
      {/snippet}
    </AppSettingSelector>
  </div>

  <div class="w-px h-4 bg-white/10"></div>

  <!-- Currency Selector -->
  <div class="flex items-center gap-2">
    <AppSettingSelector
      value={getActive(currencyStore)}
      options={currencyStore.available}
      tooltip="Change Currency"
    >
      {#snippet triggerLabel(active)}
        <span class="font-black text-xs tracking-widest text-orange-500"
          >{active?.symbol ?? "$"}</span
        >
      {/snippet}
      {#snippet item(c)}
        <button
          class="flex items-center gap-3 w-full px-2 py-1 hover:bg-white/5 transition-colors text-left"
          onclick={() => currencyStore.set(c.code)}
        >
          <span
            class="badge badge-sm border-white/10 bg-white/5 text-[10px] font-bold w-10 h-6 flex items-center justify-center"
            >{c.symbol}</span
          >
          <span class="text-xs font-medium">{c.code}</span>
        </button>
      {/snippet}
    </AppSettingSelector>
  </div>
</div>

<style>
  .no-scrollbar::-webkit-scrollbar {
    display: none;
  }
  .no-scrollbar {
    -ms-overflow-style: none;
    scrollbar-width: none;
  }

  /* Ensure rune-lab components fit our aesthetic */
  :global(.rune-lab-selector) {
    transition: all 300ms cubic-bezier(0.4, 0, 0.2, 1);
  }
</style>
