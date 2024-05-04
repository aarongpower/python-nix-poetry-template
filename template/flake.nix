{
  description = "Python build and development environment";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # fenix.url = "github:nix-community/fenix";
    # fenix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, poetry2nix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        # see https://github.com/nix-community/poetry2nix/tree/master#api for more functions and examples.
        pkgs = nixpkgs.legacyPackages.${system};
        inherit (poetry2nix.lib.mkPoetry2Nix { inherit pkgs; }) mkPoetryApplication;
        # rustTools = fenix.packages.${system};
      in
      {
        packages = {
          app = mkPoetryApplication { 
            projectDir = self;
            # python = pkgs.python313;
          };
          default = self.packages.${system}.app;
        };

        devShells.default = pkgs.mkShell {
          inputsFrom = [ self.packages.${system}.app ];
          packages = [ 
            pkgs.poetry
          ];
        };
      });
}
