{

  inputs = {
    barbell.inputs.nixpkgs.follows = "nixpkgs";
    barbell.url = "github:jhvst/barbell?dir=packages/barbell";
    devenv.url = "github:cachix/devenv";
    flake-parts.url = "github:hercules-ci/flake-parts";
    mk-shell-bin.url = "github:rrbutani/nix-mk-shell-bin";
    neovim.inputs.nixpkgs.follows = "nixpkgs";
    neovim.url = "github:jhvst/barbell?dir=packages/neovim";
    nix2container.inputs.nixpkgs.follows = "nixpkgs";
    nix2container.url = "github:nlewo/nix2container";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
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
