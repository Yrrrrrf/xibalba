<script lang="ts">
    import "./layout.css";
    // import { RuneProvider } from "rune-lab";
    // import * as m from "$lib/paraglide/messages.js";
    // import AppLayout from "./AppLayout.svelte";

    let { children } = $props();

    const sections = [
        {
            id: "main",
            title: "Workspace",
            items: [
                { id: "/overview", label: "Overview" },
                { id: "/properties", label: "Properties" },
                { id: "/crm", label: "CRM Pipeline" },
                { id: "/orders", label: "Orders" },
            ],
        },
        {
            id: "tools",
            title: "Tools",
            items: [
                { id: "/market", label: "Market" },
                { id: "/generate", label: "Generate PDF" },
                { id: "/notifications", label: "Notifications" },
            ],
        },
    ];
</script>

{@render children()}
