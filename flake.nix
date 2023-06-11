{

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
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
      rec {
        packages.barbell = pkgs.symlinkJoin {
          name = name;
          paths = [ barbell-script ] ++ [ pkgs.cbqn ];
          buildInputs = with pkgs; [ makeWrapper ];
          postBuild = "wrapProgram $out/bin/${name} --prefix PATH : $out/bin";
        };
        packages.default = packages.barbell;
      }
    );
}
