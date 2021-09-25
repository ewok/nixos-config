{ config, lib, pkgs, ... }:
with lib;
let
  gui = config.nixos.gui;
  username = config.nixos.username;
in
{
  config = mkIf gui.enable {
    services.xserver = {
      enable = true;
      windowManager = {
        i3 = {
          enable = true;
          package = pkgs.i3-gaps;
        };
      };

      displayManager = {
        autoLogin = { enable = true; user = "${username}"; };
        defaultSession = "none+i3";
        sessionCommands = ''
          setxkbmap -rules "evdev" -model "pc105" -layout "us,ru" -option "ctrl:swapcaps"
        '';
      };
    };

    environment.sessionVariables.CURRENT_WM = [ "i3" ];

    # Themes
    environment.variables = {
      GTK_THEME = "Adwaita:dark";
    };
    environment.systemPackages = with pkgs; [
      plymouth
    ];

    qt5 = {
      enable = true;
      platformTheme = "gnome";
      style = "adwaita-dark";
    };

    programs.dconf.enable = true;
    # services.dbus.packages = [ pkgs.gnome.dconf ];

  };
}
