{ config, lib, pkgs, inputs, ... }:
with lib;
let
  cfg = config.modules.system.printing;
  username = config.properties.user.name;
  mypkgs = import inputs.my-nixpkgs ({
    config = config.nixpkgs.config;
    localSystem = { system = "x86_64-linux"; };
  });
in
  {
    options.modules.system.printing = {
      enable = mkEnableOption "Enable printing.";
    };

    config = mkIf cfg.enable {
      services.printing = {
        enable = true;
        drivers = with mypkgs; [ carps-cups ];
      };
      home-manager.users.${username} = {
        home.packages = with pkgs; [
          xsane
        ];
      };
    };
  }
