{ lib, ... }:
let
  inherit (lib) mkEnableOption mkOption types;
in
{
  options.opt = {
    terminal = {
      enable = mkEnableOption "terminal";
      linux = mkOption { type = types.bool; default = false; };
      orb = mkOption { type = types.bool; default = false; };
      terminal = mkOption {
        type = types.str;
        default = "wezterm";
      };
      tmux = {
        enable = mkEnableOption "tmux";
        install = mkOption {
          type = types.bool;
          default = true;
        };
        terminal = mkOption {
          type = types.str;
          default = "tmux-256color";
        };
      };

      zellij = {
        enable = mkEnableOption "zellij";
        install = mkOption {
          type = types.bool;
          default = false;
        };
      };

      theme = mkOption {
        type = types.attrsOf types.str;
        default = {
          name = "onedark";
          light_name = "onedark";
          separator_left = "";
          separator_right = "";
          alt_separator_left = "";
          alt_separator_right = "";
        };
      };

      colors = mkOption {
        type = types.attrsOf types.str;
        default = {
          base00 = "282c34"; # #282c34
          base01 = "353b45"; # #353b45
          base02 = "3e4451"; # #3e4451
          base03 = "545862"; # #545862
          base04 = "565c64"; # #565c64
          base05 = "abb2bf"; # #abb2bf
          base06 = "b6bdca"; # #b6bdca
          base07 = "c8ccd4"; # #c8ccd4
          base08 = "e06c75"; # #e06c75
          base09 = "d19a66"; # #d19a66
          base0A = "e5c07b"; # #e5c07b
          base0B = "98c379"; # #98c379
          base0C = "56b6c2"; # #56b6c2
          base0D = "61afef"; # #61afef
          base0E = "c678dd"; # #c678dd
          base0F = "be5047"; # #be5047
        };
      };

    };
  };
  imports = [ ./alacritty.nix ./wezterm.nix ./tmux.nix ./zellij.nix ./foot.nix ];
}
