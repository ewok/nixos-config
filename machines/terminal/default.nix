{ config, inputs, lib, pkgs, ... }:
let
  secrets = config.secrets;
in
{
  nixpkgs.config.allowUnfree = true;

  imports = [
    ./secrets.nix
    ../../modules
    ./configuration.nix
  ];

  home-manager = {
    useGlobalPkgs = true;
  };

  properties.user = {
    name = secrets.name;
    email = secrets.email;
  };

  properties.device = {
    name = secrets.deviceName;
  };

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

  modules.base.ssh.config = secrets.ssh.config;
  modules.system.sudo.askPass = false;
}
