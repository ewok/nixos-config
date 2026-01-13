{ config, pkgs, ... }:
let
  inherit (config) colors theme exchange_api_key openai_token fullName email workEmail authorizedKeys ssh_config;

  username = "ataranchiev";
  homeDirectory = "/home/${username}";
  modulesHm = map (n: ../../modules/hm + "/${n}") (builtins.attrNames (builtins.readDir ../../modules/hm));
in
{
  imports = [
    # ./secrets.nix
    /etc/nixos/configuration.nix
  ];

  config = {
    nix.settings.trusted-users = [ "root" username ];
    services.tailscale.enable = true;
    services.cron.enable = true;
    virtualisation.docker.enable = true;

    # Enable nix-ld to allow standard programs to be executed
    programs.nix-ld.enable = true;
    programs.nix-ld.libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
    ];

    # Fix error not staring service
    systemd.services.NetworkManager-wait-online.enable = false;

    services.minecraft-bedrock-server = {
      enable = true;

      # see here for more info: https://minecraft.gamepedia.com/Server.properties#server.properties
      serverProperties = {
        server-ip = "100.95.245.70";
        motd = "My Minecraft server";
        max-players = 5;
        allow-cheats = true;
        level-seed = "12212985734";
      };
    };

    users.users."${username}" = {
      name = "${username}";
      home = homeDirectory;
      isNormalUser = true;
      extraGroups = [ "networkmanager" "wheel" "docker" ];
    };

    home-manager = {
      useGlobalPkgs = true;
      backupFileExtension = "backup";

      users."${username}" = {

        imports = modulesHm;

        _module.args = {
          utils = import ../../utils/lib.nix { inherit pkgs; };
        };

        opt = {
          nvim = {
            enable = true;
            inherit colors theme;
            remote = true;
          };
          vifm.enable = true;
          shell = {
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
            enable = false;
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
          languages.lisps.enable = true;
          terminal = {
            enable = true;
            inherit colors theme;
            tmux = {
              enable = true;
            };
          };
          direnv.enable = true;
          tailscale.enable = true;
          scripts.enable = true;
          syncthing = {
            enable = true;
            guiAddress = "100.95.245.70:8384";
          };
          seafile.enable = false;
        };

        home.username = "${username}";
        home.homeDirectory = homeDirectory;
        home.stateVersion = "25.05";
      };
    };
  };
}
