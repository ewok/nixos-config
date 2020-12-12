{ config, inputs, lib, pkgs, ... }:
{
  imports = [
    ./secrets.nix
    ../common.nix
    ../../modules
    ./configuration.nix
  ];

  properties.timezone = "Europe/Moscow";
  time.timeZone = "Europe/Moscow";

  # Enabled by default
  # modules.base.enable = true;

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
