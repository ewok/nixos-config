{ config, lib, ... }:
with lib;
{
  imports = map (n: ./modules + "/${n}") (builtins.attrNames (builtins.readDir ./modules));

  options.nixos = {

    username = mkOption {
      type = types.str;
    };

    docker = {
      enable = mkEnableOption "Enable docker";
      autoPrune = mkEnableOption "Enable weekly cleanup.";
    };

    ios.enable = mkEnableOption "Enable IOS related services.";
    gui.enable = mkEnableOption "Enable GUI.";
    dev.enable = mkEnableOption "Enable dev environment.";

    backup = {
      enable = mkOption {
        type = types.bool;
        description = "Enable backup soft and settings.";
        default = false;
      };
    };

    timezone = mkOption {
      description = "Timezone.";
      type = types.str;
    };

    deviceName = mkOption {
      description = "Device name.";
      type = types.str;
    };
  };
}
