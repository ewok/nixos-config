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
    "${inputs.nixos-hardware}/lenovo/thinkpad/t14s"
  ];

  time.timeZone = properties.timezone;

  # Enabled by default
  modules.base.enable = true;

  modules.backup.enable = true;
  modules.backup.rslsync = {
    enable = true;
    enableWebUI = true;
    httpListenAddr = "127.0.0.1";
    httpListenPort = 8888;
  };
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
    virtualisation.enableVirtualbox = true;
    terraform.enable = true;
    aws.enable = true;
    emacs.enable = true;
  };

  environment.variables = {
    GDK_SCALE = "1.1";
    GDK_DPI_SCALE = "1.1";
    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=1.1";
  };

  services.xserver.dpi = 115;

  modules.gui = {
    enable = true;
    fonts = {
      dpi = 115;
    };
    displayProfiles = properties.displayProfiles;
    longitude = properties.longitude;
    latitude = properties.latitude;
    day = 5000;
    night = 3500;

    office.enable = true;
  };

  modules.base.ssh.config = properties.ssh.config;

  modules.system.sound.enable = true;
  modules.system.sound.pulse.enable = true;
  modules.system.printing.enable = true;

  modules.communication = {
    enable = true;
    enableTwitter = false;
    enableElement = false;
    enableSignal = false;
    enableSkype = false;
    enableSlack = true;
    enableTelegram = true;
    enableZoom = true;
    enableDiscord = false;
  };

  modules.system.powermanagement = {
    enable = true;
    powertop.enable = true;
    governor = "powersave";
    suspendHibernate.enable = true;
  };

  modules.mail = {
    enable = true;
    thunderbird.enable = true;
  };
}
