{ config, lib, pkgs, ... }:
with lib;
let
  gui = config.home.gui;
  comm = config.home.communication;
in
{
  config = mkIf (gui.enable && comm.enableTelegram) {
    home.packages = with pkgs; [
      tdesktop
    ];

    xdg.mimeApps.defaultApplications = lib.genAttrs [
      "x-scheme-handler/tg"
    ] (_: [ "telegramdesktop.desktop" ]);
  };
}
