{ config, pkgs, ... }:
let
  inherit (config) colors theme username exchange_api_key openai_token fullName email workEmail authorizedKeys;

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

    users.users."${username}" = {
      name = "${username}";
      home = homeDirectory;
      isNormalUser = true;
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
            openai_token = openai_token;
          };
          vifm.enable = true;
          fish.enable = true;
          fish.homeDirectory = homeDirectory;
          fish.openai_token = openai_token;
          starship.enable = true;
          git = {
            enable = true;
            homePath = "${homeDirectory}/";
            workPath = "${homeDirectory}/work/";
            homeEmail = email;
            inherit fullName workEmail;
          };
          hledger.enable = true;
          hledger.exchange_api_key = exchange_api_key;
          svn.enable = true;
          ssh = {
            inherit authorizedKeys;
            enable = true;
          };
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
          tailscale.enable = true;
        };

        home.username = "${username}";
        home.homeDirectory = homeDirectory;
        home.stateVersion = "23.11";
      };
    };
  };
}
