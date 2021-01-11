{ config, lib, inputs, ... }:
with lib;
let
  gui = config.modules.gui;
  username = config.properties.user.name;
  master = import inputs.master ({
    config = config.nixpkgs.config;
    localSystem = { system = "x86_64-linux"; };
  });
in
  {
    config = mkIf gui.enable {
      home-manager.users.${username} = {
        home.packages = with master; [
          enpass
        ];
      };
    };
  }

