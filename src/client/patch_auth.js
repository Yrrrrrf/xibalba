const fs = require('fs');
const files = [
  "c:/Users/DXTER/OneDrive/Documents/Meztli Ocelotl/Xibalba/xibalba/src/client/sdk/ui/src/components/primitives/Navigation.svelte",
  "c:/Users/DXTER/OneDrive/Documents/Meztli Ocelotl/Xibalba/xibalba/src/client/sdk/ui/src/components/primitives/BottomNav.svelte",
  "c:/Users/DXTER/OneDrive/Documents/Meztli Ocelotl/Xibalba/xibalba/src/client/sdk/ui/src/components/layout/Navbar.svelte",
  "c:/Users/DXTER/OneDrive/Documents/Meztli Ocelotl/Xibalba/xibalba/src/client/apps/explorer/src/routes/merchant/register/+page.svelte",
  "c:/Users/DXTER/OneDrive/Documents/Meztli Ocelotl/Xibalba/xibalba/src/client/apps/explorer/src/routes/dashboard/+page.svelte",
  "c:/Users/DXTER/OneDrive/Documents/Meztli Ocelotl/Xibalba/xibalba/src/client/apps/explorer/src/routes/admin/+page.svelte",
  "c:/Users/DXTER/OneDrive/Documents/Meztli Ocelotl/Xibalba/xibalba/src/client/apps/explorer/src/routes/(auth)/login/+page.svelte",
  "c:/Users/DXTER/OneDrive/Documents/Meztli Ocelotl/Xibalba/xibalba/src/client/apps/explorer/src/routes/(auth)/register/+page.svelte"
];

for (const file of files) {
  if (fs.existsSync(file)) {
    let content = fs.readFileSync(file, 'utf8');
    content = content.replace(/import\s+\{\s*createAuthStore(,\s*createDishStore)?\s*\}\s*from\s*"@sdk\/state";/g, 'import { authStore$1 } from "@sdk/state";');
    content = content.replace(/import\s+\{\s*createDishStore,\s*createAuthStore\s*\}\s*from\s*"@sdk\/state";/g, 'import { createDishStore, authStore } from "@sdk/state";');
    // Replace const auth = createAuthStore(); -> const auth = authStore;
    content = content.replace(/const\s+(auth|authStore)\s*=\s*createAuthStore\(\);/g, 'const $1 = authStore;');
    fs.writeFileSync(file, content);
  }
}

// Update mod.ts export and auth.svelte.ts
const authStorePath = "c:/Users/DXTER/OneDrive/Documents/Meztli Ocelotl/Xibalba/xibalba/src/client/sdk/state/src/stores/auth.svelte.ts";
let authStoreContent = fs.readFileSync(authStorePath, 'utf8');
if (!authStoreContent.includes('export const authStore =')) {
  authStoreContent += `\nexport const authStore = createAuthStore();\n`;
  fs.writeFileSync(authStorePath, authStoreContent);
}

console.log("Done");
