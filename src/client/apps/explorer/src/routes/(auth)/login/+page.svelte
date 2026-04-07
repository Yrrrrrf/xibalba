<script lang="ts">
  import { goto } from "$app/navigation";
  import { authStore } from "@sdk/state";
  import { m } from "@sdk/ui";

  const auth = authStore;
  
  let loading = $state(false);
  let email = $state("");
  let password = $state("");

  async function handleSubmit(e: Event) {
    e.preventDefault();
    loading = true;
    
    // Simulate network delay
    await new Promise((r) => setTimeout(r, 800));
    
    // Intelligent login simulation based on email
    let roleToSet: "tourist" | "business" | "admin" = "tourist";
    if (email.toLowerCase().includes("negocio") || email.toLowerCase().includes("comerciante") || email.toLowerCase().includes("business")) {
      roleToSet = "business";
    } else if (email.toLowerCase().includes("admin")) {
      roleToSet = "admin";
    }
    
    auth.setRole(roleToSet);
    loading = false;
    
    if (roleToSet === "tourist") {
      goto("/discover");
    } else if (roleToSet === "admin") {
      goto("/admin");
    } else {
      goto("/dashboard");
    }
  }
</script>

<svelte:head>
  <title>Iniciar Sesión — {m.app_name()}</title>
</svelte:head>

<!-- Header text injected logically above the form -->
<div class="text-center -mt-6 mb-6">
  <h1 class="text-3xl font-black mb-2 tracking-tight text-base-content drop-shadow-sm">Bienvenido de vuelta</h1>
  <p class="text-base-content/60 text-sm font-medium">Ingresa tus credenciales para continuar.</p>
</div>

<form onsubmit={handleSubmit} class="space-y-4">
  <div class="form-control w-full">
    <label class="label pb-2"><span class="label-text font-bold text-base-content/80">Correo Electrónico</span></label>
    <input 
      type="email" 
      bind:value={email}
      placeholder="tu@correo.com" 
      class="input input-bordered bg-base-200/50 focus:border-primary focus:bg-base-100 transition-colors w-full" 
      required
    />
  </div>

  <div class="form-control w-full">
    <label class="label pb-2">
      <span class="label-text font-bold text-base-content/80">Contraseña</span>
      <a href="#" class="label-text-alt text-primary font-bold hover:underline transition-colors w-fit">¿Olvidaste tu contraseña?</a>
    </label>
    <input 
      type="password" 
      bind:value={password}
      placeholder="••••••••" 
      class="input input-bordered bg-base-200/50 focus:border-primary focus:bg-base-100 transition-colors w-full" 
      required
    />
  </div>

  <button 
    type="submit" 
    class="btn btn-primary w-full shadow-lg shadow-primary/20 hover:scale-[1.02] transition-transform font-bold text-lg mt-6"
    disabled={loading}
  >
    {#if loading}
      <span class="loading loading-spinner loading-md"></span> Autenticando...
    {:else}
      Ingresar a mi cuenta
    {/if}
  </button>
</form>

<div class="divider text-xs opacity-50 font-medium my-6">o continúa con</div>

<button class="btn btn-outline w-full border-base-content/20 bg-base-100/50 hover:bg-base-content/10 hover:border-transparent transition-all">
  <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="currentColor"><path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" fill="#4285F4"/><path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#34A853"/><path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z" fill="#FBBC05"/><path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" fill="#EA4335"/><path d="M1 1h22v22H1z" fill="none"/></svg>
  Ingresar con Google
</button>

<p class="text-center text-sm text-base-content/70 mt-5 drop-shadow-sm">
  ¿No tienes una cuenta aún? 
  <a href="/register?type=tourist" class="text-primary font-bold hover:underline transition-colors">Regístrate gratis</a>
</p>
