{ config, lib, pkgs, ... }:
let
  inherit (config) colors theme exchange_api_key openai_token fullName email workEmail authorizedKeys ssh_config;
  username = "deck";
  homeDirectory = "/home/${username}";
in
{
  config = {

    opt =
      {
        nvim = {
          enable = true;
          inherit colors theme openai_token;
        };
        vifm.enable = true;
        fish = {
          enable = true;
          homeDirectory = homeDirectory;
          inherit openai_token;
        };
        starship.enable = true;
        git = {
          enable = true;
          homePath = "${homeDirectory}/";
          workPath = "${homeDirectory}/work/";
          homeEmail = email;
          inherit fullName workEmail;
        };
        hledger = {
          enable = true;
          inherit exchange_api_key;
        };
        svn.enable = true;
        ssh = {
          inherit authorizedKeys;
          config = ssh_config;
          enable = true;
        };
        nix.enable = true;
        lisps.enable = true;
        terminal = {
          enable = true;
          inherit colors theme;
          steamdeck = true;
          tmux = {
            enable = true;
          };
        };
        wm = {
          enable = true;
          steamos = true;
          inherit colors theme;
        };
        direnv.enable = true;
        openvpn.enable = true;
        scripts.enable = true;
      };

    home.username = username;
    home.homeDirectory = homeDirectory;
    home.stateVersion = "23.11";

    nix.package = pkgs.nix;
  };
}
