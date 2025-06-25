{ config, pkgs, ... }:
let
  inherit (config) colors theme username exchange_api_key openai_token fullName email workEmail authorizedKeys;
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
    programs.nix-ld.libraries = [ ];

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
            openai_token = openai_token;
          };
          vifm.enable = true;
          shell = {
            enable = true;
            homeDirectory = homeDirectory;
            openai_token = openai_token;
            shell = "nu";
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
        };

        home.username = "${username}";
        home.homeDirectory = homeDirectory;
        home.stateVersion = "23.11";

        xdg.configFile."bash/profile.d/00_fix_orb_env.sh".text = ''
          export ORB=true
          export OPEN_CMD=open
        '';

        home.packages =
          let
            docker = writeShellScriptBin "docker" ''
              mac docker $@
            '';
          in
          [ docker ];

      };
    };
  };
}
