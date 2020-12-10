{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.dev.docker;
  dev = config.modules.dev;
  username = config.properties.user.name;
  configHome = config.home-manager.users."${username}".xdg.configHome;
in
{
  options.modules.dev = {
    docker = {
      enable = mkEnableOption  "Enable docker.";
      autoPrune = mkEnableOption "Enable weekly cleanup.";
    };
  };

  config = mkIf (cfg.enable && dev.enable) {

    virtualisation.docker = {
      enable = true;
      autoPrune = {
        enable = cfg.autoPrune;
      };
    };

    users.users.${username}.extraGroups = [ "docker" ];

    home-manager.users."${username}" = {
      home.sessionVariables.DOCKER_CONFIG = "${configHome}/docker";

      home.file = {
        "bin/docker-arch" = {
          executable = true;
          text = ''
          #!/usr/bin/env bash
            docker run -ti --rm --entrypoint bash -u root archlinux -c "$*"
          '';
        };
        "bin/docker-centos" = {
          executable = true;
          text = ''
          #!/usr/bin/env bash
            docker run -ti --rm --entrypoint bash centos:7 -c "$*"
          '';
        };
        "bin/docker-cerebro" = {
          executable = true;
          text = ''
          #!/usr/bin/env bash
            docker run -ti --rm -p 9000:9000 lmenezes/cerebro
          '';
        };
        "bin/docker-mvn" = {
          executable = true;
          text = ''
          #!/usr/bin/env bash
            docker run -v $HOME/.m2:/var/maven/.m2 \
            -v "$PWD":/var/maven/src -w /var/maven/src  \
            -ti --rm -u $(id -u) \
            -e MAVEN_CONFIG=/var/maven/.m2 \
            maven:$1 \
            mvn -Duser.home=/var/maven ''${*:2}
          '';
        };
        "bin/docker-krb" = {
          executable = true;
          text = ''
            #!/usr/bin/env bash
            docker run -ti --rm -e KRB5_CONFIG=/etc/krb5.conf \
            -v ''$(pwd)/krb5.conf:/etc/krb5.conf \
            --entrypoint bash -w ''${PWD} \
            pilchard/krb5 -c "$*"
          '';
        };
      };
    };
  };
}

