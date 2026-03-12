import type Handle from "@sveltejs/kit";
import { paraglideMiddleware } from "$lib/paraglide/server";

export const handle: Handle = ({ event, resolve }) => {
  if (
    !event.url.pathname.startsWith("/login") && !event.cookies.get("session")
  ) {
    return paraglideMiddleware(event.request, ({ request, locale }) => {
      event.request = request;

      return resolve(event, {
        transformPageChunk: ({ html }) =>
          html.replace("%paraglide.lang%", locale),
      });
    });
  }
};
