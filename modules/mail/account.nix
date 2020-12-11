{ config, lib, pkgs, ... }:
with lib;
let
  mail = config.modules.mail;
  username = config.properties.user.name;
in
{
  config = mkIf mail.enable {

    home-manager.users."${username}" = {
      # TODO: Email accounts
      # home.packages = with pkgs; [
      # ];
    };
  };
}

