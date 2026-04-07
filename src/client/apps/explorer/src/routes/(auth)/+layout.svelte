<script lang="ts">
  import { ICONS, m } from "@sdk/ui";

  let { children } = $props();
</script>

<div class="min-h-screen flex flex-col items-center justify-center p-5 bg-base-100 relative overflow-hidden -mt-10">
  
  <!-- Subtle Background Decor specific to Auth -->
  <div class="absolute top-[0%] left-[-10%] w-[40%] h-[40%] bg-primary/20 blur-[120px] rounded-full pointer-events-none"></div>
  <div class="absolute bottom-[-10%] right-[-10%] w-[40%] h-[40%] bg-secondary/20 blur-[120px] rounded-full pointer-events-none"></div>

  <div class="w-full max-w-md animate-in fade-in slide-in-from-bottom-4 duration-700 z-10">
    <!-- Shared Brand Header -->
    <div class="text-center mb-8">
      <a href="/" class="inline-flex justify-center mb-4 text-primary hover:scale-110 transition-transform cursor-pointer drop-shadow-[0_0_15px_rgba(var(--primary),0.3)]">
        <ICONS.brand size={56} />
      </a>
    </div>

    <!-- Shared Card Shell -->
    <div class="card glass bg-base-100/40 backdrop-blur-3xl shadow-[0_8px_40px_-12px_rgba(0,0,0,0.5)] border border-white/10 relative overflow-hidden">
        <!-- Shine effect -->
      <div class="absolute inset-0 bg-gradient-to-br from-white/10 via-transparent to-transparent opacity-30 pointer-events-none"></div>
      
      <div class="card-body p-8 sm:p-10 relative z-10">
        {@render children()}
      </div>
    </div>
  </div>
</div>
