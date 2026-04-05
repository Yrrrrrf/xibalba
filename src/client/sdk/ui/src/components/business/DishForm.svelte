<script lang="ts">
  import { onMount, onDestroy } from "svelte";
  import { Utensils, DollarSign, Tag, FileText, Image, Plus } from 'lucide-svelte';
  import type { DishFormData } from "@sdk/core";
  import { DISH_CATEGORIES } from "@sdk/core";
  import * as m from "../../../src/i18n/paraglide/messages.js";

  interface Props {
    initial?: DishFormData | null;
    onsubmit?: (data: DishFormData) => void;
    oncancel?: () => void;
  }

  let { initial, onsubmit, oncancel }: Props = $props();

  let form = $state<DishFormData>({
    name: "",
    price: 0,
    category: "mexican",
    description: "",
    image_url: "",
    available: true,
  });

  $effect.pre(() => {
    if (initial) {
      form = { ...initial };
    }
  });

  let errors = $state<Partial<Record<keyof DishFormData, string>>>({});

  function validate(): boolean {
    errors = {};
    if (!form.name.trim()) errors.name = m.form_name_required();
    if (!form.price || Number(form.price) <= 0)
      errors.price = m.form_price_invalid();
    if (!form.description.trim()) errors.description = m.form_desc_required();
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
        <span class="label-text font-semibold flex items-center gap-1.5">
          <Utensils size={14} class="text-primary" />
          {m.food_dish()}
        </span>
      </label>
      <input
        id="prod-nombre"
        type="text"
        placeholder="ej. Tacos al Pastor x3"
        class="input input-bordered bg-base-200/50 text-base-content placeholder:text-base-content/40 focus:border-primary/50 {errors.name
          ? 'border-error'
          : ''}"
        bind:value={form.name}
      />
      {#if errors.name}
        <div class="label">
          <span class="label-text-alt text-error">{errors.name}</span>
        </div>
      {/if}
    </div>

    <!-- Precio -->
    <div class="form-control">
      <label class="label" for="prod-precio">
        <span class="label-text font-semibold flex items-center gap-1.5">
          <DollarSign size={14} class="text-success" />
          {m.food_price()} (USD)
        </span>
      </label>
      <input
        id="prod-precio"
        type="number"
        placeholder="ej. 8.50"
        step="0.01"
        min="0"
        class="input input-bordered bg-base-200/50 text-base-content placeholder:text-base-content/40 focus:border-primary/50 {errors.price
          ? 'border-error'
          : ''}"
        bind:value={form.price}
      />
      {#if errors.price}
        <div class="label">
          <span class="label-text-alt text-error">{errors.price}</span>
        </div>
      {/if}
    </div>
  </div>

  <!-- Categoría -->
  <div class="form-control">
    <label class="label" for="prod-cat">
      <span class="label-text font-semibold flex items-center gap-1.5">
        <Tag size={14} class="text-info" />
        {m.food_category()}
      </span>
    </label>
    <select
      id="prod-cat"
      class="select select-bordered bg-base-200/50 text-base-content focus:border-primary/50"
      bind:value={form.category}
    >
      {#each DISH_CATEGORIES as cat}
        <option value={cat.key} class="bg-base-100 text-base-content"
          >{cat.label}</option
        >
      {/each}
    </select>
  </div>

  <!-- Descripción -->
  <div class="form-control">
    <label class="label" for="prod-desc">
      <span class="label-text font-semibold flex items-center gap-1.5">
        <FileText size={14} class="text-base-content/50" />
        {m.biz_description()}
      </span>
    </label>
    <textarea
      id="prod-desc"
      rows="3"
      placeholder="Describe tu platillo, ingredientes especiales..."
      class="textarea textarea-bordered bg-base-200/50 text-base-content placeholder:text-base-content/40 focus:border-primary/50 {errors.description
        ? 'border-error'
        : ''}"
      bind:value={form.description}
    ></textarea>
    {#if errors.description}
      <div class="label">
        <span class="label-text-alt text-error">{errors.description}</span>
      </div>
    {/if}
  </div>

  <!-- URL Imagen -->
  <div class="form-control">
    <label class="label" for="prod-img">
      <span class="label-text font-semibold flex items-center gap-1.5">
        <Image size={14} class="text-base-content/50" />
        {m.form_image_label()}
      </span>
    </label>
    <input
      id="prod-img"
      type="url"
      placeholder="https://..."
      class="input input-bordered bg-base-200/50 text-base-content placeholder:text-base-content/40 focus:border-primary/50 input-sm"
      bind:value={form.image_url}
    />
  </div>

  <!-- Disponible -->
  <div class="form-control">
    <label class="label cursor-pointer justify-start gap-3" for="prod-avail">
      <input
        id="prod-avail"
        type="checkbox"
        class="toggle toggle-primary"
        bind:checked={form.available}
      />
      <span class="label-text font-semibold">{m.form_available_now()}</span>
    </label>
  </div>

  <div class="flex justify-end gap-3 mt-2">
    {#if oncancel}
      <button type="button" onclick={oncancel} class="btn btn-ghost"
        >{m.form_cancel()}</button
      >
    {/if}
    <button type="submit" class="btn btn-primary gap-2">
      <Plus size={18} /> {m.form_submit()}
    </button>
  </div>
</form>
