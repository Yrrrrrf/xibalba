<script lang="ts">
  import { page } from "$app/state";
  import { NAV_ICONS } from "../../icons/icon-map.ts";
  import * as m from "../../i18n/paraglide/messages.js";
  import { authStore } from "@sdk/state";

  const auth = authStore;

  const allNavItems = [
    { href: "/discover", label: m.nav_discover(), icon: NAV_ICONS["/discover"], roles: ["tourist"] },
    { href: "/saved", label: m.nav_saved(), icon: NAV_ICONS["/saved"], roles: ["tourist"] },
    { href: "/dashboard", label: m.nav_dashboard(), icon: NAV_ICONS["/dashboard"], roles: ["business"] },
    { href: "/menu", label: m.nav_menu(), icon: NAV_ICONS["/menu"], roles: ["business"] },
    { href: "/admin", label: "Control", icon: NAV_ICONS["/admin"], roles: ["admin"] },
  ];

  const activeNavItems = $derived(
    auth.role 
      ? [
          ...allNavItems.filter(item => item.roles.includes(auth.role as string)),
          { href: "/profile", label: m.nav_profile(), icon: NAV_ICONS["/profile"] }
        ]
      : []
  );

  const isActive = (href: string) => page.url.pathname.startsWith(href);
</script>

{#if auth.role}
<nav
  class="md:hidden fixed bottom-6 inset-x-4 z-50
         glass backdrop-blur-2xl bg-base-100/10
         border border-white/10 dark:border-white/5
         shadow-[0_8px_32px_rgba(0,0,0,0.4)]
         rounded-2xl h-16 px-2 flex items-center justify-around"
>
  {#each activeNavItems as item}
    <a
      href={item.href}
      class="flex flex-col items-center justify-center gap-0.5 flex-1 h-full rounded-xl transition-all duration-300
             {isActive(item.href) ? 'text-primary scale-110' : 'text-base-content/40 hover:text-base-content/60'}"
    >
      <item.icon
        size={20}
        strokeWidth={isActive(item.href) ? 2.5 : 2}
        fill={isActive(item.href) ? "currentColor" : "none"}
        class="transition-transform duration-300"
      />
      <span class="text-[9px] font-black uppercase tracking-tighter">
        {item.label}
      </span>
      
      {#if isActive(item.href)}
        <div
          class="absolute -bottom-1 w-1 h-1 rounded-full bg-primary shadow-[0_0_8px_rgba(249,115,22,0.8)]"
        ></div>
      {/if}
    </a>
  {/each}
</nav>
{/if}
