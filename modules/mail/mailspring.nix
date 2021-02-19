{ config, lib, pkgs, ... }:
with lib;
let
  mailspring = config.modules.mail.mailspring;
  gui = config.modules.gui;
  username = config.properties.user.name;
in
  {
    config = mkIf ( mailspring.enable && gui.enable ) {
      home-manager.users."${username}" = {
        home.packages = [ pkgs.mailspring ];

        xdg.mimeApps.defaultApplications = lib.genAttrs [
          "x-scheme-handler/mailspring"
        ] (_: [ "mailspring.desktop" ]);

      };
    };
  }

