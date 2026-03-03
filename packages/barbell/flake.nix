{

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = { ... }@inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } {
    systems = inputs.nixpkgs.lib.systems.flakeExposed;
    perSystem = { pkgs, config, ... }:
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
