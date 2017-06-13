{ stdenv, pkgs }:
let
  mkHome = { user, files, environment }: let
    src = pkgs.writeText "${user}-nix-home.json" (builtins.toJSON {
       inherit files;
       inherit environment;
    });

  writeFiles = ./../writeFiles.py;
  
  in stdenv.mkDerivation {
      name = "${user}-nix-home";
      inherit src;
      
      builder = pkgs.writeText "builder.sh" ''
        #!/bin/sh

        . $stdenv/setup

        mkdir -p $out
        ${pkgs.python}/bin/python ${writeFiles} "$src" "$out"
      '';
  } ++ environment;
in
{
  inherit mkHome;
}
