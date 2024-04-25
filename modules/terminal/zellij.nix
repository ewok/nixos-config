{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.opt.terminal;

  vars = {
    conf.colors = cfg.colors;
    conf.theme = cfg.theme;
    conf.terminal = cfg.tmux.terminal;
  };
in
{
  config = mkIf (cfg.enable && cfg.zellij.enable) {
    home.packages = with pkgs; let
      optionalPkgs = optionals cfg.zellij.install [ zellij ];
    in
    [
      gnugrep
      procps
      xsel
    ] ++ optionalPkgs;
    # xdg.configFile."tmux/tmux.conf".source = utils.templateFile "tmux.conf" ./config/tmux.conf vars;
    # xdg.configFile."tmux/tmux_blocks" = {
    #   source = utils.templateFile "tmux_blocks" ./config/tmux_blocks vars;
    #   executable = true;
    # };
  };
}
