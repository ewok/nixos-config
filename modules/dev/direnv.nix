{ config, lib, pkgs, inputs, ... }:
with lib;
let
  dev = config.modules.dev;
  username = config.properties.user.name;
  nix-direnv = import inputs.nix-direnv;
in
{
  config = mkIf dev.enable {

    home-manager.users."${username}" = {
      programs.direnv.enable = true;
      programs.direnv.enableNixDirenvIntegration = true;
    };
  };
}
