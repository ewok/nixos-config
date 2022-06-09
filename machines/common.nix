{ config, pkgs, lib, ... }:
let
  username = config.username;
in
{
  imports = map (n: ../modules + "/${n}") (builtins.attrNames (builtins.readDir ../modules));

  nixpkgs.config = {
    allowUnfree = true;
    allowedUsers = [ "@wheel" ];
    trustedUsers = [ "@wheel" ];
  };

  nix = {
    package = pkgs.nixFlakes;
    autoOptimiseStore = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 10d";
    };
    # binaryCaches = ["s3://store?endpoint=http://nas:9000"];
    # I am using local cache on NAS
    # requireSignedBinaryCaches = false;
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      experimental-features = nix-command flakes
    '';
  };

  home-manager = {
    useGlobalPkgs = true;
    backupFileExtension = "backup";
  };

  environment.pathsToLink = [ "/libexec" ];

  users.users."${username}" = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    createHome = false;
  };

  users.defaultUserShell = pkgs.fish;

  services.openssh.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  services.xserver.libinput.enable = true;
  services.xserver.libinput.touchpad.naturalScrolling = true;

  environment.systemPackages = with pkgs; [
    git
  ];

}
