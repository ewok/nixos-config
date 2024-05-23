{ config, pkgs, ... }:
let
  inherit (config) colors theme username;
  homeDirectory = "/Users/${username}";
  modules = map (n: ../../modules + "/${n}") (builtins.attrNames (builtins.readDir ../../modules));
in
{
  imports = [
    ./secrets.nix
  ];

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
            nvim = {
              enable = true;
              inherit colors theme;
            };
            fish = {
              enable = true;
              darwin = true;
              homeDirectory = homeDirectory;
            };

            vifm.enable = true;
            starship.enable = true;
            git.enable = true;
            kube.enable = true;
            tf.enable = true;
            bw.enable = true;
            nix.enable = true;
            wm.enable = true;
            direnv.enable = true;
            terminal = {
              enable = true;
              inherit colors theme;
              tmux = {
                enable = true;
                terminal = "xterm-256color";
                install = false;
              };
              zellij.enable = true;
            };
            scripts.enable = true;
            aws.enable = true;
          };


          home.username = "${username}";
          home.stateVersion = "23.11";

          programs.fish = {
            enable = true;
          };

          xdg.configFile."fish/conf.d/99_yubikey-agent.fish".text = ''
            if status is-interactive
                export SSH_AUTH_SOCK="$(brew --prefix)/var/run/yubikey-agent.sock"
            end
          '';

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
