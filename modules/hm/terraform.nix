{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.opt.tf;
in
{
  options.opt.tf = {
    enable = mkEnableOption "tf";
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      tenv
      tfautomv
    ];

    home.file.".terraformrc".text = ''
      plugin_cache_dir   = "$HOME/.terraform.d/plugin-cache/"
      disable_checkpoint = true
      '';
    home.file.".terraform.d/plugin-cache/.gitignore".text = "";
  };
}
