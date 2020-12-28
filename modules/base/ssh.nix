{ config, lib, pkgs, ...  }:
with lib;
let
  base = config.modules.base;
  username = config.properties.user.name;
in
{
  options.modules.base.ssh = {
    config = mkOption {
      type = types.lines;
      default = "{}";
    };
  };

  config = mkIf base.enable {
    home-manager.users."${username}" = {
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

        matchBlocks = builtins.fromJSON base.ssh.config;
      };
    };
  };
}

