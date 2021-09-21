{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.home;
in
{
  config = mkIf cfg.gui.enable {

    # services.geoclue2 = {
    #   enable = true;
    # };

    services.redshift = {
      enable = true;
      latitude = cfg.latitude;
      longitude = cfg.longitude;
      tray = true;
      temperature = {
        day = cfg.day;
        night = cfg.night;
      };
    };
  };
}
