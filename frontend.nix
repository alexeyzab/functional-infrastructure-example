{ pkgs ? import <nixpkgs> {} }:
let
  helloStatic = import ./hello-static.nix {};
in
  {
    frontend =
      { resources, pkgs, lib, nodes, config, ...}:
      {
        networking.firewall.allowedTCPPorts = [ 22 80 ];
        services.nginx.enable = true;
        services.nginx.httpConfig = ''
          server {
              listen 80;
              location / {
                root ${helloStatic};
                index index.html;
              }
          }
        '';
      };
  }
