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
    };
  };
}

