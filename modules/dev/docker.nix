{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.dev.docker;
  dev = config.modules.dev;
  username = config.properties.user.name;
  configHome = config.home-manager.users."${username}".xdg.configHome;

  docker-arch = pkgs.writeScriptBin "docker-arch " ''
    #!/usr/bin/env bash
    docker run -ti --rm --entrypoint bash -u root archlinux -c "$*"
  '';

  docker-centos = pkgs.writeScriptBin "docker-centos " ''
    #!/usr/bin/env bash
    docker run -ti --rm --entrypoint bash centos:7 -c "$*"
  '';

  docker-cerebro = pkgs.writeScriptBin "docker-cerebro " ''
    #!/usr/bin/env bash
    docker run -ti --rm -p 9000:9000 lmenezes/cerebro
  '';

  docker-mvn = pkgs.writeScriptBin "docker-mvn " ''
    #!/usr/bin/env bash
    docker run -v $HOME/.m2:/var/maven/.m2 \
    -v "$PWD":/var/maven/src -w /var/maven/src  \
    -ti --rm -u $(id -u) \
    -e MAVEN_CONFIG=/var/maven/.m2 \
    maven:$1 \
    mvn -Duser.home=/var/maven ''${*:2}
  '';

  docker-krb = pkgs.writeScriptBin "docker-krb " ''
    #!/usr/bin/env bash
    docker run -ti --rm -e KRB5_CONFIG=/etc/krb5.conf \
    -v ''$(pwd)/krb5.conf:/etc/krb5.conf \
    --entrypoint bash -w ''${PWD} \
    pilchard/krb5 -c "$*"
  '';

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

        home.packages = [
          docker-arch
          docker-centos
          docker-cerebro
          docker-mvn
          docker-krb
        ];
      };
    };
  }

