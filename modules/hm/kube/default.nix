{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.opt.kube;
in
{
  options.opt.kube = {
    enable = mkEnableOption "kube";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        kubectl
        kubectx
        k9s
        kubernetes-helm
      ];
    };
    xdg.configFile."fish/conf.d/90_kube.fish".source = ./config/90_kube.fish;
  };
}
