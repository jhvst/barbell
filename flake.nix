{

  inputs = {
    bqnlsp.inputs.nixpkgs.follows = "nixpkgs";
    bqnlsp.url = "sourcehut:~detegr/bqnlsp";
    devenv.url = "github:cachix/devenv";
    flake-parts.url = "github:hercules-ci/flake-parts";
    juuso.inputs.nixpkgs.follows = "nixpkgs";
    juuso.url = "github:jhvst/nix-config";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixvim.url = "github:nix-community/nixvim";
  };

  outputs =
    inputs@{ self
    , bqnlsp
    , devenv
    , flake-parts
    , juuso
    , nixpkgs
    , nixvim
    , ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {

      systems = nixpkgs.lib.systems.flakeExposed;
      imports = [
        inputs.devenv.flakeModule
      ];

      perSystem = { pkgs, lib, config, system, ... }:
        let
          name = "barbell";
          barbell-script = (pkgs.writeScriptBin name (builtins.readFile ./barbell-script.sh)).overrideAttrs (old: {
            src = ./.;
            buildCommand = ''
              ${old.buildCommand}
              patchShebangs $out
              cp $src/barbell.bqn $out/bin
              substituteInPlace $out/bin/barbell \
                --replace barbell.bqn $out/bin/barbell.bqn
            '';
          });
        in
        {

          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [
              inputs.juuso.overlays.default
            ];
            config = { };
          };

          packages.barbell = pkgs.symlinkJoin {
            name = name;
            paths = [ barbell-script ] ++ [ pkgs.cbqn ];
            buildInputs = with pkgs; [ makeWrapper ];
            postBuild = "wrapProgram $out/bin/${name} --prefix PATH : $out/bin";
          };

          packages.neovim = nixvim.legacyPackages.${system}.makeNixvimWithModule {
            inherit pkgs;
            module = {
              imports = [
                inputs.juuso.outputs.nixosModules.neovim
              ];
              extraPackages = with pkgs; [
                cbqn # bqnlsp assumes cbqn in path
              ];
              extraConfigVim = ''
                au BufRead,BufNewFile *.bqn setf bqn
                au BufRead,BufNewFile * if getline(1) =~ '^#!.*bqn$' | setf bqn | endif
              '';
              plugins.lsp = {
                enable = true;
                preConfig = ''
                  local configs = require('lspconfig.configs')
                  local util = require('lspconfig.util')

                  if not configs.bqnlsp then
                    configs.bqnlsp = {
                      default_config = {
                        cmd = { 'bqnlsp' },
                        cmd_env = {},
                        filetypes = { 'bqn' },
                        root_dir = util.find_git_ancestor,
                        single_file_support = false,
                      },
                      docs = {
                        description = [[ BQN Language Server ]],
                        default_config = {
                          root_dir = [[util.find_git_ancestor]],
                        },
                      },
                    }
                  end
                '';
              };
              extraPlugins = [
                inputs.bqnlsp.packages.${system}.lsp
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
