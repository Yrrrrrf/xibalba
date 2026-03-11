{
  description = "Xibalbá";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    # ← pull directly from the sub-flakes, no duplication
    client.url = "path:./src/client";
    server.url = "path:./src/server";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      client,
      server,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        clientPkgs = client.packages.${system}.devPackages;
        serverPkgs = server.packages.${system}.devPackages;
        infraPkgs = with pkgs; [
          docker-compose
          curl
          jq
        ];
      in
      {
        devShells.default = pkgs.mkShell {
          name = "xibalba";
          packages = clientPkgs ++ serverPkgs ++ infraPkgs;
          shellHook = ''echo "Xibalbá"'';
        };

        devShells.client = pkgs.mkShell {
          name = "xibalba-client";
          packages = clientPkgs ++ infraPkgs;
        };

        devShells.server = pkgs.mkShell {
          name = "xibalba-server";
          packages = serverPkgs ++ infraPkgs;
        };
      }
    );
}
