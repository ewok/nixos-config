{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.nixos.docker;
  username = config.nixos.username;
in
{
  config = mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      autoPrune = {
        enable = cfg.autoPrune;
      };
    };
    users.users.${username}.extraGroups = [ "docker" ];
  };
}
