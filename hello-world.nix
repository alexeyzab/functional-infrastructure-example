{ pkgs ? import <nixpkgs> {} }:
let
  src = ./hello-world.c;
in
  pkgs.runCommand "hello-world" { buildInputs = [ pkgs.gcc ]; } ''
    mkdir -pv $out/bin
    gcc ${src} -o $out/bin/hello-world
  ''
