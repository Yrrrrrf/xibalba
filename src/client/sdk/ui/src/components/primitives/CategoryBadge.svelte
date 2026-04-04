<script lang="ts">
  import { DISH_CATEGORIES } from '@sdk/core';
  // @ts-ignore
  import * as m from '../../paraglide/messages.js';

  interface Props {
    category: string;
    class?: string;
  }

  let { category, class: className = '' }: Props = $props();

  const categoryColor: Record<string, string> = {
    mexican:    'bg-orange-500/20 text-orange-400 border-orange-500/30',
    seafood:    'bg-blue-500/20 text-blue-400 border-blue-500/30',
    vegetarian: 'bg-green-500/20 text-green-400 border-green-500/30',
    street_food: 'bg-yellow-500/20 text-yellow-400 border-yellow-500/30',
    drinks:     'bg-purple-500/20 text-purple-400 border-purple-500/30',
    desserts:   'bg-pink-500/20 text-pink-400 border-pink-500/30',
    international: 'bg-indigo-500/20 text-indigo-400 border-indigo-500/30',
    fast_food:  'bg-red-500/20 text-red-400 border-red-500/30',
  };

  const categoryI18nKey: Record<string, () => string> = {
    mexican: () => m.cat_mexican(),
    seafood: () => m.cat_seafood(),
    street_food: () => m.cat_street_food(),
    drinks: () => m.cat_drinks(),
    desserts: () => m.cat_desserts(),
    international: () => m.cat_international(),
    vegetarian: () => m.cat_vegetarian(),
    fast_food: () => m.cat_fast_food(),
  };

  const badgeClass = $derived(categoryColor[category] ?? 'bg-neutral-500/20 text-neutral-400 border-neutral-500/30');
  const label = $derived(categoryI18nKey[category]?.() ?? category);
</script>

<span class="px-2.5 py-1 text-[10px] font-bold uppercase tracking-widest rounded-full
             backdrop-blur-sm border shadow-sm {badgeClass} {className}">
  {label}
</span>
