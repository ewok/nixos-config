{ lib, ... }:
with lib;
let
  colors = {
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
    base0F = "be5046"; # #be5046
  };
  theme = {
    separator_left = "";
    separator_right = "";
    alt_separator_left = "";
    alt_separator_right = "";
    name = "onedark";
    regular_font = "FiraCode Nerd Font";
    regular_font_size = "10";
    monospace_font = "FiraCode Nerd Font Mono";
    monospace_font_size = "10";
  };
in
{
  options =
    {
      username = mkOption {
        type = types.str;
      };

      colors = {
        base00 = mkOption { type = types.str; };
        base01 = mkOption { type = types.str; };
        base02 = mkOption { type = types.str; };
        base03 = mkOption { type = types.str; };
        base04 = mkOption { type = types.str; };
        base05 = mkOption { type = types.str; };
        base06 = mkOption { type = types.str; };
        base07 = mkOption { type = types.str; };
        base08 = mkOption { type = types.str; };
        base09 = mkOption { type = types.str; };
        base0A = mkOption { type = types.str; };
        base0B = mkOption { type = types.str; };
        base0C = mkOption { type = types.str; };
        base0D = mkOption { type = types.str; };
        base0E = mkOption { type = types.str; };
        base0F = mkOption { type = types.str; };
      };

      theme = {
        name = mkOption { type = types.str; };
        separator_left = mkOption { type = types.str; };
        separator_right = mkOption { type = types.str; };
        alt_separator_left = mkOption { type = types.str; };
        alt_separator_right = mkOption { type = types.str; };
        regular_font = mkOption { type = types.str; };
        regular_font_size = mkOption { type = types.str; };
        monospace_font = mkOption { type = types.str; };
        monospace_font_size = mkOption { type = types.str; };
      };
    };

  config = {
    inherit colors;
    inherit theme;
    nix = {
      extraOptions = ''
        keep-outputs = true
        keep-derivations = true
        experimental-features = nix-command flakes
      '';
    };
  };
}
