{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf;

  cfg = config.opt.shell;
in
{
  config = mkIf (cfg.enable && (cfg.shell == "fish"))
    {
      home = {
        packages = with pkgs; [
          fish
        ];
      };
      xdg = {
        configFile = {
          "fish/conf.d/00_pre_init.fish".source = ./config/00_pre_init.fish;
          "fish/conf.d/01_init_interactive.fish".source = ./config/01_init_interactive.fish;
          "fish/conf.d/95_greeting.fish".source = ./config/95_greeting.fish;
          "fish/conf.d/99_zoxide.fish".source = ./config/99_zoxide.fish;
          "fish/conf.d/99_carapace.fish".source = ./config/99_carapace.fish;

          # disable brew completion
          "fish/conf.d/brew.fish".text = "";

          "fish/fish_plugins".source = ./config/fish_plugins;
          "fish/functions/fisher.fish".source = pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/jorgebucaran/fisher/a04308be92daa6cfecdbb0ca58b1e8508664cff2/functions/fisher.fish";
            hash = "sha256-D7bIGuMAPpW1Zxdm+mwlw1lwZuKZZbd3L2wbAHOHNW0=";
          };
        };
      };
    };
}
