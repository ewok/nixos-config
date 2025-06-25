{ config, lib, pkgs, utils, ... }:
let
  inherit (lib) mkIf;

  cfg = config.opt.shell;
  vars = {
    darwin = cfg.darwin;
    linux = !cfg.darwin;
    homeDirectory = cfg.homeDirectory;
    openAiToken = cfg.openai_token;
  };
in
{
  config = mkIf (cfg.enable && (cfg.shell == "nu"))
    {
      home = {
        packages = with pkgs; [
          nushell
        ];
      };
      xdg = {
        configFile = {
          "nushell/config.nu".source = ./config/config.nu;
          "nushell/autoload/granted.nu".source = ./config/granted.nu;
          "nushell/autoload/autoload.nu".source = utils.templateFile "autoload.nu" ./config/autoload.nu vars;
        };
      };
    };
}
