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
      asdf-vm
      tfautomv
    ];

    home.file.".terraformrc".text = ''
      plugin_cache_dir   = "$HOME/.terraform.d/plugin-cache/"
      disable_checkpoint = true
    '';
    home.file.".terraform.d/plugin-cache/.gitignore".text = "";
    xdg.configFile."fish/conf.d/99_asdf.fish" = {
      text = ''
        source "$HOME/.nix-profile/share/asdf-vm/asdf.fish"
      '';
    };
  };
}
