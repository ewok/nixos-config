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

  # OneDark
  properties.theme.colors = {
    background = "000000";
    foreground = "abb2bf";
    text       = "282c34";
    cursor     = "abb2bf";
    color0     = "282c34";
    color10    = "353b45";
    color11    = "3e4451";
    color8     = "545862";
    color12    = "565c64";
    color7     = "abb2bf";
    color13    = "b6bdca";
    color15    = "c8ccd4";
    color1     = "e06c75";
    color9     = "d19a66";
    color3     = "e5c07b";
    color2     = "98c379";
    color6     = "56b6c2";
    color4     = "61afef";
    color5     = "c678dd";
    color14    = "be5046";
  };

  # # Dracula
  # properties.theme.colors = {
  #   background = "000000";
  #   foreground = "e9e9f4";
  #   text       = "282936";
  #   cursor     = "e9e9f4";
  #   color0     = "282936";
  #   color10    = "3a3c4e";
  #   color11    = "4d4f68";
  #   color8     = "626483";
  #   color12    = "62d6e8";
  #   color7     = "e9e9f4";
  #   color13    = "f1f2f8";
  #   color15    = "f7f7fb";
  #   color1     = "ea51b2";
  #   color9     = "b45bcf";
  #   color3     = "00f769";
  #   color2     = "ebff87";
  #   color6     = "a1efe4";
  #   color4     = "62d6e8";
  #   color5     = "b45bcf";
  #   color14    = "00f769";
  # };

}
