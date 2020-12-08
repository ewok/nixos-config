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

      # home-manager.users.${user} = {
        # programs.autorandr.hooks = {
        #   postswitch = { "rescale-wallpaper" = "${rescale-wallpaper}/bin/rescale-wallpaper"; };
        # };
        # programs.feh.enable = true;

        # xresources.properties = {
        #   "Xmessage*Buttons" = "Quit";
        #   "Xmessage*defaultButton" = "Quit";
        #   "Xmessage*international" = true;

        #   "urgentOnBell" = true;
        #   "visualBell" = true;

        #   "Xft.antialias" = true;
        #   "Xft.autohint" = false;
        #   "Xft.dpi" = "120";
        #   "Xft.hinting" = true;
        #   "Xft.hintstyle" = "hintmedium";
        # };
        # home.activation.xrdb = {
        #   after = [ "linkGeneration" ];
        #   before = [ ];
        #   data = "DISPLAY=:0 ${pkgs.xorg.xrdb}/bin/xrdb ${homePrefix ".Xresources"} || exit 0";
        # };

      # wmCommon.keys = [
      #   {
      #     key = [ "Shift" "r" ];
      #     cmd = "${pkgs.xorg.xrdb}/bin/xrdb $HOME/.Xresources";
      #     mode = "xserver";
      #   }
      #   {
      #     key = [ "w" ];
      #     cmd = "${rescale-wallpaper}/bin/rescale-wallpaper";
      #     mode = "xserver";
      #   }
      # ];
  };
}
