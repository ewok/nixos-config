{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.opt.ssh;
in
{
  options.opt.ssh = {
    enable = mkEnableOption "ssh";
    config = mkOption { type = types.str; };
    authorizedKeys = mkOption { type = types.str; };
  };

  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      compression = true;
      serverAliveInterval = 10;
      serverAliveCountMax = 3;
      userKnownHostsFile = "/dev/null";
      # controlMaster = "auto";
      # controlPath = "/tmp/ssh_mux_%h_%p_%r";
      # controlPersist = "1h";
      extraOptionOverrides = {
        "StrictHostKeyChecking" = "no";
        "PubkeyAcceptedKeyTypes" = "+ssh-rsa";
        "HostKeyAlgorithms" = "+ssh-rsa";
      };

      matchBlocks = builtins.fromJSON cfg.config;
    };

    home.file.".ssh/authorized_keys".text = ''
      ${cfg.authorizedKeys}
    '';
  };
}
