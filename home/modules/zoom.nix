{ config, lib, pkgs, ... }:
with lib;
let
  gui = config.home.gui;
  comm = config.home.communication;
  username = config.home.user.name;
in
{
  config = mkIf (gui.enable && comm.enableZoom) {
    home.packages = with pkgs; [
      zoom-us
    ];
  };
}
