{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf mkOption types;

  cfg = config.opt.ssh;
  dag = config.lib.dag;
in
{
  options.opt.ssh = {
    enable = mkEnableOption "ssh";
    config = mkOption { type = types.str; };
    authorizedKeys = mkOption { type = types.str; };
    homeDirectory = mkOption { type = types.str; };
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

    home.activation.ssh-changes = dag.entryAnywhere ''
      chmod 0700 ${cfg.homeDirectory}/.ssh || true
      chmod 0600 ${cfg.homeDirectory}/.ssh/* || true
    '';
    home.file.".ssh/authorized_keys_tmp" =
      {
        text = ''
          ${cfg.authorizedKeys}
        '';
        onChange = ''
          cp ${cfg.homeDirectory}/.ssh/authorized_keys_tmp ${cfg.homeDirectory}/.ssh/authorized_keys
          chmod 0400 ${cfg.homeDirectory}/.ssh/authorized_keys
        '';
      };
  };
}
