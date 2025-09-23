{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf mkOption;

  cfg = config.opt.tf;
in
{
  options.opt.tf = {
    enable = mkEnableOption "tf";
    cacheFolder = mkOption {
      type = lib.types.str;
      default = "$HOME/.terraform.d/plugin-cache/";
    };
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      asdf-vm
      tfautomv
    ];

    home.file.".terraformrc".text = ''
      plugin_cache_dir   = "${cfg.cacheFolder}"
      disable_checkpoint = true
    '';
    home.file.".terraform.d/plugin-cache/.gitignore".text = "";
    xdg.configFile."fish/conf.d/99_asdf.fish" = {
      text = ''
        source "$HOME/.nix-profile/share/asdf-vm/asdf.fish"
      '';
    };
    xdg.configFile."nushell/autoload/asdf.nu" = {
      text = ''
        let shims_dir = (
          if ( $env | get -o ASDF_DATA_DIR | is-empty ) {
            $env.HOME | path join '.asdf'
          } else {
            $env.ASDF_DATA_DIR
          } | path join 'shims'
        )
        $env.PATH = ( $env.PATH | split row (char esep) | where { |p| $p != $shims_dir } | prepend $shims_dir )
        # source "~/.nix-profile/share/asdf-vm/asdf.nu"
      '';
    };
  };
}
