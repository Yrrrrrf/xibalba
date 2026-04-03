<script lang="ts">
  interface Props {
    onsubmit?: (data: ProductoData) => void;
    oncancel?: () => void;
  }

  interface ProductoData {
    nombre: string;
    precio: number | string;
    categoria: string;
    descripcion: string;
    imagen: string;
    disponible: boolean;
  }

  let { onsubmit, oncancel }: Props = $props();

  const categorias = [
    'Comida Mexicana', 'Mariscos', 'Antojitos', 'Bebidas',
    'Postres', 'Comida Internacional', 'Vegetariano', 'Fast Food',
  ];

  let form = $state<ProductoData>({
    nombre: '',
    precio: '',
    categoria: 'Comida Mexicana',
    descripcion: '',
    imagen: '',
    disponible: true,
  });

  let errors = $state<Partial<Record<keyof ProductoData, string>>>({});

  function validate(): boolean {
    errors = {};
    if (!form.nombre.trim()) errors.nombre = 'El nombre es requerido';
    if (!form.precio || Number(form.precio) <= 0) errors.precio = 'Precio inválido';
    if (!form.descripcion.trim()) errors.descripcion = 'La descripción es requerida';
    return Object.keys(errors).length === 0;
  }

  function handleSubmit(e: SubmitEvent) {
    e.preventDefault();
    if (validate()) {
      onsubmit?.({ ...form, precio: Number(form.precio) });
      form = { nombre: '', precio: '', categoria: 'Comida Mexicana', descripcion: '', imagen: '', disponible: true };
    }
  }
</script>

<form onsubmit={handleSubmit} class="flex flex-col gap-4">
  <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
    <!-- Nombre -->
    <div class="form-control">
      <label class="label" for="prod-nombre">
        <span class="label-text font-semibold">🍽️ Nombre del platillo</span>
      </label>
      <input
        id="prod-nombre"
        type="text"
        placeholder="ej. Tacos al Pastor x3"
        class="input bg-black/20 border-white/10 text-white placeholder:text-neutral-600 focus:border-orange-500/50 {errors.nombre ? 'border-error' : ''}"
        bind:value={form.nombre}
      />
      {#if errors.nombre}
        <label class="label">
          <span class="label-text-alt text-error">{errors.nombre}</span>
        </label>
      {/if}
    </div>

    <!-- Precio -->
    <div class="form-control">
      <label class="label" for="prod-precio">
        <span class="label-text font-semibold">💲 Precio (USD)</span>
      </label>
      <input
        id="prod-precio"
        type="number"
        placeholder="ej. 8.50"
        step="0.01"
        min="0"
        class="input bg-black/20 border-white/10 text-white placeholder:text-neutral-600 focus:border-orange-500/50 {errors.precio ? 'border-error' : ''}"
        bind:value={form.precio}
      />
      {#if errors.precio}
        <label class="label">
          <span class="label-text-alt text-error">{errors.precio}</span>
        </label>
      {/if}
    </div>
  </div>

  <!-- Categoría -->
  <div class="form-control">
    <label class="label" for="prod-cat">
      <span class="label-text font-semibold">🏷️ Categoría</span>
    </label>
    <select id="prod-cat" class="select bg-black/20 border-white/10 text-white focus:border-orange-500/50" bind:value={form.categoria}>
      {#each categorias as cat}
        <option value={cat} class="bg-neutral-900 text-white">{cat}</option>
      {/each}
    </select>
  </div>

  <!-- Descripción -->
  <div class="form-control">
    <label class="label" for="prod-desc">
      <span class="label-text font-semibold">📝 Descripción</span>
    </label>
    <textarea
      id="prod-desc"
      rows="3"
      placeholder="Describe tu platillo, ingredientes especiales..."
      class="textarea bg-black/20 border-white/10 text-white placeholder:text-neutral-600 focus:border-orange-500/50 {errors.descripcion ? 'border-error' : ''}"
      bind:value={form.descripcion}
    ></textarea>
    {#if errors.descripcion}
      <label class="label">
        <span class="label-text-alt text-error">{errors.descripcion}</span>
      </label>
    {/if}
  </div>

  <!-- URL Imagen -->
  <div class="form-control">
    <label class="label" for="prod-img">
      <span class="label-text font-semibold">🖼️ URL de imagen (opcional)</span>
    </label>
    <input
      id="prod-img"
      type="url"
      placeholder="https://..."
      class="input bg-black/20 border-white/10 text-white placeholder:text-neutral-600 focus:border-orange-500/50 input-sm"
      bind:value={form.imagen}
    />
  </div>

  <!-- Disponible -->
  <div class="form-control">
    <label class="label cursor-pointer justify-start gap-3">
      <input type="checkbox" class="toggle toggle-primary" bind:checked={form.disponible} />
      <span class="label-text font-semibold">Disponible ahora</span>
    </label>
  </div>

  <div class="flex justify-end gap-3 mt-2">
    {#if oncancel}
      <button type="button" onclick={oncancel} class="btn btn-ghost">Cancelar</button>
    {/if}
    <button type="submit" class="btn btn-primary">
      ➕ Registrar platillo
    </button>
  </div>
</form>
