{ config, lib, pkgs, ... }:
with lib;
let
  gui = config.modules.gui;
  username = config.properties.user.name;
in
{
  config = mkIf gui.enable {

    # wmCommon.autostart.entries = lib.optionals (cfg.statusbarImpl == "i3-rs") [ "kbdd" ];

    services.xserver = {
      enable = true;
      windowManager = {
        i3 = {
          enable = true;
        };
      };
      displayManager = { defaultSession = "none+i3"; };
    };
    environment.sessionVariables.CURRENT_WM = [ "i3" ];

    services.dbus.packages = [ pkgs.gnome3.dconf ];

    home-manager.users.${username} = {

      home.packages = with pkgs; [
        i3status-rust
        xdotool
        xorg.xwininfo
      ];

      xdg.configFile."i3/config".source = ./config/config;
      xdg.configFile."i3/mc-win-center.sh".source = ./config/mc-win-center.sh;

      xdg.configFile."i3/blurlock" = {
        source = ./config/blurlock;
        executable = true;
      };

      xdg.configFile."i3/i3exit" = {
        source = ./config/i3exit;
        executable = true;
      };

      xdg.configFile."i3status-rust/config.toml".source = ./config/i3status;

      gtk = {
        enable = true;
        font = {
          name = "Noto Sans 10";
        };
        iconTheme = {
          name = "Papirus";
          package = pkgs.papirus-icon-theme;
        };
        theme = {
          name = "Adapta";
          package = pkgs.adapta-gtk-theme;
        };
        gtk3.extraConfig = {
          gtk-application-prefer-dark-theme = true;
        };
      };
    };
  };
}
