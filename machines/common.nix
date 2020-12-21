{ config, pkgs, lib, ... }:
let
  username = config.properties.user.name;
in
{
  nixpkgs.config = {
    allowUnfree = true;
    allowedUsers = [ "@wheel" ];
    trustedUsers = [ "@wheel" ];
  };

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      experimental-features = nix-command flakes
    '';
  };

  home-manager = {
    useGlobalPkgs = true;
  };

  environment.pathsToLink = [ "/libexec" ];

  users.users."${username}" = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  users.defaultUserShell = pkgs.fish;

  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [
    git
  ];
}
