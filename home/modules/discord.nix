{ config, lib, pkgs, ... }:
with lib;
let
  gui = config.home.gui;
  comm = config.home.communication;
  username = config.home.username;
in
{
  config = mkIf (gui.enable && comm.enableDiscord) {
    home.packages = with pkgs; [
      discord
    ];
  };
}
