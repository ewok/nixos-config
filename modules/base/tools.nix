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
      binutils
      openssl
      ntfs3g
      dfc

      curl
      wget

      jq

      telnet
      netcat

      reptyr

      trash-cli

      git
      git-crypt
    ];

  };
}
