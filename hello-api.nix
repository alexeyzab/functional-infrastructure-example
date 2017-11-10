{ pkgs ? import <nixpkgs> {} }:
let
  paths = pkgs: [ pkgs.scotty pkgs.aeson pkgs.hostname ];
  ghc = pkgs.haskellPackages.ghcWithPackages paths;
  src = ./.;
in
  pkgs.runCommand "hello-api" { buildInputs = [ ghc ]; } ''
    mkdir -pv $out/bin
    TMP=`mktemp -d`
    ghc -odir $TMP \
        -hidir $TMP \
        -O2 ${src}/hello-api.hs \
        -o $out/bin/hello-api
  ''
