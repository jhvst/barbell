{

  inputs = {
    barbell.inputs.nixpkgs.follows = "nixpkgs";
    barbell.url = "github:jhvst/barbell?dir=packages/barbell";
    devenv.url = "github:cachix/devenv";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    neovim.inputs.nixpkgs.follows = "nixpkgs";
    neovim.url = "github:jhvst/barbell?dir=packages/neovim";
  };

  outputs =
    inputs@{ self
    , devenv
    , flake-parts
    , nixpkgs
    , ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {

      systems = nixpkgs.lib.systems.flakeExposed;
      imports = [
        inputs.devenv.flakeModule
      ];

      perSystem = { pkgs, lib, config, system, inputs', ... }: {

        packages.barbell = inputs'.barbell.packages.default;
        packages.neovim = inputs'.neovim.packages.default;

        devenv.shells.default = {
          packages = [
            config.packages.barbell
            config.packages.neovim
          ];
        };

        packages.default = config.packages.barbell;

      };
    };
}
