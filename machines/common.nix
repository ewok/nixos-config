{ lib, ... }:
let
  inherit (lib) types mkOption;

  colors = {

    # Catpuccin Frappe
    # base00 = "303446"; #303446 base
    # base01 = "292c3c"; #292c3c mantle
    # base02 = "414559"; #414559 surface0
    # base03 = "51576d"; #51576d surface1
    # base04 = "626880"; #626880 surface2
    # base05 = "c6d0f5"; #c6d0f5 text
    # base06 = "f2d5cf"; #f2d5cf rosewater
    # base07 = "babbf1"; #babbf1 lavender
    # base08 = "e78284"; #e78284 red
    # base09 = "ef9f76"; #ef9f76 peach
    # base0A = "e5c890"; #e5c890 yellow
    # base0B = "a6d189"; #a6d189 green
    # base0C = "81c8be"; #81c8be teal
    # base0D = "8caaee"; #8caaee blue
    # base0E = "ca9ee6"; #ca9ee6 mauve
    # base0F = "eebebe"; #eebebe flamingo

    # Catpuccin Macchiato
    # base00 = "24273a"; #24273a base
    # base01 = "1e2030"; #1e2030 mantle
    # base02 = "363a4f"; #363a4f surface0
    # base03 = "494d64"; #494d64 surface1
    # base04 = "5b6078"; #5b6078 surface2
    # base05 = "cad3f5"; #cad3f5 text
    # base06 = "f4dbd6"; #f4dbd6 rosewater
    # base07 = "b7bdf8"; #b7bdf8 lavender
    # base08 = "ed8796"; #ed8796 red
    # base09 = "f5a97f"; #f5a97f peach
    # base0A = "eed49f"; #eed49f yellow
    # base0B = "a6da95"; #a6da95 green
    # base0C = "8bd5ca"; #8bd5ca teal
    # base0D = "8aadf4"; #8aadf4 blue
    # base0E = "c6a0f6"; #c6a0f6 mauve
    # base0F = "f0c6c6"; #f0c6c6 flamingo

    # Tokyo Night Storm
    base00 = "24283b"; #24283b base
    base01 = "1f2335"; #1f2335 mantle
    base02 = "292e42"; #292e42 surface0
    base03 = "414868"; #414868 surface1
    base04 = "565f89"; #565f89 surface2
    base05 = "a9b1d6"; #a9b1d6 text
    base06 = "c0caf5"; #c0caf5 bright text
    base07 = "cbccd1"; #cbccd1 lightest
    base08 = "f7768e"; #f7768e red
    base09 = "ff9e64"; #ff9e64 orange
    base0A = "e0af68"; #e0af68 yellow
    base0B = "9ece6a"; #9ece6a green
    base0C = "7dcfff"; #7dcfff cyan
    base0D = "7aa2f7"; #7aa2f7 blue
    base0E = "bb9af7"; #bb9af7 magenta
    base0F = "9d7cd8"; #9d7cd8 purple

    # Catpuccin Mocha
    # base00 = "1e1e2e"; #1e1e2e ; base
    # base01 = "181825"; #181825 ; mantle
    # base02 = "313244"; #313244 ; surface0
    # base03 = "45475a"; #45475a ; surface1
    # base04 = "585b70"; #585b70 ; surface2
    # base05 = "cdd6f4"; #cdd6f4 ; text
    # base06 = "f5e0dc"; #f5e0dc ; rosewater
    # base07 = "b4befe"; #b4befe ; lavender
    # base08 = "f38ba8"; #f38ba8 ; red
    # base09 = "fab387"; #fab387 ; peach
    # base0A = "f9e2af"; #f9e2af ; yellow
    # base0B = "a6e3a1"; #a6e3a1 ; green
    # base0C = "94e2d5"; #94e2d5 ; teal
    # base0D = "89b4fa"; #89b4fa ; blue
    # base0E = "cba6f7"; #cba6f7 ; mauve
    # base0F = "f2cdcd"; #f2cdcd ; flamingo

    # Nightfox
    # base00 = "192330"; # #192330
    # base01 = "212e3f"; # #212e3f
    # base02 = "29394f"; # #29394f
    # base03 = "575860"; # #575860
    # base04 = "71839b"; # #71839b
    # base05 = "cdcecf"; # #cdcecf
    # base06 = "aeafb0"; # #aeafb0
    # base07 = "e4e4e5"; # #e4e4e5
    # base08 = "c94f6d"; # #c94f6d
    # base09 = "f4a261"; # #f4a261
    # base0A = "dbc074"; # #dbc074
    # base0B = "81b29a"; # #81b29a
    # base0C = "63cdcf"; # #63cdcf
    # base0D = "719cd6"; # #719cd6
    # base0E = "9d79d6"; # #9d79d6
    # base0F = "d67ad2"; # #d67ad2

    # Onedark
    # base00 = "282c34"; # #282c34
    # base01 = "353b45"; # #353b45
    # base02 = "3e4451"; # #3e4451
    # base03 = "545862"; # #545862
    # base04 = "565c64"; # #565c64
    # base05 = "abb2bf"; # #abb2bf
    # base06 = "b6bdca"; # #b6bdca
    # base07 = "c8ccd4"; # #c8ccd4
    # base08 = "e06c75"; # #e06c75
    # base09 = "d19a66"; # #d19a66
    # base0A = "e5c07b"; # #e5c07b
    # base0B = "98c379"; # #98c379
    # base0C = "56b6c2"; # #56b6c2
    # base0D = "61afef"; # #61afef
    # base0E = "c678dd"; # #c678dd
    # base0F = "be5046"; # #be5046

    # # Github base16 theme
    # base00 = "333333"; # #333333
    # base01 = "3c3c3c"; # #3c3c3c
    # base02 = "464646"; # #464646
    # base03 = "585858"; # #585858
    # base04 = "b8b8b8"; # #b8b8b8
    # base05 = "d8d8d8"; # #d8d8d8
    # base06 = "e8e8e8"; # #e8e8e8
    # base07 = "f8f8f8"; # #f8f8f8
    # base08 = "ed6a43"; # #ed6a43
    # base09 = "0086b3"; # #0086b3
    # base0A = "795da3"; # #795da3
    # base0B = "183691"; # #183691
    # base0C = "183691"; # #183691
    # base0D = "795da3"; # #795da3
    # base0E = "a71d5d"; # #a71d5d
    # base0F = "333333"; # #333333
  };
  theme = {
    common = {
      separator_left = "";
      separator_right = "";
      alt_separator_left = "";
      alt_separator_right = "";
      regular_font = "FiraCode Nerd Font";
      regular_font_size = "10";
      monospace_font = "Maple Mono NF";
      monospace_font_size = "12";
    };
    nvim = {
      name = "tokyonight";
      flavor = "moon";
      light_flavor = "day";
    };
    wezterm = {
      dark = "tokyonight-storm";
      light = "tokyonight-day";
    };
    ghostty = {
      dark = "TokyoNight Moon";
      light = "TokyoNight Day";
    };
    vifm = "tokyonight";
    opencode = "tokyonight";
  };
