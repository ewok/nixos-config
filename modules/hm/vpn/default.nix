{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.opt.openvpn;
in
{
  options.opt = {
    openvpn = {
      enable = mkEnableOption "openvpn";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs;
      [
        openvpn
        rofi
      ];
    home.file."bin/vpn" = {
      source = ./config/vpn;
      executable = true;
    };
  };
}
