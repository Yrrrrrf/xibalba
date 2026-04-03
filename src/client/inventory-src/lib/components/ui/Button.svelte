<script lang="ts">
  interface Props {
    variant?: 'primary' | 'secondary' | 'accent' | 'ghost' | 'error' | 'warning' | 'success';
    size?: 'xs' | 'sm' | 'md' | 'lg';
    outline?: boolean;
    loading?: boolean;
    disabled?: boolean;
    wide?: boolean;
    onclick?: () => void;
    type?: 'button' | 'submit' | 'reset';
    children: import('svelte').Snippet;
  }

  let {
    variant = 'primary',
    size = 'md',
    outline = false,
    loading = false,
    disabled = false,
    wide = false,
    onclick,
    type = 'button',
    children,
  }: Props = $props();

  const sizeClass = size === 'md' ? '' : `btn-${size}`;
  const outlineClass = outline ? 'btn-outline' : '';
  const wideClass = wide ? 'btn-wide' : '';
</script>

<button
  {type}
  {disabled}
  {onclick}
  class="btn btn-{variant} {sizeClass} {outlineClass} {wideClass}"
>
  {#if loading}
    <span class="loading loading-spinner"></span>
  {/if}
  {@render children()}
</button>
