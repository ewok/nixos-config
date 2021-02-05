{ config, lib, pkgs, ...  }:
with lib;
let
  base = config.modules.base;
  username = config.properties.user.name;
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
    ];

  };
}
