{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.opt.tailscale;
in
{
  options.opt.tailscale = {
    enable = mkEnableOption "tailscale";
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      tailscale
    ];
  };
}
