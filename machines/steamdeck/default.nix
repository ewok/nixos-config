{ config, lib, pkgs, ... }:
let
  inherit (config) colors theme;
  homeDirectory = "/home/deck";
in
{
  imports = [
    ./secrets.nix
  ];

  config = {

    # useGlobalPkgs = true;
    # backupFileExtension = "backup";

    opt =
      {
        nvim = {
          enable = true;
          inherit colors theme;
        };
        tmux = {
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
        #kube.enable = false;
        #bw.enable = false;
        nix.enable = true;
        lisps.enable = true;
        # terminal = {
        #   enable = true;
        #   inherit colors theme;
        # };
        wm = {
          enable = true;
          steamos = true;
          inherit colors theme;
          terminal = "wezterm";
        };
        direnv.enable = true;
        openvpn.enable = true;
      };

    home.username = "deck";
    home.homeDirectory = homeDirectory;
    home.stateVersion = "23.11";

    nix.package = pkgs.nix;
  };
}
