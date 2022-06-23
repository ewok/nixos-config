{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.opt.network;
in
{
  options.opt.network = {
      nm-applet.enable = mkOption { type = types.bool; };
  };

  config = mkMerge [
    (
      mkIf (cfg.nm-applet.enable) {
        services.network-manager-applet.enable = true;
      }
    )
  ];
}
