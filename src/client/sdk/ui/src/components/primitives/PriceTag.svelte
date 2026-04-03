<script lang="ts">
  interface Props {
    amount: number;
    currency?: string;
    size?: 'sm' | 'md' | 'lg';
    class?: string;
  }

  let { amount, currency = 'USD', size = 'md', class: className = '' }: Props = $props();

  const sizeClasses = {
    sm: 'text-sm',
    md: 'text-xl',
    lg: 'text-2xl',
  };
</script>

<div class="flex flex-col {className}">
  <span class="text-orange-500 font-extrabold {sizeClasses[size]} leading-none">
    ${amount.toFixed(2)}
  </span>
  <span class="text-neutral-500 text-[10px] tracking-wide uppercase">{currency}</span>
</div>
