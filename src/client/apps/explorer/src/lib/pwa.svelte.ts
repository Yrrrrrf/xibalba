import { browser } from "$app/environment";

export function createPwaInstallStore() {
  let promptEvent = $state<any>(null);
  let isInstallable = $state(false);

  if (browser) {
    window.addEventListener("beforeinstallprompt", (e) => {
      e.preventDefault();
      promptEvent = e;
      isInstallable = true;
    });

    window.addEventListener("appinstalled", () => {
      promptEvent = null;
      isInstallable = false;
    });
  }

  return {
    get isInstallable() {
      return isInstallable;
    },
    async prompt() {
      if (!promptEvent) return;
      promptEvent.prompt();
      const { outcome } = await promptEvent.userChoice;
      if (outcome === "accepted") {
        isInstallable = false;
        promptEvent = null;
      }
    },
  };
}
