{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.opt.virtualisation;
in
{

  options.opt.virtualisation = {
    enable = mkOption { type = types.bool; };
    username = mkOption { type = types.str; };
    docker = {
      enable = mkOption { type = types.bool; };
      autoPrune = mkOption { type = types.bool; };
    };
    virtualbox = {
      enable = mkOption { type = types.bool; };
    };
  };


  config = mkIf cfg.enable {
    virtualisation.docker = {
      enable = cfg.docker.enable;
      autoPrune = {
        enable = cfg.docker.autoPrune;
      };
    };
    users.users.${cfg.username}.extraGroups = [] ++
      optionals (cfg.docker.enable) ["docker"] ++
      optionals (cfg.virtualbox.enable) ["vboxusers"];

    virtualisation.virtualbox = {
      host = {
        enable = cfg.virtualbox.enable;
        enableExtensionPack = cfg.virtualbox.enable;
      };
    };
  };
}
