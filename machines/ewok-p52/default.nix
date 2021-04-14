{ config, inputs, lib, pkgs, ... }:
let
  properties = config.properties;
in
{
  imports = [
    ./secrets.nix
    ../common.nix
    ../secrets.nix
    ../../modules
    ./configuration.nix
    "${inputs.nixos-hardware}/common/pc/ssd"
    # "${inputs.nixos-hardware}/lenovo/thinkpad/p53"
  ];

  # services.xserver.libinput.naturalScrolling = true;
  # services.xserver.libinput.middleEmulation = true;
  # services.xserver.libinput.tapping = true;
  services.xserver.libinput.enable = true;

  time.timeZone = properties.timezone;

  # Enabled by default
  modules.base.enable = true;

  modules.backup = {
    enable = true;
    rslsync.enable = true;
    restic = {
      repo = properties.backup.repo;
      excludePaths = properties.backup.excludePaths;
      pass = properties.backup.backupPass;
    };
  };

  modules.dev = {
    enable = true;
    docker.enable = true;
    docker.autoPrune = true;
    k8s.enable = true;
    java.enable = true;
  };

  modules.gui = {
    enable = true;
    fonts = {
      dpi = 102;
    };
    displayProfiles = properties.displayProfiles;
    longitude = properties.longitude;
    latitude = properties.latitude;
    day = 5000;
    night = 3500;

    office.enable = true;
  };

  modules.base.ssh.config = properties.ssh.config;

  # modules.system.sudo.askPass = false;

  modules.system.sound.enable = true;
  modules.system.sound.pulse.enable = true;
  modules.system.printing.enable = true;

  modules.communication = {
    enable = true;
    enableTwitter = true;
    enableElement = true;
    enableSignal = true;
    enableSkype = false;
    enableSlack = true;
    enableTelegram = true;
    enableZoom = true;
  };
  modules.system.powermanagement.enable = true;

  modules.mail.enable = true;
  modules.gaming.enable = true;
}
