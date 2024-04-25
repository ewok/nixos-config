{ lib, ... }:
with lib;
{
  options.opt.wm = {
    enable = mkEnableOption "wm";
    android = mkOption { type = types.bool; default = false; };
    linux = mkOption { type = types.bool; default = false; };
    macos = mkOption { type = types.bool; default = false; };
    steamos = mkOption { type = types.bool; default = false; };

    terminal = mkOption {
      type = types.str;
      default = "wezterm";
    };

    theme = mkOption {
      type = types.attrsOf types.str;
      default = {
        name = "onedark";
        separator_left = "";
        separator_right = "";
        alt_separator_left = "";
        alt_separator_right = "";
      };
    };

    colors = mkOption {
      type = types.attrsOf types.str;
      default = {
        base00 = "282c34";
        base01 = "353b45";
        base02 = "3e4451";
        base03 = "545862";
        base04 = "565c64";
        base05 = "abb2bf";
        base06 = "b6bdca";
        base07 = "c8ccd4";
        base08 = "e06c75";
        base09 = "d19a66";
        base0A = "e5c07b";
        base0B = "98c379";
        base0C = "56b6c2";
        base0D = "61afef";
        base0E = "c678dd";
        base0F = "be5047";
      };
    };


  };

  imports = [ ./mac.nix ./steamos.nix ];
}
