<script lang="ts">
  import OwnerShell from "$lib/components/layout/OwnerShell.svelte";
  import { m } from "@sdk/ui";
</script>

<svelte:head>
  <title>{m.app_name()} — Panel de Propietario</title>
</svelte:head>

<OwnerShell />
