{ config, lib, pkgs, utils, ... }:
let
  inherit (lib) mkEnableOption mkIf types mkOption;

  cfg = config.opt.starship;

  vars = {
    conf.colors = cfg.colors;
  };
in
{
  options.opt.starship = {
    enable = mkEnableOption "starship";

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

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        starship
      ];
    };
    xdg = {
      configFile = {
        "fish/conf.d/99_starship.fish".source = ./config/99_starship.fish;
        "starship.toml".source = utils.templateFile "starship.toml" ./config/starship.toml vars;
        "nushell/autoload/starship.nu".text = ''
          mkdir ($nu.data-dir | path join "vendor/autoload")
          starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
        '';
      };
    };
  };
}
