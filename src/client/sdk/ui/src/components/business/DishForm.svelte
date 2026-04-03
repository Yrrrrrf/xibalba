<script lang="ts">
  import type { DishFormData } from '@sdk/core';
  import { DISH_CATEGORIES } from '@sdk/core';
  // @ts-ignore
  import * as m from '../../paraglide/messages.js';

  interface Props {
    initial?: DishFormData | null;
    onsubmit?: (data: DishFormData) => void;
    oncancel?: () => void;
  }

  let { initial, onsubmit, oncancel }: Props = $props();

  let form = $state<DishFormData>(initial ?? {
    name: '',
    price: 0,
    category: 'mexican',
    description: '',
    image_url: '',
    available: true,
  });

  let errors = $state<Partial<Record<keyof DishFormData, string>>>({});

  function validate(): boolean {
    errors = {};
    if (!form.name.trim()) errors.name = 'El nombre es requerido';
    if (!form.price || Number(form.price) <= 0) errors.price = 'Precio inválido';
    if (!form.description.trim()) errors.description = 'La descripción es requerida';
    return Object.keys(errors).length === 0;
  }

  function handleSubmit(e: SubmitEvent) {
    e.preventDefault();
    if (validate()) {
      onsubmit?.({ ...form, price: Number(form.price) });
    }
  }
</script>

<form onsubmit={handleSubmit} class="flex flex-col gap-4">
  <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
    <!-- Nombre -->
    <div class="form-control">
      <label class="label" for="prod-nombre">
        <span class="label-text font-semibold">🍽️ {m.food_dish()}</span>
      </label>
      <input
        id="prod-nombre"
        type="text"
        placeholder="ej. Tacos al Pastor x3"
        class="input bg-black/20 border-white/10 text-white placeholder:text-neutral-600 focus:border-orange-500/50 {errors.name ? 'border-error' : ''}"
        bind:value={form.name}
      />
      {#if errors.name}
        <label class="label">
          <span class="label-text-alt text-error">{errors.name}</span>
        </label>
      {/if}
    </div>

    <!-- Precio -->
    <div class="form-control">
      <label class="label" for="prod-precio">
        <span class="label-text font-semibold">💲 {m.food_price()} (USD)</span>
      </label>
      <input
        id="prod-precio"
        type="number"
        placeholder="ej. 8.50"
        step="0.01"
        min="0"
        class="input bg-black/20 border-white/10 text-white placeholder:text-neutral-600 focus:border-orange-500/50 {errors.price ? 'border-error' : ''}"
        bind:value={form.price}
      />
      {#if errors.price}
        <label class="label">
          <span class="label-text-alt text-error">{errors.price}</span>
        </label>
      {/if}
    </div>
  </div>

  <!-- Categoría -->
  <div class="form-control">
    <label class="label" for="prod-cat">
      <span class="label-text font-semibold">🏷️ {m.food_category()}</span>
    </label>
    <select id="prod-cat" class="select bg-black/20 border-white/10 text-white focus:border-orange-500/50" bind:value={form.category}>
      {#each DISH_CATEGORIES as cat}
        <option value={cat.key} class="bg-neutral-900 text-white">{cat.label}</option>
      {/each}
    </select>
  </div>

  <!-- Descripción -->
  <div class="form-control">
    <label class="label" for="prod-desc">
      <span class="label-text font-semibold">📝 {m.biz_description()}</span>
    </label>
    <textarea
      id="prod-desc"
      rows="3"
      placeholder="Describe tu platillo, ingredientes especiales..."
      class="textarea bg-black/20 border-white/10 text-white placeholder:text-neutral-600 focus:border-orange-500/50 {errors.description ? 'border-error' : ''}"
      bind:value={form.description}
    ></textarea>
    {#if errors.description}
      <label class="label">
        <span class="label-text-alt text-error">{errors.description}</span>
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
      bind:value={form.image_url}
    />
  </div>

  <!-- Disponible -->
  <div class="form-control">
    <label class="label cursor-pointer justify-start gap-3">
      <input type="checkbox" class="toggle toggle-primary" bind:checked={form.available} />
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
