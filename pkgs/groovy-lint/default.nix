{ pkgs ? import <nixpkgs> {} }:

pkgs.writeShellApplication {
  name = "groovy-lint";
  runtimeInputs = [
    pkgs.nodejs
    pkgs.jre_minimal
  ];

  text = ''
    #!/usr/bin/env bash

    # Check if a filename was provided
    if [ $# -eq 0 ]; then
      echo "Usage: groovy-lint <your-jenkinsfile>"
      exit 1
    fi

    # Run npm-groovy-lint on the provided file using npx
    npx --yes npm-groovy-lint --fix "$1"
  '';
}
