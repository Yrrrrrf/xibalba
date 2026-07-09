<script lang="ts">
  import { BottomNav } from "@sdk/ui";
  import { authStore } from "@sdk/state";
  import DashboardView from "../../views/DashboardView.svelte";
  import MenuView from "../../views/MenuView.svelte";
  import AdminView from "../../views/AdminView.svelte";
  import AccountView from "../../views/AccountView.svelte";
  import ShareView from "../../views/ShareView.svelte";

  let activeTab = $state(authStore.role === 'admin' ? "admin" : "dashboard");

  function handleTabChange(tab: string) {
    activeTab = tab;
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }
</script>

<div class="min-h-screen bg-transparent pb-20">
  {#if activeTab === "dashboard"}
    <DashboardView onNavigate={handleTabChange} />
  {:else if activeTab === "menu"}
    <MenuView onNavigate={handleTabChange} />
  {:else if activeTab === "admin"}
    <AdminView />
  {:else if activeTab === "profile"}
    <AccountView />
  {:else if activeTab === "share"}
    <ShareView />
  {/if}

  <BottomNav 
    mode="owner" 
    {activeTab} 
    ontabchange={handleTabChange} 
  />
</div>
