{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.opt.sudo;
in
{
  options.opt.sudo = {
    askPass = mkOption {
      type = types.bool;
      description = "Ask sudo password for @wheel.";
      default = true;
    };
  };

  config = {
    security.sudo.wheelNeedsPassword = cfg.askPass;
    security.sudo.extraConfig = ''
      Defaults                    !tty_tickets
      Defaults                    timestamp_timeout=30
    '';
  };
}
