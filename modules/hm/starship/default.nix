{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.opt.starship;
in
{
  options.opt.starship = {
    enable = mkEnableOption "starship";
  };

  config = mkIf cfg.enable {
    # home-manager.config = { pkgs, ... }: {
      home = {
        packages = with pkgs; [
          starship
        ];
      };
      xdg = {
        configFile = {
          "fish/conf.d/99_starship.fish".source = ./config/99_starship.fish;
          "starship.toml".source = ./config/starship.toml;
        };
      };
    # };
  };
}
