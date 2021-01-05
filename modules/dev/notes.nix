{ config, lib, pkgs, inputs, ... }:
with lib;
let
  dev = config.modules.dev;
  gui = config.modules.gui;
  username = config.properties.user.name;
  mypkgs = import inputs.my-nixpkgs ({
    config = config.nixpkgs.config;
    localSystem = { system = "x86_64-linux"; };
  });
in
{
  config = mkIf (dev.enable && gui.enable) {
    home-manager.users."${username}" = {
      home.packages = [ mypkgs.sparkleshare pkgs.git-lfs ];
    };
  };
}

