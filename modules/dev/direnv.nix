{ config, lib, pkgs, inputs, ... }:
with lib;
let
  dev = config.modules.dev;
  username = config.properties.user.name;
in
{
  config = mkIf dev.enable {

    home-manager.users."${username}" = {
      programs.direnv = {
        enable = true;
        enableZshIntegration = true;
        # nix-direnv.enable = true;
        # nix-direnv.enableFlakes = true;
      };
    };
  };
}
