{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.opt.kube;
  npkgs = import
    (fetchTarball {
      url = "https://github.com/nixos/nixpkgs/archive/9ea24fc7e02b65c150c88e1412400b70087bd382.tar.gz";
      sha256 = "002abgrz7gdj99gzyhmkpxx8j3x5grapmal9i0r580phvin9g2r5";
    })
    { inherit (pkgs) system; };
in
{
  options.opt.kube = {
    enable = mkEnableOption "kube";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with npkgs; [
        kubectl
        kubectx
      ];
    };
    xdg.configFile."fish/conf.d/90_kube.fish".source = ./config/90_kube.fish;
  };
}
