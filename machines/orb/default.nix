{ config, pkgs, ... }:
let
  inherit (config) colors theme openai_token context7_api_key fullName email workEmail authorizedKeys;
  inherit (pkgs) writeShellScriptBin;

  username = "a_taranchiev";
  homeDirectory = "/home/${username}";
in
{
  imports = [
    ./secrets.nix
  ];
  config = {

    nix.settings.trusted-users = [ "root" username ];

    opt =
      {
        ai = {
          enable = true;
          install_opencode = false;
          inherit openai_token context7_api_key;
        };
        nvim = {
          enable = true;
          inherit colors;
          theme = {
            inherit (theme) common nvim;
          };
          orb = true;
        };
        vifm.enable = true;
        shell = {
          enable = true;
          homeDirectory = homeDirectory;
          shell = "fish";
        };
        starship.enable = true;
        starship.colors = colors;
        git = {
          enable = true;
          homePath = "/Users/a.taranchiev/";
          workPath = "/Users/a.taranchiev/work/";
          homeEmail = email;
          inherit fullName workEmail;
        };
        svn.enable = true;
        ssh = {
          inherit authorizedKeys;
          # config = ssh_config;
          enable = true;
          homeDirectory = homeDirectory;
        };
        kube.enable = true;
        tf.enable = true;
        nix.enable = true;
        languages.go.enable = true;
        terminal = {
          enable = true;
          homeDirectory = homeDirectory;
          inherit colors;
          theme = {
            inherit (theme) common wezterm ghostty;
          };
          zellij = {
            enable = true;
          };
          # tmux = {
          #   enable = true;
          # };
        };
        direnv.enable = true;
        aws.enable = true;
        tailscale.enable = false;
        scripts.enable = true;
        syncthing = {
          enable = true;
        };
      };

    home.username = username;
    home.homeDirectory = homeDirectory;
    home.stateVersion = "23.11";

    nix.package = pkgs.nix;


    xdg.configFile."bash/profile.d/00_fix_orb_env.sh".text = ''
      export ORB=true
      export OPEN_CMD=open
      # Hack
      export WAYLAND_DISPLAY=wayland-1
    '';

    home.packages =
      let
        docker = writeShellScriptBin "docker" ''
          mac docker $@
        '';
        wl-copy-wrapper = pkgs.writeShellScriptBin "wl-copy" ''
            #!/usr/bin/env bash
            case "$1" in
              "-t")
                if [[ "$2" == "image/png" ]]; then
                  pbcopy
                else
                  pbcopy
                fi
                ;;
              *)
                pbcopy
                ;;
          esac
        '';
        wl-paste-wrapper = pkgs.writeShellScriptBin "wl-paste" ''
          #!/usr/bin/env bash
              case "$1" in
                "-t")
                  if [[ "$2" == "image/png" ]]; then
                    pbpaste
                  else
                    pbpaste
                  fi
                  ;;
                *)
                  pbpaste
                  ;;
              esac
        '';
      in
      [ docker wl-copy-wrapper wl-paste-wrapper ];

  };
}
