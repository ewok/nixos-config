{ config, lib, pkgs, ... }:
with lib;
{
  config = {
    environment.loginShellInit = ''
      if [ -e $HOME/.profile ]
      then
        . $HOME/.profile
      fi
    '';
    environment.pathsToLink = [ "/share/zsh" ];
  };
}
