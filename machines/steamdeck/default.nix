{ config, lib, pkgs, ... }:
let
  inherit (config) colors theme;
  homeDirectory = "/home/deck";
  #usrDirectory = "/data/data/com.termux.nix/files/usr";
in
{
  imports = [
    ./secrets.nix
  ];

  config = {

    #home-manager = {
      #useGlobalPkgs = true;
      #backupFileExtension = "backup";

    #  config = { lib, ... }: {

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
            terminal = {
              enable = true;
              inherit colors theme;
            };
          };

        home.username = "deck";
        home.homeDirectory = homeDirectory;
        home.stateVersion = "23.11";
    #  };
    #};
    nix.package = pkgs.nix;

    #environment.packages = with pkgs; [
    #  diffutils
    #  findutils
    #  utillinux
    #  tzdata
    #  hostname
    #  man
    #  gnugrep
    #  gnused
    #  openssh
    #  git
    #  which
    #];
  };
}
