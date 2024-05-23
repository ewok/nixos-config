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

    nix.package = pkgs.nix;
  };
}
