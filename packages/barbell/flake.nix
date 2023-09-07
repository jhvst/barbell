{

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{ self
    , flake-parts
    , nixpkgs
    , ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {

      systems = nixpkgs.lib.systems.flakeExposed;
      imports = [ ];

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

          packages.barbell = pkgs.symlinkJoin {
            name = name;
            paths = [ barbell-script ] ++ [ pkgs.cbqn ];
            buildInputs = with pkgs; [ makeWrapper ];
            postBuild = "wrapProgram $out/bin/${name} --prefix PATH : $out/bin";
          };

          packages.default = config.packages.barbell;

        };
    };
}
