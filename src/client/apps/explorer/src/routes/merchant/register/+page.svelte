<script lang="ts">
  import { goto } from "$app/navigation";
  import { GlassContainer, FormInput, SubmitButton, m, ICONS } from "@sdk/ui";
  import { Store } from "lucide-svelte";
  import { authStore } from "@sdk/state";

  const auth = authStore;

  let loading = $state(false);
  let form = $state({
    email: "",
    password: "",
    businessName: "",
    address: "",
  });

  async function registerMerchant(e: Event) {
    e.preventDefault();
    loading = true;
    await new Promise((r) => setTimeout(r, 800)); // Simulate API
    loading = false;
    auth.setRole("business");
    goto("/dashboard");
  }
</script>

<svelte:head>
  <title>Alta Comercial — Xibalba</title>
</svelte:head>

<div class="min-h-screen flex flex-col items-center justify-center p-5 bg-base-100 relative overflow-hidden">
  <div class="absolute top-[-10%] right-[-10%] w-[50%] h-[50%] bg-warning/20 blur-[120px] rounded-full pointer-events-none"></div>

  <div class="w-full max-w-lg z-10 py-10">
    <div class="text-center mb-8">
      <div class="inline-flex items-center justify-center w-16 h-16 rounded-2xl bg-gradient-to-br from-warning to-warning/60 text-warning-content shadow-lg shadow-warning/30 mb-4">
        <Store size={32} />
      </div>
      <h1 class="text-4xl font-extrabold tracking-tight text-base-content">
        Registra tu Comercio
      </h1>
      <p class="text-base-content/60 text-sm mt-2">
        Únete a nuestra plataforma y lleva tus platillos a más turistas.
      </p>
    </div>

    <GlassContainer class="p-6 sm:p-8" accent="from-warning to-error">
      <form onsubmit={registerMerchant} class="space-y-4">
        
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <FormInput
            type="email"
            label="Correo de Acceso"
            bind:value={form.email}
            placeholder="negocio@correo.com"
            required
          />
          <FormInput
            type="password"
            label="Contraseña"
            bind:value={form.password}
            placeholder="••••••••"
            required
          />
        </div>

        <div class="divider text-xs text-base-content/30 my-2">Datos del Local</div>

        <FormInput
          label="Nombre del Negocio"
          bind:value={form.businessName}
          placeholder="Ej. Tacos El Pastor"
          required
        />

        <FormInput
          type="textarea"
          label="Dirección Completa"
          bind:value={form.address}
          placeholder="Calle Secundaria #123, Colonia Centro..."
          required
        />

        <div class="pt-4">
          <SubmitButton {loading} variant="primary" class="w-full border-none bg-gradient-to-r from-warning to-error text-white hover:from-warning/80 hover:to-error/80 shadow-warning/30">
            Crear Negocio
          </SubmitButton>
        </div>
      </form>

      <div class="mt-6 text-center text-sm text-base-content/60">
        <p>
          ¿Ya tienes cuenta como comercio? 
          <a href="/login" class="text-warning font-bold hover:underline">
            Inicia Sesión
          </a>
        </p>
      </div>
    </GlassContainer>
  </div>
</div>
