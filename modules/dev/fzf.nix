{ config, lib, pkgs, ... }:
with lib;
let
  dev = config.modules.dev;
  username = config.properties.user.name;
in
{
  config = mkIf dev.enable {

    home-manager.users."${username}" = {

      home.packages = with pkgs; [
        ripgrep
      ];

      programs.fzf = {
        enable = true;
        enableFishIntegration = true;
        defaultCommand = "rg --hidden --no-ignore --files";
      };
    };
  };
}
