{ config, lib, pkgs, ... }:
with lib;
let
  gui = config.modules.gui;
  nm = config.networking.networkmanager;
  username = config.properties.user.name;
in
{
  config = mkIf (gui.enable && nm.enable) {
    programs.nm-applet.enable = true;
  };
}

