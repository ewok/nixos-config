{ config, lib, pkgs, ... }:
with lib;
let
  gui = config.modules.gui;
  comm = config.modules.communication;
  username = config.properties.user.name;
in
{
  config = mkIf (gui.enable && comm.enable && comm.enableTelegram) {
    home-manager.users.${username} = {
      home.packages = with pkgs; [
        tdesktop
      ];

      xdg.mimeApps.defaultApplications = lib.genAttrs [
        "x-scheme-handler/tg"
      ] (_: [ "telegramdesktop.desktop" ]);
    };
  };
}
