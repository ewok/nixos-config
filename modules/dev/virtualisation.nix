{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.dev.virtualisation;
  dev = config.modules.dev;
  username = config.properties.user.name;
  configHome = config.home-manager.users."${username}".xdg.configHome;

in
{
  options.modules.dev = {
    virtualisation = {
      enableVirtualbox = mkEnableOption "Enable Virtualbox.";
    };
  };

  config = mkIf (cfg.enableVirtualbox) {

    virtualisation.virtualbox = {
      host = {
        enable = true;
        enableExtensionPack = true;
      };
    };

    users.users.${username}.extraGroups = [ "vboxusers" ];

    home-manager.users."${username}" = {
    };
  };
}
