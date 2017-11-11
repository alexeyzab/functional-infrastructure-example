{ pkgs ? import <nixpkgs> {} }:
let
  helloApi = import ./hello-api.nix {};
  backendPlan =
    { resources, pkgs, lib, nodes, ...}:
    {
      networking.firewall.allowedTCPPorts = [ 22 3000 ];
      environment = {
        DB_URI = resources.rdsDbInstances.nixed.endpoint;
      };
      systemd.services.backend = {
        description = "hello-api";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          WorkingDirectory = "${helloApi}";
          ExecStart = "${helloApi}/bin/hello-api";
          Restart = "always";
        };
      };
    };
in
  {
    backend = backendPlan;
    backend2 = backendPlan;
    backend3 = backendPlan;
  }
