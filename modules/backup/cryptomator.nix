{ config, lib, pkgs, inputs, ... }:
with lib;
let
  gui = config.modules.gui;
  backup = config.modules.backup;
  username = config.properties.user.name;
  master = import inputs.master (
    {
      config = config.nixpkgs.config;
      localSystem = { system = "x86_64-linux"; };
    }
  );
in
{
  config = mkIf gui.enable {
    home-manager.users.${username} = {
      home.packages = with master; [
        cryptomator
      ];
    };
  };
}
