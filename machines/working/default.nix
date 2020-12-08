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
    "${inputs.nixos-hardware}/common/pc/ssd"
    "${inputs.nixos-hardware}/lenovo/thinkpad/p53"
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

  modules.backup.enable = true;
  modules.backup.rslsync.enable = true;
  modules.backup.restic = {
    repo = secrets.repo;
    excludePaths = secrets.excludePaths;
    pass = secrets.backupPass;
  };

  modules.dev = {
    enable = true;
    docker.enable = true;
    docker.autoPrune = true;
    k8s.enable = true;
  };

  modules.gui = {
    enable = true;
    fonts = {
      dpi = 102;
    };
  };

  modules.base.ssh.config = secrets.ssh.config;

  # TODO: Change to true
  modules.system.sudo.askPass = false;
}
