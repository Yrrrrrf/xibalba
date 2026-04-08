/// <reference no-default-lib="true"/>
/// <reference lib="esnext" />
/// <reference lib="webworker" />
/// <reference types="@sveltejs/kit" />

import { build, files, version } from "$service-worker";

const self = /** @type {ServiceWorkerGlobalScope} */ (globalThis.self as any);
const CACHE = `xibalba-cache-${version}`;
const ASSETS = [...build, ...files];

// Install: cache everything
self.addEventListener("install", (event: ExtendableEvent) => {
  event.waitUntil(
    caches.open(CACHE)
      .then((cache) => cache.addAll(ASSETS))
      .then(() => self.skipWaiting()),
  );
});

// Activate: clean old caches
self.addEventListener("activate", (event: ExtendableEvent) => {
  event.waitUntil(
    caches.keys()
      .then((keys) =>
        Promise.all(
          keys
            .filter((key) => key !== CACHE)
            .map((key) => caches.delete(key)),
        )
      )
      .then(() => self.clients.claim()),
  );
});

// Fetch: cache-first for assets, network-first for API
self.addEventListener("fetch", (event: FetchEvent) => {
  if (event.request.method !== "GET") return;

  const url = new URL(event.request.url);

  // Skip API calls — let them go to network
  if (url.pathname.startsWith("/api")) return;

  event.respondWith(
    caches.match(event.request)
      .then((cached) =>
        cached || fetch(event.request)
          .then((response) => {
            const clone = response.clone();
            caches.open(CACHE).then((cache) => cache.put(event.request, clone));
            return response;
          })
      )
      .catch(() => caches.match("/index.html") as Promise<Response>),
  );
});
