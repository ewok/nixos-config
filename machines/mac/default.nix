{ config, pkgs, ... }:
let
  inherit (config) colors theme username workEmail fullName authorizedKeys email ssh_config openai_token;

  homeDirectory = "/Users/${username}";
  modules = map (n: ../../modules/hm + "/${n}") (builtins.attrNames (builtins.readDir ../../modules/hm));
in
{
  imports = [
    ./secrets.nix
  ];
  config = {
    # services.nix-daemon.enable = true;

    users.users."${username}" = {
      name = "${username}";
      home = homeDirectory;
    };

    nix.enable = false;
    system.stateVersion = 6;
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
              orb = true;
              openai_token = openai_token;
            };
            vifm.enable = true;
            starship.enable = true;
            starship.colors = colors;
            svn.enable = false;
            shell = {
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
              enable = true;
              homeDirectory = homeDirectory;
            };
            kube.enable = false;
            tf.enable = false;
            lisps.enable = false;
            nix.enable = true;
            wm.enable = true;
            wm.homePath = homeDirectory;
            direnv.enable = true;
            aws.enable = false;
            scripts.enable = false;
            terminal = {
              enable = true;
              inherit colors theme;
              terminal = "ghostty";
              tmux = {
                enable = true;
                terminal = "xterm-256color";
                install = false;
              };
            };
          };

          home.username = "${username}";
          home.stateVersion = "24.05";

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
