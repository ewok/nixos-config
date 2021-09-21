{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.home.mail;
  gui = config.home.gui;
in
{
  config = mkIf (cfg.enable && cfg.mailspring.enable && gui.enable) {
    home.packages = [ pkgs.mailspring ];

    xdg.mimeApps.defaultApplications = lib.genAttrs [
      "x-scheme-handler/mailspring"
    ] (_: [ "mailspring.desktop" ]);
  };
}
