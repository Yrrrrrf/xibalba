{
  description = "xibalbá · client — Deno 2 workspace (SvelteKit + SDK)";

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
            deno # runtime · fmt · lint · test · task runner
            just # justfile commands (client.just)
            nodejs # peer requirement for some vite/npm: deps
          ];

          shellHook = ''
            echo "🌐 xibalbá client — deno $(deno --version | head -1)"
            echo "   just $(just --version)"
          '';
        };
      }
    );
}
