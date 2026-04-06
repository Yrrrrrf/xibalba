{
  description = "xibalbá · client — Bun workspace (SvelteKit + SDK)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          name = "xibalba-client";

          packages = with pkgs; [
            bun # runtime · install · test · task runner
            just # justfile commands (client.just)
            nodejs # peer requirement for some vite/npm: deps
            podman # container engine
            podman-compose # container orchestration
          ];

          shellHook = ''
            echo "🌐 xibalbá client — bun $(bun --version | head -1)"
            echo "   just $(just --version)"
            echo "   podman $(podman --version | awk '{print $3}')"
          '';
        };
      }
    );
}
