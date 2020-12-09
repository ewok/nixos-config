{ config, pkgs, ... }:
let
  username = config.properties.user.name;
  secrets = config.secrets;
in
{
  nixpkgs.config = {
    allowUnfree = true;
    allowedUsers = [ "@wheel" ];
    trustedUsers = [ "@wheel" ];
  };

  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
    experimental-features = nix-command flakes
  '';

  nix = {
    package = pkgs.nixFlakes;
  };

  home-manager = {
    useGlobalPkgs = true;
  };

  properties.user = {
    name = secrets.name;
    email = secrets.email;
    fullName = secrets.fullName;
  };

  properties.device = {
    name = secrets.deviceName;
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
