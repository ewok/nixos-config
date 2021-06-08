{ config, lib, pkgs, ... }:
with lib;
let
  base = config.modules.base;
  username = config.properties.user.name;

  showcolors = pkgs.writeShellScriptBin "showcolors" "${readFile ./config/showcolors.sh}";
in
{
  config = mkIf base.enable {

    environment.systemPackages = with pkgs; [
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

      exa
      bat

      curl
      wget
      telnet
      netcat

      jq

      trash-cli

      git
      git-crypt

      zip
      unzip

      nix-tree

      showcolors
    ];

  };
}
