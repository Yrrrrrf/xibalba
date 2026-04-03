<script lang="ts">
  let editing = $state(false);

  let perfil = $state({
    nombre: 'Taquería El Campeón',
    propietario: 'Carlos Ramírez',
    zona: 'Zona Centro Histórico',
    direccion: 'Calle Libertad #42, Local 3',
    telefono: '+52 55 1234 5678',
    correo: 'campeontacos@ejemplo.com',
    descripcion: 'Auténtica comida mexicana para los turistas del Mundial. Especialidad en tacos al pastor y quesadillas.',
    horario: '8:00 AM – 10:00 PM',
    categoria: 'Comida Mexicana',
  });
</script>

<div class="card bg-neutral-900/60 backdrop-blur-xl shadow-xl border border-white/10">
  <div class="card-body">
    <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3 mb-4">
      <div class="flex items-center gap-3">
        <div class="avatar placeholder">
          <div class="bg-primary text-primary-content w-14 rounded-full">
            <span class="text-2xl">🌮</span>
          </div>
        </div>
        <div>
          <h2 class="card-title text-xl text-neutral-100">{perfil.nombre}</h2>
          <p class="text-sm text-neutral-400">{perfil.categoria}</p>
        </div>
      </div>
      <button
        onclick={() => { editing = !editing; }}
        class="group flex items-center gap-2 px-4 py-2 rounded-xl text-xs font-bold transition-all duration-300 {editing ? 'bg-rose-500/10 text-rose-400 border border-rose-500/20' : 'bg-orange-500/10 text-orange-400 border border-orange-500/20 hover:bg-orange-500/20'}"
      >
        {#if editing}
          ✕ Cancelar
        {:else}
          ✏️ Editar perfil
        {/if}
      </button>
    </div>

    <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
      {#each [
        { label: 'Propietario', field: 'propietario', icon: '👤' },
        { label: 'Zona', field: 'zona', icon: '📍' },
        { label: 'Dirección', field: 'direccion', icon: '🏠' },
        { label: 'Teléfono', field: 'telefono', icon: '📞' },
        { label: 'Correo', field: 'correo', icon: '✉️' },
        { label: 'Horario', field: 'horario', icon: '⏰' },
      ] as item}
        <div class="form-control">
          <label class="label py-1">
            <span class="label-text text-[10px] font-bold uppercase tracking-wider text-neutral-500">
              {item.icon} {item.label}
            </span>
          </label>
          {#if editing}
            <input
              class="input bg-black/20 border-white/10 text-white input-sm focus:border-orange-500/50"
              bind:value={perfil[item.field as keyof typeof perfil]}
            />
          {:else}
            <p class="text-sm py-2 px-3 bg-white/5 rounded-xl border border-white/5 text-neutral-200">{perfil[item.field as keyof typeof perfil]}</p>
          {/if}
        </div>
      {/each}
    </div>

    <div class="form-control mt-2">
      <label class="label py-1">
        <span class="label-text text-[10px] font-bold uppercase tracking-wider text-neutral-500">💬 Descripción</span>
      </label>
      {#if editing}
        <textarea class="textarea bg-black/20 border-white/10 text-white textarea-sm focus:border-orange-500/50" bind:value={perfil.descripcion} rows="3"></textarea>
      {:else}
        <p class="text-sm py-2.5 px-3 bg-white/5 rounded-xl border border-white/5 text-neutral-200 leading-relaxed">{perfil.descripcion}</p>
      {/if}
    </div>

    {#if editing}
      <div class="card-actions justify-end mt-4">
        <button onclick={() => { editing = false; }} class="btn btn-primary">
          💾 Guardar cambios
        </button>
      </div>
    {/if}
  </div>
</div>
