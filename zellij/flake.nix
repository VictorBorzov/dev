{
  description = "Configured zellij multiplexer as a flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        # Basic configuration for Zellij, this might include keybindings, plugins, etc.
        configFile = pkgs.writeText "zellij-config.yaml" ''
          themes {
           rose-pine-dawn {
            bg "#faf4ed"
            fg "#575279"
            red "#b4637a"
            green "#286983"
            blue "#56949f"
            yellow "#ea9d34"
            magenta "#907aa9"
            orange "#fe640b"
            cyan "#d7827e"
            black "#f2e9e1"
            white "#575279"
           }
          
           rose-pine-moon {
            bg "#232136"
            fg "#e0def4"
            red "#eb6f92"
            green "#3e8fb0"
            blue "#9ccfd8"
            yellow "#f6c177"
            magenta "#c4a7e7"
            orange "#fe640b"
            cyan "#ea9a97"
            black "#393552"
            white "#e0def4"
           }
          }
          theme "rose-pine-moon"
          // default_layout "compact"
          // pane_frames false
      '';

        # Custom Zellij package that is aware of the custom config
        zellijWrapper = pkgs.stdenv.mkDerivation {
          name = "zellij-wrapper";
          buildInputs = [ pkgs.makeWrapper ];
          dontUnpack = true;
          dontBuild = true;
          installPhase = ''
            mkdir -p $out/bin
            makeWrapper ${pkgs.zellij}/bin/zellij $out/bin/zellij \
              --add-flags "--config ${configFile}"
          '';
        };

      in
      {
        packages.default = zellijWrapper;
        apps.default = {
          type = "app";
          program = "${zellijWrapper}/bin/zellij";
        };
        defaultPackage = self.packages.${system}.default;
      }
    );
}
