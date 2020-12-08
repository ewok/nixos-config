{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.backup.restic;
  backup = config.modules.backup;
  username = config.properties.user.name;
  passFile = "nixos/secrets/restic-home-${username}";
in
{
  options.modules.backup = {
    restic = {
      repo = mkOption {
        description = "Restic backup repository.";
        type = types.nullOr types.str;
        default = null;
      };
      pass = mkOption {
        description = "Restic repository password.";
        type = types.str;
      };
      excludePaths = mkOption {
        description = "List of paths to exclude from backup.";
        type = types.listOf types.str;
        default = [];
      };
    };
  };

  config = mkIf backup.enable {
      assertions = [{
        assertion = cfg.repo != null;
        message = "Backup repo must be specified.";
      }];

    environment.etc."${passFile}" = {
      text = cfg.pass;
      mode = "0600";
    };

    services.restic.backups = {
      home = {
        passwordFile = "/etc/${passFile}";
        paths = [ "/etc/" "/home/${username}" ];
        repository = cfg.repo;
        timerConfig = {
          OnCalendar = "12:30";
          RandomizedDelaySec = "5h";
        };
        user = "root";
        extraBackupArgs = [
          "--exclude-caches"
          "--exclude-if-present .nobackup"
          "--exclude-file /home/${username}/.backup_exclude"
        ];
        rcloneOptions = {
          bwlimit = "1M";
          drive-use-trash = "true";
        };
        initialize = true;
        pruneOpts = [
          "--keep-daily 7"
          "--keep-weekly 5"
          "--keep-monthly 12"
          "--keep-yearly 5"
        ];
      };
    };

    home-manager.users."${username}" = {
      home.file.".backup_exclude".text = concatStringsSep "\n" cfg.excludePaths;
      home.packages = [ pkgs.restic ];
    };
  };
}

