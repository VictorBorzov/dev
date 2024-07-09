{
  description = "Dotnet app build";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    myDevTools.url = "gitlab:victorborzov/dev";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    myDevTools,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
        projectName = "HelloWorld";
      in {
        packages = {
          default = pkgs.buildDotnetModule {
            pname = projectName;
            version = "0.1";
            src = ./.;
            projectFile = "./${projectName}.csproj";
            nugetDeps = ./deps.nix;
            dotnet-sdk = pkgs.dotnetCorePackages.dotnet_8.sdk;
            selfContainedBuild = true;
            dotnetFlags = [
              "-p:InvariantGlobalization=true"
              "-p:PublishTrimmed=true"
              "-p:PublishSingleFile=true"
              "-p:IncludeNativeLibrariesForSelfExtract=True"
              "-p:DebugType=None"
              "-p:DebugSymbols=False"
            ];
            executables = [projectName];
          };
        };

        devShell = myDevTools.devShells.${system}.dotnet;
      }
    );
}
