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
          "nushell/config.nu".source = utils.templateFile "config.nu" ./config/config.nu vars;
          "nushell/autoload/granted.nu".source = ./config/granted.nu;
          "nushell/autoload/autoload.nu".source = ./config/autoload.nu;
        };
      };
    };
}
