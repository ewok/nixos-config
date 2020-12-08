{ config, pkgs, ... }:
let
  deviceName = config.properties.device.name;
  username = config.properties.user.name;
in
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "${deviceName}";

  networking.networkmanager.enable = true;

  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";
  services.printing.enable = true;
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
  };

  users.users."${username}" = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  nixpkgs.config = {
    allowUnfree = true;
    allowedUsers = [ "@wheel" ];
    trustedUsers = [ "@wheel" ];
  };

  environment.systemPackages = with pkgs; [
     git
  ];

  powerManagement.enable = true;
  powerManagement.powertop.enable = true;
  services.tlp = {
    enable = true;
  };

  services.openssh.enable = true;

  users.defaultUserShell = pkgs.fish;

  environment.pathsToLink = [ "/libexec" ];

  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
    experimental-features = nix-command flakes
  '';

  nix = {
    package = pkgs.nixFlakes;
  };

  system.stateVersion = "20.09"; # Did you read the comment?
}

