{ config, lib, pkgs, ... }:
with lib;
let
  gui = config.modules.gui;
  username = config.properties.user.name;
in
{
  options.modules.gui.displayProfiles = mkOption {
    type = types.lines;
    default = "{}";
  };

  options.modules.gui.displayHooks = mkOption {
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

    services.xserver.dpi = gui.fonts.dpi;

    services.udev.extraRules = ''
      ACTION=="change", SUBSYSTEM=="drm", RUN+="${pkgs.autorandr}/bin/autorandr --batch --change"
    '';
  };
}
