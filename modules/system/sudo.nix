{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.system.sudo;
  username = config.properties.user.name;
in
{
  options.modules.system.sudo = {
    askPass = mkOption {
      type = types.bool;
      description = "Ask sudo password for @wheel.";
      default = true;
    };
  };

  config = {
    security.sudo.extraConfig = ''
      %wheel ALL=(ALL) ${optionalString (!cfg.askPass) "NOPASSWD:"} ALL, SETENV: ALL
      Defaults                    !tty_tickets
      Defaults                    timestamp_timeout=30
    '';
  };
}
