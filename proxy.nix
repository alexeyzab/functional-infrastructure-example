let
  hostname = builtins.getEnv "USER" + ".infunstructure.com";
in
  {
    proxy =
      { resources, pkgs, lib, nodes, config, ...}:
      {
        security.acme.preliminarySelfsigned = true;
        security.acme.certs."${hostname}" = {
          webroot = "/var/www/challenges";
          email = "webmaster@${hostname}";
          user = "nginx";
          group = "nginx";
          postRun = ''
            systemctl restart nginx.service
          '';
        };

        ## A place to put challenges
        system.activationScripts.nginx = {
          text = ''
            mkdir -p /var/www/challenges
            chown nginx.nginx /var/www /var/www/challenges
          '';
          deps = [];
        };

        deployment.route53.hostName =
          builtins.getEnv "USER" + ".infunstructure.com";
        networking.firewall.allowedTCPPorts = [ 22 80 443 ];
        services.nginx.enable = true;
        services.nginx.httpConfig =
          import ./nginx-conf.nix { inherit nodes config hostname; };
      };
  }
