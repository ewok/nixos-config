{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (pkgs) symlinkJoin;
  cfg = config.opt.kube;

  klog = symlinkJoin {
    name = "klog";
    paths = [ pkgs.stern ];
    postBuild = ''
      ln -s $out/bin/stern $out/bin/klog
    '';
  };
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
        klog
      ];
    };
    xdg.configFile."fish/conf.d/90_kube.fish".source = ./config/90_kube.fish;
    xdg.configFile."nushell/autoload/kube.nu".source = ./config/kube.nu;
  };
}
