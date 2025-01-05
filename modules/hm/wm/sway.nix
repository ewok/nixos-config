{ config, lib, utils, ... }:
let
  inherit (lib) mkIf;

  cfg = config.opt.wm;
  vars = {
    conf.colors = cfg.colors;
    conf.theme = cfg.theme;
    conf.terminal = cfg.terminal;
    conf.folders.bin = "/home/deck/bin";
    conf.wallpaper = cfg.wallpaper;
  };

in
{
  config = mkIf (cfg.enable && cfg.sway)
    {
      home.file."bin/swayexit" = {
        source = ./config/sway/swayexit;
        executable = true;
      };
      xdg.configFile."sway/config" = {
        source = utils.templateFile "config" ./config/sway/config vars;
        executable = true;
      };
      xdg.configFile."waybar/style.css" = {
        source = utils.templateFile "style.css" ./config/sway/style.css vars;
      };
      # xdg.configFile."sway/config.d/80-custom.conf".text = ''
      #   for_window [title="Picture in picture"] floating enable, sticky enable
      #   for_window [title="Picture-in-Picture"] floating enable, sticky enable
      # '';
      xdg.configFile."bash/profile.d/90_sway.sh".text = ''
        case ":$PATH:" in
            *":/var/lib/flatpak/exports/bin:"*) ;;
            *) export PATH=/var/lib/flatpak/exports/bin:$PATH ;;
        esac
      '';
    };
}
