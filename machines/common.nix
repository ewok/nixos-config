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
    autoOptimiseStore = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 10d";
    };
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
    createHome = false;
  };

  users.defaultUserShell = pkgs.fish;

  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [
    git
  ];

  properties.theme.colors = {
    background = "000000";
    foreground = "abb2bf";
    text = "282c34";
    cursor = "abb2bf";
    color0 = "282c34";
    color1 = "e06c75";
    color2 = "98c379";
    color3 = "e5c07b";
    color4 = "61afef";
    color5 = "c678dd";
    color6 = "56b6c2";
    color7 = "abb2bf";
    color8 = "545862";
    color9 = "d19a66";
    color10 = "353b45";
    color11 = "3e4451";
    color12 = "565c64";
    color13 = "b6bdca";
    color14 = "be5046";
    color15 = "c8ccd4";
  };

}
