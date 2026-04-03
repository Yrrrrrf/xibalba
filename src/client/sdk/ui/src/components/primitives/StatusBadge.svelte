<script lang="ts">
  interface Props {
    status: string;
    class?: string;
  }

  let { status, class: className = '' }: Props = $props();

  const statusMap: Record<string, string> = {
    active: 'badge-success',
    inactive: 'badge-ghost',
    pending: 'badge-warning',
    active_food: 'badge-success',
    hidden_food: 'badge-ghost',
  };
</script>

<div class="badge {statusMap[status] ?? 'badge-ghost'} badge-sm font-bold uppercase text-[9px] {className}">
  {status}
</div>
