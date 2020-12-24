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

      binutils
      pciutils
      openssl
      ntfs3g

      curl
      wget
      telnet
      netcat

      jq

      trash-cli

      git
      git-crypt
    ];

  };
}
