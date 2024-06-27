{
  description = "Development environments";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        helixWrapper = import ./helix { inherit pkgs; };
        zellijWrapper = import ./zellij { inherit pkgs; };
        lfWrapper = import ./lf { inherit pkgs; };
      in {
        packages = {
          helix = helixWrapper;
          zellij = zellijWrapper;
          lf = lfWrapper;
        };
        apps = {
          helix = {
            type = "app";
            program = "${helixWrapper}/bin/hx";
          };
          zellij = {
            type = "app";
            program = "${zellijWrapper}/bin/zellij";
          };
          lf = {
            type = "app";
            program = "${lfWrapper}/bin/lf";
          };
        };

        devShells = {
          default = pkgs.mkShell {
            buildInputs = [
              helixWrapper
              zellijWrapper
              lfWrapper
              pkgs.marksman
              pkgs.ltex-ls
            ];
          };

          dotnet = pkgs.mkShell {
            buildInputs = [
              helixWrapper
              zellijWrapper
              lfWrapper
              pkgs.dotnet-sdk_8
              pkgs.netcoredbg
              pkgs.omnisharp-roslyn
              pkgs.fsautocomplete
              pkgs.marksman
            ];
            shellHook = ''
              nix flake init -t gitlab:victorborzov/templates#helix
              grep "helix" .gitignore || echo "/.helix" >> .gitignore
              zellij
            '';
          };
          nix = pkgs.mkShell {
            buildInputs = [
              helixWrapper
              zellijWrapper
              lfWrapper
              pkgs.nil
              pkgs.alejandra
              pkgs.marksman
            ];
            shellHook = ''
              nix flake init -t gitlab:victorborzov/templates#helix
              grep "helix" .gitignore || echo "/.helix" >> .gitignore
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
              helixWrapper
              zellijWrapper
              lfWrapper
            ];
            shellHook = ''
              nix flake init -t gitlab:victorborzov/templates#helix
              grep "helix" .gitignore || echo "/.helix" >> .gitignore
              zellij
            '';
          };
          haskell = pkgs.mkShell {
            buildInputs = [
              pkgs.haskellPackages.cabal-install
              pkgs.haskellPackages.haskell-language-server
              pkgs.ghc
              helixWrapper
              zellijWrapper
              lfWrapper
              pkgs.marksman
            ];
            shellHook = ''
              nix flake init -t gitlab:victorborzov/templates#helix
              grep "helix" .gitignore || echo "/.helix" >> .gitignore
              zellij
            '';
          };
          rust = pkgs.mkShell {
            buildInputs = [
              pkgs.rustc
              pkgs.cargo
              pkgs.clippy
              pkgs.rustfmt
              pkgs.rust-analyzer
              helixWrapper
              zellijWrapper
              lfWrapper
              pkgs.marksman
            ];
            shellHook = ''
              nix flake init -t gitlab:victorborzov/templates#helix
              grep "helix" .gitignore || echo "/.helix" >> .gitignore
              zellij
            '';
          };
        };
        formatter = pkgs.alejandra;
      });
}
