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
    "${inputs.nixos-hardware}/common/pc/ssd"
    "${inputs.nixos-hardware}/lenovo/thinkpad/p53"
  ];

  services.xserver.libinput.naturalScrolling = true;
  services.xserver.libinput.enable = true;

  time.timeZone = properties.timezone;

  # Enabled by default
  modules.base.enable = true;

  modules.backup.enable = true;
  modules.backup.rslsync.enable = true;
  modules.backup.restic = {
    repo = properties.backup.repo;
    excludePaths = properties.backup.excludePaths;
    pass = properties.backup.backupPass;
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
    displayProfiles = properties.displayProfiles;
    longitude = properties.longitude;
    latitude = properties.latitude;
  };

  modules.base.ssh.config = properties.ssh.config;

  modules.system.sudo.askPass = false;

  modules.system.sound.enable = true;
  modules.system.sound.pulse.enable = true;

  modules.communication.enable = true;
  modules.system.powermanagement.enable = true;
  modules.system.powermanagement.powertop.enable = true;

  modules.mail.enable = true;
  modules.mail.accounts = properties.email.accounts;
}
