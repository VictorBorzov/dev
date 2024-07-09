{pkgs}: let
  configFile = pkgs.writeText "helix-config.toml" ''
    theme = "gruvbox"

     [editor]
     auto-save = true
     bufferline = "multiple"
     color-modes = true
     line-number = "relative"
     mouse = false
     shell = ["bash", "-c"]

     [editor.cursor-shape]
     insert = "bar"
     normal = "block"
     select = "underline"

     [editor.file-picker]
     hidden = false

     [editor.indent-guides]
     character = "┊"
     render = true
     skip-levels = 1

     [editor.lsp]
     display-signature-help-docs = false

     [editor.soft-wrap]
     enable = true

     [editor.statusline]
     center = ["file-name"]
     left = ["mode", "spinner"]
     right = ["diagnostics", "selections", "position", "file-encoding", "file-line-ending", "file-type"]
     separator = "│"

     [editor.statusline.mode]
     insert = "INSERT"
     normal = "NORMAL"
     select = "SELECT"

     [editor.whitespace]
     [editor.whitespace.characters]
     nbsp = "⍽"
     newline = "⏎"
     space = "·"
     tab = "→"
     tabpad = "·"

     [editor.whitespace.render]
     nbsp = "all"
     newline = "none"
     space = "all"
     tab = "all"

     [keys.insert]
       "C-[" = "normal_mode"

     [keys.normal]
     C-j = ["extend_to_line_bounds", "delete_selection", "paste_after"]
     C-k = ["extend_to_line_bounds", "delete_selection", "move_line_up", "paste_before"]
     C-l = [":new", ":insert-output ${pkgs.lazygit}/bin/lazygit", ":buffer-close!", ":redraw"]

     [keys.normal.space]
     F = ["file_picker"]
     f = ["file_picker_in_current_buffer_directory"]
  '';
in
  pkgs.stdenv.mkDerivation {
    name = "helix-wrapper";
    buildInputs = [pkgs.makeWrapper];
    dontUnpack = true;
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/bin
      makeWrapper ${pkgs.helix}/bin/hx $out/bin/hx \
        --add-flags "--config ${configFile}"
    '';
  }
