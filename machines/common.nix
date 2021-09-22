{ config, pkgs, lib, ... }:
let
  username = config.username;
in
{
  imports = [
    ../nixos
  ];

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
    binaryCaches = ["s3://store?endpoint=http://nas:9000"];
    # I am using local cache on NAS
    requireSignedBinaryCaches = false;
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      experimental-features = nix-command flakes ca-references
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

  users.defaultUserShell = pkgs.zsh;

  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [
    git
  ];

}
