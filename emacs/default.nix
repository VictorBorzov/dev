{nixpkgs, system, emacs-overlay}:
let
  pkgs = import nixpkgs {
    inherit system;
    overlays = [ emacs-overlay.overlays.default ];
  };
in (pkgs.emacsWithPackagesFromUsePackage {
  # Your Emacs config file. Org mode babel files are also
  # supported.
  # NB: Config files cannot contain unicode characters, since
  #     they're being parsed in nix, which lacks unicode
  #     support.
  # config = ./emacs.org;
  config = ./config.org;

  # Whether to include your config as a default init file.
  # If being bool, the value of config is used.
  # Its value can also be a derivation like this if you want to do some
  # substitution:
  #   defaultInitFile = pkgs.substituteAll {
  #     name = "default.el";
  #     src = ./emacs.el;
  #     inherit (config.xdg) configHome dataHome;
  #   };
  defaultInitFile = true;

  # Package is optional, defaults to pkgs.emacs
  package = pkgs.emacs30-pgtk;

  # By default emacsWithPackagesFromUsePackage will only pull in
  # packages with `:ensure`, `:ensure t` or `:ensure <package name>`.
  # Setting `alwaysEnsure` to `true` emulates `use-package-always-ensure`
  # and pulls in all use-package references not explicitly disabled via
  # `:ensure nil` or `:disabled`.
  # Note that this is NOT recommended unless you've actually set
  # `use-package-always-ensure` to `t` in your config.
  alwaysEnsure = true;

  # For Org mode babel files, by default only code blocks with
  # `:tangle yes` are considered. Setting `alwaysTangle` to `true`
  # will include all code blocks missing the `:tangle` argument,
  # defaulting it to `yes`.
  # Note that this is NOT recommended unless you have something like
  # `#+PROPERTY: header-args:emacs-lisp :tangle yes` in your config,
  # which defaults `:tangle` to `yes`.
  alwaysTangle = true;

  # Optionally provide extra packages not in the configuration file.
  extraEmacsPackages = epkgs: [
    epkgs.magit
    epkgs.doom-themes
    epkgs.org-roam
    epkgs.org-roam-ui
    epkgs.rust-mode
    epkgs.markdown-mode
    epkgs.nix-mode
    # epkgs.magit-delta
    epkgs.ledger-mode
    epkgs.gruber-darker-theme
    epkgs.smex
    # epkgs.multiple-cursors
    # epkgs.corfu
    # epkgs.cape
    # epkgs.consult
    # epkgs.vertico
    # epkgs.project
    # epkgs.doct
  ];
})
