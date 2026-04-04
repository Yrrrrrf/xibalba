import { deLocalizeUrl } from "@sdk/ui";

export const reroute = (request) => deLocalizeUrl(request.url).pathname;
