{ config, lib, pkgs, ... }:
with lib;
let
  dev = config.modules.dev;
  username = config.properties.user.name;
in
{
  options.modules.dev = {
    emacs = {
      enable= mkEnableOption "Enable emacs in dev environment.";
    };
  };
  config = mkIf (dev.enable && dev.emacs.enable) {
    home-manager.users."${username}" = {
      home.packages = [ pkgs.emacs ];

      services.emacs = {
        enable = true;
        package = pkgs.emacs;
        client.enable = true;
      };

      xdg.configFile."emacs/init.el".source = ./emacs/init.el;
      xdg.configFile."emacs/emacs.org".source = ./emacs/emacs.org;
    };
  };
}
