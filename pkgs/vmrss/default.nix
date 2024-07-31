{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  name = "vmrss";
  src = ./.;

  buildInputs = [ pkgs.gnused pkgs.gawk pkgs.bc pkgs.procps pkgs.psmisc ];

  installPhase = ''
    mkdir -p $out/bin
    install -m755 vmrss.sh $out/bin/vmrss
  '';
}
