import adapter from "@sveltejs/adapter-static";
import { vitePreprocess } from "@sveltejs/vite-plugin-svelte";

/** @type {import('@sveltejs/kit').Config} */
const config = {
  // Consult https://svelte.dev/docs/kit/integrations
  // for more information about preprocessors
  preprocess: vitePreprocess(),

  kit: {
    adapter: adapter(),

    // Configure path aliases so svelte-check can resolve them
    alias: {
      "@sdk/core": "../core/src/mod.ts",
      "@sdk/state": "../state/src/mod.ts",
      "@sdk/ui": "./src/mod.ts",
      "$lib": "./src/lib",
    },
  },
};

export default config;
