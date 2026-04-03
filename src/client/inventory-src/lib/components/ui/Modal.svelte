<script lang="ts">
  interface Props {
    open?: boolean;
    title?: string;
    onclose?: () => void;
    children: import('svelte').Snippet;
    actions?: import('svelte').Snippet;
  }

  let { open = false, title = '', onclose, children, actions }: Props = $props();

  function handleBackdropClick(e: MouseEvent) {
    if (e.target === e.currentTarget) {
      onclose?.();
    }
  }
</script>

{#if open}
  <!-- svelte-ignore a11y_click_events_have_key_events -->
  <!-- svelte-ignore a11y_no_static_element_interactions -->
  <div
    class="modal modal-open"
    onclick={handleBackdropClick}
  >
    <div class="modal-box w-11/12 max-w-2xl relative
                 bg-neutral-900/90 backdrop-blur-2xl
                 border border-white/10
                 shadow-[0_20px_50px_rgba(0,0,0,0.5)]
                 text-neutral-100">
      <button
        class="btn btn-sm btn-circle btn-ghost absolute right-2 top-2 hover:bg-white/10"
        onclick={onclose}
      >✕</button>

      {#if title}
        <h3 class="font-bold text-2xl mb-6 bg-gradient-to-r from-white to-neutral-400 bg-clip-text text-transparent italic tracking-tight">{title}</h3>
      {/if}

      <div class="modal-content">
        {@render children()}
      </div>

      {#if actions}
        <div class="modal-action border-t border-white/5 pt-4">
          {@render actions()}
        </div>
      {/if}
    </div>
  </div>
{/if}
