<script lang="ts">
  import { HeroCarousel, RoleCards } from "@sdk/ui";
</script>

<div class="flex flex-col w-full"> 
  <HeroCarousel />
  <RoleCards />
</div>

<style>
  :global(html) {
    scroll-behavior: smooth;
  }
</style>
