{pkgs}: let
  previewer = pkgs.writeShellScriptBin "pv.sh" ''
    file=$1
    w=$2
    h=$3
    x=$4
    y=$5

    if [[ "$( ${pkgs.file}/bin/file -Lb --mime-type "$file")" =~ ^image ]]; then
        ${pkgs.kitty}/bin/kitty +kitten icat --silent --stdin no --transfer-mode file --place "''${w}x''${h}@''${x}x''${y}" "$file" < /dev/null > /dev/tty
        exit 1
    fi

    ${pkgs.pistol}/bin/pistol "$file"
  '';
  cleaner = pkgs.writeShellScriptBin "clean.sh" ''
    ${pkgs.kitty}/bin/kitty +kitten icat --clear --stdin no --silent --transfer-mode file < /dev/null > /dev/tty
  '';
  configFile = pkgs.writeText "config.kdl" ''
    set drawbox
    set hidden
    set icons
    set ignorecase
    set preview

    cmd dragon-out %${pkgs.xdragon}/bin/xdragon -a -x "$fx"
    cmd editor-open $$EDITOR $f
    cmd mkdir ''${{
      printf "Directory Name: "
      read DIR
      mkdir $DIR
    }}


    map . set hidden!
    map <enter> open
    map V ${pkgs.bat}/bin/bat --paging=always "$f"
    map \"
    map \' mark-load
    map ` mark-load
    map c mkdir
    map do dragon-out
    map ee editor-open
    map g/ /
    map gh cd
    map g~ cd
    map o

    set cleaner ${cleaner}/bin/clean.sh
    set previewer ${previewer}/bin/pv.sh
  '';
in
  pkgs.stdenv.mkDerivation {
    name = "lf-wrapper";
    buildInputs = [pkgs.makeWrapper];
    dontUnpack = true;
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/bin
      makeWrapper ${pkgs.lf}/bin/lf $out/bin/lf \
        --add-flags "-config ${configFile}"
    '';
  }
