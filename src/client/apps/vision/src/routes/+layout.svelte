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
	import { setLocale } from "$lib/i18n/paraglide/runtime.js";
	import { m } from "$lib/i18n/messages.ts";
	import AppLayout from "./AppLayout.svelte";

	let { children } = $props();
</script>

<RuneProvider
	config={{
		favicon: "/img/rune.png",
		app: {
			name: "Rune Lab",
			version: version(),
			author: "Yrrrrrf",
		},
	}}
	plugins={[LayoutPlugin, PalettesPlugin, MoneyPlugin]}
	onLanguageChange={(l) => setLocale(l)}
>
	<AppLayout {sections}>
		{@render children()}
	</AppLayout>
</RuneProvider>
