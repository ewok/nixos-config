{ config, pkgs, ... }:
let
  inherit (config) colors theme exchange_api_key openai_token fullName email workEmail authorizedKeys ssh_config;

  username = "ataranchiev";
  homeDirectory = "/var/home/${username}";
  terminal = "wezterm";
in
{
  config = {

    opt =
      {
        nvim = {
          enable = true;
          inherit colors theme openai_token;
        };
        vifm.enable = true;
        fish = {
          enable = true;
          homeDirectory = homeDirectory;
          inherit openai_token;
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
        lisps.enable = true;
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
    home.username = username;
    home.homeDirectory = homeDirectory;
    home.stateVersion = "23.11";

    nix.package = pkgs.nix;
  };
}
