{ config, lib, pkgs, inputs, ... }:
with lib;
let
  dev = config.modules.dev;
  username = config.properties.user.name;
  master = import inputs.master (
    {
      config = config.nixpkgs.config;
      localSystem = { system = "x86_64-linux"; };
    }
  );
in
{
  options.modules.dev = {
    emacs = {
      enable= mkEnableOption "Enable emacs in dev environment.";
    };
  };
  config = mkIf (dev.enable && dev.emacs.enable) {
    home-manager.users."${username}" = {
      home.packages = [ master.emacs ];

      services.emacs = {
        enable = true;
        package = master.emacs;
        client.enable = true;
      };

      xdg.configFile."emacs/init.el".source = ./emacs/init.el;
      xdg.configFile."emacs/emacs.org".source = ./emacs/emacs.org;
    };
  };
}
