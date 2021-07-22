{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.system.printing;
  username = config.properties.user.name;
in
{
  options.modules.system.printing = {
    enable = mkEnableOption "Enable printing.";
  };

  config = mkIf cfg.enable {
    services.printing = {
      enable = true;
      drivers = with pkgs; [ carps-cups ];
    };
    home-manager.users.${username} = {
      home.packages = with pkgs; [
        xsane
      ];
    };
  };
}
