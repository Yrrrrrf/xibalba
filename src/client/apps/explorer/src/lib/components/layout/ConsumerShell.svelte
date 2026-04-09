<script lang="ts">
  import { BottomNav } from "@sdk/ui";
  import DiscoverView from "../../views/DiscoverView.svelte";
  import SavedView from "../../views/SavedView.svelte";
  import AccountView from "../../views/AccountView.svelte";

  let activeTab = $state("discover");

  function handleTabChange(tab: string) {
    activeTab = tab;
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }
</script>

<div class="min-h-screen bg-transparent pb-20">
  {#if activeTab === "discover"}
    <DiscoverView />
  {:else if activeTab === "saved"}
    <SavedView onNavigate={handleTabChange} />
  {:else if activeTab === "profile"}
    <AccountView />
  {/if}

  <BottomNav 
    mode="consumer" 
    {activeTab} 
    ontabchange={handleTabChange} 
  />
</div>
