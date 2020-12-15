{ config, lib, pkgs, inputs, ... }:
with lib;
let
  gui = config.modules.gui;
  username = config.properties.user.name;
  stable = import inputs.stable ({
    config = config.nixpkgs.config;
    localSystem = { system = "x86_64-linux"; };
  });
in
{
  config = mkIf gui.enable {
    home-manager.users.${username} = {
      home.packages = with stable; [
        gparted
        mtools
        dosfstools
      ];
    };
  };
}
