{ config, lib, pkgs, ... }:
with lib;
let
  dev = config.home.dev;
in
{
  config = mkIf dev.enable {
    home.packages = with pkgs; [
      ripgrep
    ];

    programs.fzf = {
      enable = true;
      # enableFishIntegration = true;
      enableZshIntegration = true;
      defaultCommand = "rg --hidden --no-ignore --files";
    };
  };
}
