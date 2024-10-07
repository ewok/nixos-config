{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.opt.syncthing;
in
{
  options.opt.syncthing = {
    enable = mkEnableOption "syncthing";
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      syncthing
    ];

    services.syncthing.enable = true;
  };
}
