{ config, pkgs, ... }:
let
  inherit (config) colors theme username workEmail fullName authorizedKeys email ssh_config;
  homeDirectory = "/Users/${username}";
  modules = map (n: ../../modules + "/${n}") (builtins.attrNames (builtins.readDir ../../modules));
in
{
  config = {
    services.nix-daemon.enable = true;

    users.users."${username}" = {
      name = "${username}";
      home = homeDirectory;
    };

    home-manager =
      {
        useGlobalPkgs = true;
        backupFileExtension = "backup";

        users."${username}" = {

          imports = modules;

          _module.args = {
            utils = import ../../utils/lib.nix { inherit pkgs; };
          };

          opt = {
            fish = {
              enable = true;
              darwin = true;
              homeDirectory = homeDirectory;
            };
            git = {
              enable = true;
              homePath = "${homeDirectory}/";
              workPath = "${homeDirectory}/work/";
              homeEmail = email;
              inherit fullName workEmail;
            };
            ssh = {
              inherit authorizedKeys;
              config = ssh_config;
              enable = true;
            };
            nix.enable = true;
            wm.enable = true;
            terminal = {
              enable = true;
              inherit colors theme;
              tmux = {
                enable = false;
                terminal = "xterm-256color";
                install = false;
              };
            };
          };

          home.username = "${username}";
          home.stateVersion = "23.11";

          programs.fish = {
            enable = true;
          };

          # xdg.configFile."fish/conf.d/99_yubikey-agent.fish".text = ''
          #   if status is-interactive
          #       export SSH_AUTH_SOCK="$(brew --prefix)/var/run/yubikey-agent.sock"
          #   end
          # '';

          xdg.configFile."bash/profile.d/01_fix_mac_paths.sh".text = ''
            export PATH="/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:$PATH"
            export PATH="/opt/homebrew/sbin:/opt/homebrew/bin:$PATH"

            export FZF_LEGACY_KEYBINDINGS=0
            export OPEN_CMD=open
          '';
        };
      };
  };
}
