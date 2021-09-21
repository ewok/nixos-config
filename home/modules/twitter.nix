{ config, lib, pkgs, ... }:
with lib;
let
  gui = config.home.gui;
  comm = config.home.communication;
in
{
  config = mkIf (gui.enable && comm.enableTwitter) {
    home.packages = with pkgs; [
      cawbird
    ];
  };
}
