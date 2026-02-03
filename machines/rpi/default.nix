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
          inherit colors;
          theme = {
            inherit (theme) common nvim;
          };
          remote = true;
        };
        vifm.enable = true;
        fish = {
          enable = true;
          homeDirectory = homeDirectory;
        };
        starship.enable = true;
        starship.colors = colors;
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
          homeDirectory = homeDirectory;
        };
        nix.enable = true;
        lisps.enable = false;
        terminal = {
          enable = true;
          inherit colors;
          theme = {
            inherit (theme) common wezterm ghostty;
          };
          tmux = {
            enable = true;
          };
        };
        direnv.enable = true;
        scripts.enable = true;
        syncthing.enable = true;
      };

    home.username = username;
    home.homeDirectory = homeDirectory;
    home.stateVersion = "23.11";

    nix.package = pkgs.nix;
  };
}
