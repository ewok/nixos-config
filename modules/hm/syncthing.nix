{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf mkOption types;

  cfg = config.opt.syncthing;

in
{
  options.opt.syncthing = {
    enable = mkEnableOption "syncthing";
    guiAddress = mkOption { type = types.str; default = "127.0.0.1:8384"; };
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      syncthing
    ];

    services.syncthing = {
      enable = true;
      guiAddress = cfg.guiAddress;
    };
  };
}
