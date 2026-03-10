import { type Handle, redirect } from "@sveltejs/kit";
import { paraglideMiddleware } from "$lib/paraglide/server";

export const handle: Handle = ({ event, resolve }) => {
  if (
    !event.url.pathname.startsWith("/login") && !event.cookies.get("session")
  ) {
    // TODO: Basic auth gate placeholder. Uncomment this when you're ready to test with Supabase Auth!
    // throw redirect(303, "/login");
  }

  return paraglideMiddleware(event.request, ({ request, locale }) => {
    event.request = request;

    return resolve(event, {
      transformPageChunk: ({ html }) =>
        html.replace("%paraglide.lang%", locale),
    });
  });
};
