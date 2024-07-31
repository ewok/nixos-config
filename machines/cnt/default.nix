{ config, pkgs, ... }:
let
  inherit (config) username colors theme exchange_api_key openai_token fullName email workEmail authorizedKeys ssh_config;

  homeDirectory = "/home/${username}";
in
{
  config = {

    opt =
      {
        nvim = {
          enable = true;
          inherit colors theme openai_token;
          remote = true;
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
        lisps.enable = false;
        terminal = {
          enable = true;
          inherit colors theme;
          tmux = {
            enable = true;
          };
        };
        direnv.enable = true;
        scripts.enable = true;
      };

    home.username = username;
    home.homeDirectory = homeDirectory;
    home.stateVersion = "23.11";

    nix.package = pkgs.nix;
  };
}
