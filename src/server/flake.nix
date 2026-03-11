{
  description = "Xibalbá — Server (Rust API + WASM bridge)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    naersk = {
      url = "github:nix-community/naersk";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # 1. Add rust-overlay to get customized toolchains (like WASM targets)
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      naersk,
      rust-overlay,
    }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      devShells = forAllSystems (
        system:
        let
          # 2. Apply the overlay to our pkgs
          overlays = [ (import rust-overlay) ];
          pkgs = import nixpkgs { inherit system overlays; };

          # 3. Define a custom Rust toolchain that INCLUDES the wasm32 target!
          rustToolchain = pkgs.rust-bin.stable.latest.default.override {
            targets = [ "wasm32-unknown-unknown" ];
          };
        in
        {
          default = pkgs.mkShell {
            name = "xibalba-server";

            buildInputs = with pkgs; [
              openssl
              rustToolchain # Replaces cargo, rustc, rustfmt, clippy
              rust-analyzer

              just
              wasm-bindgen-cli
              deno
              xh
              docker
              docker-compose
              cargo-watch
              bacon
            ];

            nativeBuildInputs = with pkgs; [ pkg-config ];

            env = {
              OPENSSL_DIR = "${pkgs.openssl.dev}";
              OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";
              RUST_LOG = "info,api=debug";
              RUST_BACKTRACE = "1";
            };

            shellHook = ''
              echo ""
              echo "  ⚙️  Xibalbá · Server Dev Shell"
              echo "  ─────────────────────────────────────────────────────"
              echo "  Rust  : $(rustc --version)"
              echo "  Cargo : $(cargo --version)"
              echo "  just  : $(just --version)"
              echo "  ─────────────────────────────────────────────────────"
              echo "  Target 'wasm32-unknown-unknown' is natively injected by Nix!"
              echo "  ─────────────────────────────────────────────────────"
            '';
          };
        }
      );

      packages = forAllSystems (
        system:
        let
          # Apply the overlay here too so naersk uses the WASM-enabled toolchain
          overlays = [ (import rust-overlay) ];
          pkgs = import nixpkgs { inherit system overlays; };

          rustToolchain = pkgs.rust-bin.stable.latest.default.override {
            targets = [ "wasm32-unknown-unknown" ];
          };

          # Tell naersk to use our custom toolchain
          naerskLib = pkgs.callPackage naersk {
            cargo = rustToolchain;
            rustc = rustToolchain;
          };

          commonArgs = {
            src = ./engine;
            buildInputs = with pkgs; [ openssl ];
            nativeBuildInputs = with pkgs; [ pkg-config ];
            OPENSSL_DIR = "${pkgs.openssl.dev}";
            OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";
          };
        in
        {
          api = naerskLib.buildPackage (
            commonArgs
            // {
              pname = "xibalba-api";
              cargoBuildOptions =
                opts:
                opts
                ++ [
                  "-p"
                  "api"
                ];
            }
          );

          wasm = naerskLib.buildPackage (
            commonArgs
            // {
              pname = "xibalba-wasm";
              cargoBuildOptions =
                opts:
                opts
                ++ [
                  "-p"
                  "wasm"
                  "--lib"
                  "--target"
                  "wasm32-unknown-unknown"
                ];
            }
          );

          default = self.packages.${system}.api;
        }
      );
    };
}
