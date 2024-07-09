{
  description = "My rust app";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    myDevTools.url = "gitlab:victorborzov/dev";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    myDevTools,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
      in {
        packages = {
          default = pkgs.rustPlatform.buildRustPackage {
            pname = "app_name";
            version = "0.1.0";
            src = ./.;
            cargoLock = {lockFile = ./Cargo.lock;};
          };
        };

        devShell = myDevTools.devShells.${system}.rust;
      }
    );
}
