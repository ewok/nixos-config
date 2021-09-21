{ config, lib, pkgs, ... }:
with lib;
let
  showcolors = pkgs.writeShellScriptBin "showcolors" "${readFile ./config/showcolors.sh}";
in
{
  config = {

    home.packages = with pkgs; [
      tree
      dfc
      htop
      reptyr
      file

      binutils
      pciutils
      openssl
      ntfs3g
      usbutils
      gnumake

      exa
      bat
      fd

      curl
      wget
      telnet
      netcat

      jq

      trash-cli
      wipe

      git
      git-crypt

      zip
      unzip

      nix-tree

      showcolors
    ];

  };
}
