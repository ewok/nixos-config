{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.nixos.system.printing;
  username = config.nixos.username;
in
{
  options.nixos.system.printing = {
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
