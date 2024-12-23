{

  inputs = {
    bqnlsp.inputs.nixpkgs.follows = "nixpkgs";
    bqnlsp.url = "sourcehut:~detegr/bqnlsp";
    flake-parts.url = "github:hercules-ci/flake-parts";
    juuso.inputs.nixpkgs.follows = "nixpkgs";
    juuso.url = "github:jhvst/nix-config";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.url = "github:nix-community/nixvim";
  };

  outputs =
    inputs@{ self
    , bqnlsp
    , flake-parts
    , juuso
    , nixpkgs
    , nixvim
    , ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {

      systems = nixpkgs.lib.systems.flakeExposed;
      imports = [ ];

      perSystem = { pkgs, lib, config, system, ... }:
        {

          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [
              inputs.juuso.overlays.default
            ];
            config = { };
          };

          packages.neovim = nixvim.legacyPackages.${system}.makeNixvimWithModule {
            inherit pkgs;
            module = {
              imports = [
                inputs.juuso.outputs.nixosModules.neovim
              ];
              extraConfigVim = ''
                au BufRead,BufNewFile *.bqn setf bqn
                au BufRead,BufNewFile * if getline(1) =~ '^#!.*bqn$' | setf bqn | endif
              '';
              plugins.lsp = {
                enable = true;
                servers.bqnlsp = {
                  enable = true;
                  package = inputs.bqnlsp.packages.${system}.lsp;
                };
              };
              extraPlugins = [
                (pkgs.vimUtils.buildVimPluginFrom2Nix {
                  pname = "bqn-vim";
                  version = pkgs.mbqn.version;
                  src = pkgs.mbqn.src;
                  sourceRoot = "source/editors/vim";
                  meta.homepage = "https://github.com/mlochbaum/BQN/editors/vim";
                })
                (pkgs.vimUtils.buildVimPluginFrom2Nix {
                  pname = "nvim-bqn";
                  version = "unstable";
                  src = builtins.fetchGit {
                    url = "https://git.sr.ht/~detegr/nvim-bqn";
                    rev = "bbe1a8d93f490d79e55dd0ddf22dc1c43e710eb3";
                  };
                  meta.homepage = "https://git.sr.ht/~detegr/nvim-bqn/";
                })
              ];
            };
          };

          packages.default = config.packages.neovim;

        };
    };
}
