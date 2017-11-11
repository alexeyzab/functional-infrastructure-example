{ pkgs ? import <nixpkgs> {} }:
let
  src = ./.;
in
  pkgs.runCommand "hello-static" { buildInputs = [ ]; } ''
    mkdir -p $out
    cp ${src}/index.html $out/index.html
  ''
