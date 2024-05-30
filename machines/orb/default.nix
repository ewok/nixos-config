{ config, lib, pkgs, ... }:
let
  inherit (config) colors theme username;
  homeDirectory = "/home/${username}";
in
{
  imports = [
    ./secrets.nix
  ];

  config = {

    opt =
      {
        nvim = {
          enable = true;
          inherit colors theme;
          orb = true;
        };
        vifm.enable = true;
        fish.enable = true;
        fish.homeDirectory = homeDirectory;
        starship.enable = true;
        git.enable = true;
        hledger.enable = true;
        svn.enable = true;
        ssh.enable = true;
        kube.enable = true;
        tf.enable = true;
        nix.enable = true;
        lisps.enable = true;
        terminal = {
          enable = true;
          inherit colors theme;
          tmux = {
            enable = true;
          };
        };
        direnv.enable = true;
        aws.enable = true;
      };

    home.username = "${username}";
    home.homeDirectory = homeDirectory;
    home.stateVersion = "23.11";

    xdg.configFile."bash/profile.d/00_fix_orb_env.sh".text = ''
      export ORB=true
      export OPEN_CMD=open
    '';

    nix.package = pkgs.nix;
  };
}
