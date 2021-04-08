{ config, lib, pkgs, ... }:
with lib;
let
  gui = config.modules.gui;
  cfg = config.modules.gui.fonts;
  username = config.properties.user.name;
in
{
  options.modules.gui.fonts = {
    dpi = mkOption {
      type = types.int;
      default = 115;
      description = "Font DPI.";
    };
    monospaceFont = mkOption {
      type = types.listOf types.str;
      default = [ "FiraCode Nerd Font Mono" ];
      description = "Default monospace font.";
    };
    monospaceFontSize = mkOption {
      type = types.int;
      default = 13;
      description = "Default monospace font size.";
    };
    consoleFont = mkOption {
      type = types.str;
      default = "Lat2-Terminus16";
      description = "Default console font.";
    };
  };

  config = mkIf gui.enable {

    fonts = {
      fontconfig = {
        enable = true;
        antialias = true;
        dpi = cfg.dpi;
        defaultFonts.monospace = cfg.monospaceFont;
      };

      fontDir.enable = true;
      enableGhostscriptFonts = true;
      enableDefaultFonts = true;

      fonts = with pkgs; [ nerdfonts ];
    };

    console = {
      font = cfg.consoleFont;
      useXkbConfig = true;
    };

    home-manager.users.${username} = {

      xresources.properties = {
        "Xft.antialias" = true;
        "Xft.autohint" = false;
        "Xft.dpi" = "${toString cfg.dpi}";
        "Xft.hinting" = true;
        "Xft.hintstyle" = "hintmedium";
      };
    };
  };
}
