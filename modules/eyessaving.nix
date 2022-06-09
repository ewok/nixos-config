{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.opt.eyessaving;
in
{
  options.opt.eyessaving = {
    enable = mkOption { type = types.bool; };
    username = mkOption { type = types.str; };
    latitude = mkOption { type = types.str; };
    longitude = mkOption { type = types.str; };
    day = mkOption { type = types.int; };
    night = mkOption { type = types.int; };
  };

  config = mkIf cfg.enable {

    home-manager.users.${cfg.username} = {
      # services.geoclue2 = {
      #   enable = true;
      # };

      services.redshift = {
        enable = cfg.enable;
        latitude = cfg.latitude;
        longitude = cfg.longitude;
        tray = true;
        temperature = {
          day = cfg.day;
          night = cfg.night;
        };
      };
    };
  };
}
