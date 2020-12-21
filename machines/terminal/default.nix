{ config, inputs, lib, pkgs, ... }:
let
  properties = config.properties;
in
{
  imports = [
    ./secrets.nix
    ../common.nix
    ../../modules
    ./configuration.nix
  ];

  time.timeZone = properties.timezone;

  modules.dev = {
    enable = true;
    docker.enable = true;
    docker.autoPrune = true;
    k8s.enable = true;
  };

  modules.base.ssh.config = properties.ssh.config;
  modules.system.sudo.askPass = false;
  modules.system.sound.enable = false;
}
