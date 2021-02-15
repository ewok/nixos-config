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
  ];

  # services.xserver.libinput.middleEmulation = true;
  # services.xserver.libinput.tapping = true;
  services.xserver.libinput.enable = true;
  services.xserver.libinput.touchpad.naturalScrolling = true;

  time.timeZone = properties.timezone;

  # Enabled by default
  modules.base.enable = true;

  modules.backup.enable = true;
  # modules.backup.rslsync.enable = true;
  modules.backup.restic = {
    repo = properties.backup.repo;
    excludePaths = properties.backup.excludePaths;
    pass = properties.backup.backupPass;
  };

  modules.dev = {
    enable = true;
    # docker.enable = true;
    # docker.autoPrune = true;
    # k8s.enable = true;
  };

  modules.gui = {
    enable = true;
    fonts = {
      dpi = 102;
    };
    displayProfiles = properties.displayProfiles;
    longitude = properties.longitude;
    latitude = properties.latitude;

    office.enable = true;
  };

  modules.base.ssh.config = properties.ssh.config;

  modules.system.sound.enable = true;
  modules.system.sound.pulse.enable = true;
  # modules.system.printing.enable = true;

  modules.communication.enable = true;
  modules.system.powermanagement = {
    enable = true;
    powertop.enable = true;
    governor = "powersave";
  };
}
