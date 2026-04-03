import { type StatSnapshot } from "@sdk/core";

// READY(db): DB computed business.rating, business.review_count.
// TODO(db): Add aggregate queries for global stats
export function createAnalyticsStore() {
  const globalStats = $state<StatSnapshot[]>([
    {
      title: "Comerciantes Activos",
      value: "48",
      icon: "🏪",
      trend: "up",
      trendValue: "+12%",
      desc: "vs semana pasada",
      variant: "primary",
    },
    {
      title: "Ventas Totales",
      value: "6,841",
      icon: "💰",
      trend: "up",
      trendValue: "+8.4%",
      desc: "vs ayer",
      variant: "accent",
    },
  ]);

  return {
    get global() {
      return globalStats;
    },
  };
}
