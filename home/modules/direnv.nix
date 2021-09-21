{ config, lib, ... }:
with lib;
let
  dev = config.home.dev;
in
{
  config = mkIf dev.enable {
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
      nix-direnv.enableFlakes = true;
    };
  };
}
