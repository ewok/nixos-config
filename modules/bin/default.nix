{ config, lib, pkgs, ... }:
with lib;
let
  username = config.properties.user.name;
in
{
  home-manager.users."${username}" = {
    home.sessionVariables = {
      PATH = "$HOME/bin:$PATH";
    };
  };
}

