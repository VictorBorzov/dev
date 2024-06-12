{
  description = "Development environments";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    helixWrapper.url = "gitlab:victorborzov/dev?dir=helix";
    zellijWrapper.url = "gitlab:victorborzov/dev?dir=zellij";
    lfWrapper.url = "gitlab:victorborzov/dev?dir=lf";
  };

  outputs = { self, nixpkgs, flake-utils, helixWrapper, zellijWrapper, lfWrapper, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages = {
          helix = helixWrapper.packages.${system}.default;
          zellij = zellijWrapper.packages.${system}.default;
          lf = lfWrapper.packages.${system}.default;
        };
        apps = {
          helix = helixWrapper.apps.${system}.default;
          zellij = zellijWrapper.apps.${system}.default;
          lf = lfWrapper.apps.${system}.default;
        };

        devShells = {
          default = pkgs.mkShell {
            buildInputs = [
              self.packages.${system}.helix
              self.packages.${system}.zellij
              self.packages.${system}.lf
              pkgs.marksman
            ];
          };

          dotnet = pkgs.mkShell {
            buildInputs = [
              self.packages.${system}.helix
              self.packages.${system}.zellij
              self.packages.${system}.lf
              pkgs.dotnet-sdk_8
              pkgs.netcoredbg
              pkgs.omnisharp-roslyn
              pkgs.fsautocomplete
              pkgs.marksman
            ];
            shellHook = ''
              nix flake init -t gitlab:victorborzov/templates#helix
              zellij
            '';
          };
          nix = pkgs.mkShell {
            buildInputs = [
              self.packages.${system}.helix
              self.packages.${system}.zellij
              self.packages.${system}.lf
              pkgs.nil
              pkgs.nixpkgs-fmt
              pkgs.marksman
            ];
            shellHook = ''
              nix flake init -t gitlab:victorborzov/templates#helix
              zellij
            '';
          };
          go = pkgs.mkShell {
            buildInputs = [
              pkgs.go
              pkgs.gopls
              pkgs.go-tools
              pkgs.gotools
              pkgs.delve
              pkgs.marksman
              self.packages.${system}.helix
              self.packages.${system}.zellij
              self.packages.${system}.lf
            ];
            shellHook = ''
              nix flake init -t gitlab:victorborzov/templates#helix
              zellij
            '';
          };
          haskell = pkgs.mkShell {
            buildInputs = [
              pkgs.haskellPackages.cabal-install
              pkgs.haskellPackages.haskell-language-server
              pkgs.ghc
              self.packages.${system}.helix
              self.packages.${system}.zellij
              self.packages.${system}.lf
              pkgs.marksman
            ];
            shellHook = ''
              nix flake init -t gitlab:victorborzov/templates#helix
              zellij
            '';
          };

        };
        formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
      }
    );
}
