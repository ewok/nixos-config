{ config, lib, pkgs, ... }:
with lib;
let
  dev = config.home.dev;
in
{
  config = mkIf (dev.enable && dev.emacs.enable) {
    home.packages = [ pkgs.emacs ];

    services.emacs = {
      enable = true;
      package = pkgs.emacs;
      client.enable = true;
    };

    xdg.configFile."emacs/init.el".source = ./config/emacs/init.el;
    xdg.configFile."emacs/emacs.org".source = ./config/emacs/emacs.org;
  };
}
