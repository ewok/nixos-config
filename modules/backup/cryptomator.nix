{ config, lib, pkgs, inputs, ... }:
with lib;
let
  gui = config.modules.gui;
  backup = config.modules.backup;
  username = config.properties.user.name;
  mypkgs = import inputs.my-nixpkgs ({
    config = config.nixpkgs.config;
    localSystem = { system = "x86_64-linux"; };
  });
in
{
  config = mkIf gui.enable {
    home-manager.users.${username} = {
      home.packages = with mypkgs; [
        cryptomator
      ];
    };
  };
}

