{ config, lib, utils, ... }:
let
  inherit (lib) mkIf;

  cfg = config.opt.wm;
  # spacebar-sh = pkgs.writeScriptBin "spacebar.sh" ''
  #   ${readFile ./config/macos/spacebar.sh}
  # '';
  vars = {
    conf.colors = cfg.colors;
    conf.theme = cfg.theme;
    conf.terminal = cfg.terminal;
    conf.folders.bin = "/home/deck/bin";
  };
in
{
  config = mkIf (cfg.enable && cfg.steamos)
    {
      # home.packages = [ spacebar-sh ];
      # Some KDE tunings
      home.file."bin/center-mouse" = {
        source = ./config/steamos/i3/center-mouse;
        executable = true;
      };
      home.file."bin/i3exit" = {
        source = ./config/steamos/i3/i3exit;
        executable = true;
      };
      # home.file.".config" = {
      #   source = ./config/steamos/kde;
      #   recursive = true;
      # };
      xdg.configFile."i3/config" = {
        source = utils.templateFile "config" ./config/steamos/i3/config vars;
        executable = true;
      };
    };
}
