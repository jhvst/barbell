{

  inputs = {
    barbell.inputs.nixpkgs.follows = "nixpkgs";
    barbell.url = "github:jhvst/barbell?dir=packages/barbell";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { ... }@inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } {

    systems = inputs.nixpkgs.lib.systems.flakeExposed;

    perSystem = { pkgs, config, inputs', ... }: {

      devShells.default = pkgs.mkShell {
        packages = [ config.packages.barbell ];
      };

      packages = {
        barbell = inputs'.barbell.packages.default;
        default = config.packages.barbell;
      };
    };
  };
}
