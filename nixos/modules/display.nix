{ config, lib, pkgs, ... }:
with lib;
let
  gui = config.nixos.gui;
  username = config.nixos.username;
  fonts = config.nixos.theme.fonts;
in
{
  options.nixos.gui.displayProfiles = mkOption {
    type = types.lines;
    default = "{}";
  };

  options.nixos.gui.displayHooks = mkOption {
    type = types.lines;
    default = "{}";
  };

  config = mkIf gui.enable {
    home-manager.users.${username} = {
      programs.autorandr = {
        enable = true;
        profiles = builtins.fromJSON gui.displayProfiles;
        hooks = builtins.fromJSON gui.displayHooks;
      };
    };

    services.xserver.dpi = fonts.dpi;

    services.udev.extraRules = ''
      ACTION=="change", SUBSYSTEM=="drm", RUN+="${pkgs.autorandr}/bin/autorandr --batch --change"
    '';
  };
}