in
{
  imports = [
    ./secrets.nix
  ];

  options =
    {
      username = mkOption { type = types.str; };
      fullName = mkOption { type = types.str; };
      email = mkOption { type = types.str; };
      workEmail = mkOption { type = types.str; };
      deviceName = mkOption { type = types.str; };
      backupRepo = mkOption { type = types.str; }; # rclone
      timezone = mkOption { type = types.str; };
      projectDir = mkOption { type = types.str; };
      homeDirectory = mkOption { type = types.str; };

      openai_token = mkOption { type = types.str; };
      context7_api_key = mkOption { type = types.str; };
      exchange_api_key = mkOption { type = types.str; };

      ssh_config = mkOption { type = types.str; };
      authorizedKeys = mkOption { type = types.str; };

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
        common = {
          separator_left = mkOption { type = types.str; };
          separator_right = mkOption { type = types.str; };
          alt_separator_left = mkOption { type = types.str; };
          alt_separator_right = mkOption { type = types.str; };
          regular_font = mkOption { type = types.str; };
          regular_font_size = mkOption { type = types.str; };
          monospace_font = mkOption { type = types.str; };
          monospace_font_size = mkOption { type = types.str; };
        };
        nvim = {
          name = mkOption { type = types.str; };
          flavor = mkOption { type = types.str; };
          light_flavor = mkOption { type = types.str; };
        };
        wezterm = {
          dark = mkOption { type = types.str; };
          light = mkOption { type = types.str; };
        };
        ghostty = {
          dark = mkOption { type = types.str; };
          light = mkOption { type = types.str; };
        };
        vifm = mkOption { type = types.str; };
        opencode = mkOption { type = types.str; };
      };
    };

  config = {
    inherit colors;
    inherit theme;

    # nixpkgs.config.allowUnfree = true;

    nix = {
      extraOptions = ''
        # keep-outputs = true
        # keep-derivations = true
        experimental-features = nix-command flakes
      '';
    };
  };
}
