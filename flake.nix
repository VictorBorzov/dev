{
  description = "Development environments";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    emacs-overlay,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
      helixWrapper = import ./helix {inherit pkgs;};
      zellijWrapper = import ./zellij {inherit pkgs;};
      lfWrapper = import ./lf {inherit pkgs;};
      emacsWrapper = import ./emacs {inherit nixpkgs system emacs-overlay;};
      basics = [
        helixWrapper
        zellijWrapper
        lfWrapper
        pkgs.markdown-oxide
        pkgs.ltex-ls
      ];
      basicHook = ''
        zellij
      '';
    in {
      packages = {
        helix = helixWrapper;
        zellij = zellijWrapper;
        lf = lfWrapper;
        emacs = emacsWrapper;
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
        emacs = {
          type = "app";
          program = "${emacsWrapper}/bin/emacs";
        };
      };

      devShells = {
        default = pkgs.mkShell {
          buildInputs = basics;
        };

        dotnet = pkgs.mkShell {
          buildInputs =
            basics
            ++ [
              pkgs.dotnet-sdk_8
              pkgs.netcoredbg
              pkgs.omnisharp-roslyn
              pkgs.fsautocomplete
            ];
          shellHook = basicHook;
        };
        nix = pkgs.mkShell {
          buildInputs =
            basics
            ++ [
              pkgs.nil
              pkgs.alejandra
            ];
          shellHook = basicHook;
        };
        go = pkgs.mkShell {
          buildInputs =
            basics
            ++ [
              pkgs.go
              pkgs.gopls
              pkgs.go-tools
              pkgs.gotools
              pkgs.delve
            ];
          shellHook = basicHook;
        };
        ts = pkgs.mkShell {
          buildInputs =
            basics
            ++ [
              pkgs.typescript
              pkgs.nodePackages.typescript-language-server
            ];
          shellHook = basicHook;
        };
        haskell = pkgs.mkShell {
          buildInputs =
            basics
            ++ [
              pkgs.haskellPackages.cabal-install
              pkgs.haskellPackages.haskell-language-server
              pkgs.ghc
            ];
          shellHook = basicHook;
        };
        rust = pkgs.mkShell {
          buildInputs =
            basics
            ++ [
              pkgs.rustc
              pkgs.cargo
              pkgs.clippy
              pkgs.rustfmt
              pkgs.rust-analyzer
            ];
          shellHook = basicHook;
        };
        cpp = pkgs.mkShell {
          buildInputs =
            basics
            ++ [
              pkgs.clang-tools
            ];
          shellHook = basicHook;
        };
        tex = pkgs.mkShell {
          buildInputs =
            basics
            ++ [
              pkgs.texlive.combined.scheme-full
              pkgs.texlab
            ];
          shellHook = basicHook;
        };
      };
      formatter = pkgs.alejandra;

      templates = {
        dotnet = {
          path = ./templates/dotnet;
          description = "Dotnet application template";
        };
        rust = {
          path = ./templates/rust;
          description = "Rust application template";
        };
        helix = {
          path = ./templates/helix;
          description = "Helix workspace template";
        };
      };
    });
}
