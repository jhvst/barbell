{

  inputs = {
    barbell.url = "github:jhvst/barbell?dir=packages/barbell";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
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
