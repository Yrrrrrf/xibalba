export function makeIcon(color: string) {
  const svg = `
    <svg xmlns="http://www.w3.org/2000/svg" width="40" height="50" viewBox="0 0 40 50">
      <filter id="s"><feDropShadow dx="0" dy="3" stdDeviation="3" flood-opacity="0.35"/></filter>
      <path filter="url(#s)" d="M20 3C11.2 3 4 10.2 4 19c0 12 16 28 16 28S36 31 36 19C36 10.2 28.8 3 20 3z" fill="${color}"/>
      <circle cx="20" cy="19" r="10" fill="white" opacity="0.95"/>
      <text x="20" y="23" text-anchor="middle" font-size="13">🏪</text>
    </svg>`;
  return `data:image/svg+xml;base64,${btoa(svg)}`;
}
