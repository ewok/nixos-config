{ config, pkgs, ... }:
let
  inherit (config) colors theme exchange_api_key openai_token context7_api_key fullName email workEmail authorizedKeys ssh_config;
  inherit (pkgs) writeShellScriptBin;

  username = "ataranchiev";
  homeDirectory = "/var/home/${username}";
  terminal = "ghostty";
in
{
  config = {

    nix.settings.trusted-users = [ "root" username ];

    opt =
      {
        nvim = {
          enable = true;
          inherit colors theme;
        };
        yazi.enable = true;
        shell = {
          enable = true;
          homeDirectory = homeDirectory;
          shell = "fish";
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
        svn.enable = true;
        ssh = {
          inherit authorizedKeys;
          config = ssh_config;
          enable = true;
          homeDirectory = homeDirectory;
        };
        nix.enable = true;
        languages.go.enable = true;
        languages.lisps.enable = true;
        languages.zig.enable = true;
        terminal = {
          enable = true;
          inherit colors theme terminal;
          linux = true;
          tmux = {
            enable = true;
          };
        };
        wm = {
          enable = true;
          sway = true;
          inherit colors theme terminal;
          wallpaper = builtins.fetchurl {
            url = "https://github.com/zhichaoh/catppuccin-wallpapers/raw/1023077979591cdeca76aae94e0359da1707a60e/landscapes/Clearday.jpg";
            sha256 = "1558rwh6a0by1sim6y41qh8pvdw7815n4bhqvrmxnsxnrid9w2wc";
          };
        };
        direnv.enable = true;
        scripts.enable = true;
        tf.enable = true;
        ai = {
          enable = true;
          inherit openai_token context7_api_key;
        };
      };

    xdg.configFile."sway/config.d/99-myconf.conf".text = ''
      set $hidpi "Xiaomi Corporation Redmi 27 NU 3948623Z90496"
      output $hidpi scale 1.6

      input * {
          xkb_layout "us,ru"
          xkb_options "grp:win_space_toggle"
          repeat_delay 200
          repeat_rate 30
      }
    '';

    # file /etc/udev/rules.d/99-otd.rules
    home.packages =
      let
        ujust-install-otd = writeShellScriptBin "ujust-install-otd" ''
          sudo mkdir -p /etc/udev/rules.d/
          sudo tee /etc/udev/rules.d/99-otd.rules > /dev/null <<EOF
          SUBSYSTEM=="hidraw", ACTION=="add", ATTRS{idVendor}=="256c", ATTRS{idProduct}=="0064", RUN+="/usr/bin/su ${username} -c 'systemctl --user start opentabletdriver.service'"
          SUBSYSTEM=="hidraw", ACTION=="remove", ATTRS{idVendor}=="256c", ATTRS{idProduct}=="0064", RUN+="/usr/bin/su ${username} -c 'systemctl --user stop opentabletdriver.service'"
          EOF
          sudo udevadm control --reload-rules
        '';
        ujust-uninstall-otd = writeShellScriptBin "ujust-uninstall-otd" ''
          # switch to sudo root:
          sudo rm /etc/udev/rules.d/99-otd.rules
          sudo udevadm control --reload-rules
        '';
      in
      [ ujust-install-otd ujust-uninstall-otd ];

    home.username = username;
    home.homeDirectory = homeDirectory;
    home.stateVersion = "23.11";

    nix.package = pkgs.nix;
  };
}
