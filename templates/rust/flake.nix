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
        appName = "guessing_game";
        app = pkgs.rustPlatform.buildRustPackage {
          pname = appName;
          version = "0.1.0";
          src = ./.;
          cargoLock = {lockFile = ./Cargo.lock;};
        };
      in {
        packages = {
          default = app;
          docker = pkgs.dockerTools.buildLayeredImage {
            name = appName;
            tag = "latest";
            config = {
              Cmd = ["${app}/${appName}"];
              WorkingDir = "/root";
            };
          };
        };

        devShell = myDevTools.devShells.${system}.rust;
      }
    );
}
