{ config, lib, pkgs, ... }:
with lib;
let
  gui = config.home.gui;
  comm = config.home.communication;
in
{
  config = mkIf (gui.enable && comm.enableSkype) {
    home.packages = with pkgs; [
      skype
    ];
  };
}
