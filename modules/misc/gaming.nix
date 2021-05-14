{ config, lib, pkgs, inputs, ... }:
with lib;
let
  gui = config.modules.gui;
  gaming = config.modules.gaming;
  username = config.properties.user.name;
  master = import inputs.master (
    {
      config = config.nixpkgs.config;
      localSystem = { system = "x86_64-linux"; };
    }
  );
in
{
  options.modules.gaming = {
    enable = mkEnableOption "Enable gaming soft.";
  };

  config = mkIf (gui.enable && gaming.enable) {
    home-manager.users.${username} = {
      home.packages = with master; [
        steam
      ];
    };
  };
}
