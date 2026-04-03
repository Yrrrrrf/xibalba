export interface StatSnapshot {
  icon: string;
  title: string;
  value: string | number;
  variant: "primary" | "secondary" | "accent" | "success" | "warning" | "error";
  trend: "up" | "down" | "neutral";
  trendValue?: string;
  desc?: string;
}
