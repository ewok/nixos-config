{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.opt.nix;
in
{
  options.opt.nix.enable = mkOption {type = types.bool;};
  options.opt.nix.username = mkOption {type = types.str;};

  config = mkIf cfg.enable {
    home-manager.users.${cfg.username} = {
      programs.nix-index = {
        enable = true;
        enableFishIntegration = true;
      };
    };
  };
}
