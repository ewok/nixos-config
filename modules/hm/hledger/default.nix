{ config, lib, pkgs, utils, ... }:
with lib;
let
  cfg = config.opt.hledger;
  vars = {
    conf.exchange.api_key = cfg.exchange_api_key;
  };
in
{
  options.opt.hledger = {
    enable = mkEnableOption "hledger";
    exchange_api_key = mkOption {
      type = types.str;
      default = "";
      description = "API key for currency exchange rates";
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        hledger
        babashka-unwrapped
        coreutils
      ];
      file."bin" = {
        source = ./config/bin;
        executable = true;
        recursive = true;
      };
      file."bin/h-update-prices" = {
        source = utils.templateFile "h-update-prices" ./config/h-update-prices vars;
        executable = true;
      };
    };
  };
}
