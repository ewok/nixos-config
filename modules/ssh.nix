{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.opt.ssh;
in
{
  options.opt.ssh.config = mkOption {type = types.str;};
  options.opt.ssh.username = mkOption {type = types.str;};

  config = {
    home-manager.users.${cfg.username} = {
      home.packages = [ pkgs.sshuttle pkgs.sshpass ];

      programs.ssh = {
        enable = true;
        compression = true;
        serverAliveInterval = 10;
        serverAliveCountMax = 3;
        userKnownHostsFile = "/dev/null";
        controlMaster = "auto";
        controlPath = "/tmp/ssh_mux_%h_%p_%r";
        controlPersist = "1h";
        extraOptionOverrides = {
          "StrictHostKeyChecking" = "no";
        };

        matchBlocks = builtins.fromJSON cfg.config;
      };
    };
  };
}
