{ config, inputs, lib, pkgs, ... }:
let
  secrets = config.secrets;
in
{
  imports = [
    ./secrets.nix
    ../common.nix
    ../../modules
    ./configuration.nix
    "${inputs.nixos-hardware}/common/pc/ssd"
    "${inputs.nixos-hardware}/lenovo/thinkpad/p53"
  ];

  properties.timezone = "Europe/Moscow";
  time.timeZone = "Europe/Moscow";

  # Enabled by default
  modules.base.enable = true;

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

  modules.system.sound.enable = true;
  modules.system.sound.pulse.enable = true;
}
