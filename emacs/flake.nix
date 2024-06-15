{
  description = "Emacs setup as a flake with configuration from an Org file using emacs-overlay, including magit";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    emacs-overlay,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [emacs-overlay.overlay];
        };

        # Org file containing Emacs configuration
        emacsConfigOrg = pkgs.writeText "emacs-config.org" ''
          #+TITLE: Emacs Configuration

          * Emacs Setup
          #+BEGIN_SRC emacs-lisp
            (require 'use-package)

            ;; Magit package configuration
            (use-package magit
              :config
              (global-set-key (kbd "C-x g") 'magit-status))
          #+END_SRC
        '';

        # Custom Emacs package that includes magit
        customEmacs = pkgs.emacsWithPackages (epkgs:
          with epkgs.melpaPackages; [
            magit # Ensure Magit is correctly referenced
          ]);

        # Custom Emacs package that uses the Org config
        emacsWrapper = pkgs.stdenv.mkDerivation {
          name = "emacs-wrapper";
          buildInputs = [pkgs.makeWrapper customEmacs];
          dontUnpack = true;
          dontBuild = true;
          installPhase = ''
            mkdir -p $out/bin
            makeWrapper ${customEmacs}/bin/emacs $out/bin/emacs \
              --add-flags "-q --eval '(org-babel-load-file \"${emacsConfigOrg}\")'"
          '';
        };
      in {
        packages.default = emacsWrapper;
        apps.default = {
          type = "app";
          program = "${emacsWrapper}/bin/emacs";
        };
        defaultPackage = self.packages.${system}.default;
      }
    );
}
