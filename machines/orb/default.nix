{ config, pkgs, ... }:
let
  inherit (config) colors theme username exchange_api_key openai_token context7_api_key fullName email workEmail authorizedKeys;
  inherit (pkgs) writeShellScriptBin;

  homeDirectory = "/home/${username}";
  modules = map (n: ../../modules/hm + "/${n}") (builtins.attrNames (builtins.readDir ../../modules/hm));
in
{
  imports = [
    ./secrets.nix
    /etc/nixos/configuration.nix
  ];

  config = {

    nix.settings.trusted-users = [ "root" username ];

    services.tailscale.enable = true;

    # Enable nix-ld to allow standard programs to be executed
    programs.nix-ld.enable = true;
    programs.nix-ld.libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
    ];

    i18n.supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "ru_RU.UTF-8/UTF-8"
    ];

    users.users."${username}" = {
      name = "${username}";
      home = homeDirectory;
      isSystemUser = true;
      group = "users";
      createHome = true;
      homeMode = "700";
      useDefaultShell = true;
    };

    home-manager = {
      useGlobalPkgs = true;
      backupFileExtension = "backup";

      users."${username}" = {

        imports = modules;

        _module.args = {
          utils = import ../../utils/lib.nix { inherit pkgs; };
        };

        opt = {
          nvim = {
            enable = true;
            inherit colors theme;
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
            homePath = "/Users/${username}/";
            workPath = "/Users/${username}/work/";
            homeEmail = email;
            inherit fullName workEmail;
          };
          hledger.enable = true;
          hledger.exchange_api_key = exchange_api_key;
          svn.enable = true;
          ssh = {
            inherit authorizedKeys;
            enable = true;
            homeDirectory = homeDirectory;
          };
          kube.enable = true;
          tf.enable = true;
          nix.enable = true;
          languages.go.enable = true;
          languages.lisps.enable = true;
          terminal = {
            enable = true;
            inherit colors theme;
            tmux = {
              enable = true;
            };
          };
          direnv.enable = true;
          aws.enable = true;
          tailscale.enable = true;
          scripts.enable = true;
          syncthing = {
            enable = true;
          };
          rslsync = {
            enable = false;
            deviceName = "ewok-arch";
            httpListenAddr = "0.0.0.0";
            httpListenPort = 8888;
          };
          ai = {
            enable = true;
            inherit openai_token context7_api_key;
          };
        };

        home.username = "${username}";
        home.homeDirectory = homeDirectory;
        home.stateVersion = "23.11";

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
    };
  };
}
