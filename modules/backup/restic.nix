{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.opt.backup;
  passFile = "nixos/secrets/restic-home-${cfg.username}";
  homeDirectory = config.home-manager.users.${cfg.username}.home.homeDirectory;

  resticBackup = pkgs.writeShellScriptBin "restic-backup" ''
    set -e

    PASS_FILE="/etc/${passFile}"

    RESTIC="restic -r ${cfg.restic.repo} -p $PASS_FILE"

    $RESTIC "$@"
    '';
in
{
  options.opt.backup = {
    enable = mkOption { type = types.bool; };
    username = mkOption {type = types.str;};
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
      paths = mkOption {
        description = "Backup directories.";
        type = types.listOf types.str;
        default = [ "/etc/" "${homeDirectory}" ];
      };
      excludePaths = mkOption {
        description = "List of paths to exclude from backup.";
        type = types.listOf types.str;
        default = [];
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.restic.repo != null;
        message = "Backup repo must be specified.";
      }
    ];

    environment.etc."${passFile}" = {
      text = cfg.restic.pass;
      mode = "0600";
    };

    services.restic.backups = {
      home = {
        passwordFile = "/etc/${passFile}";
        paths = cfg.restic.paths;
        repository = cfg.restic.repo;
        timerConfig = {
          OnCalendar = "12:30";
          RandomizedDelaySec = "5h";
        };
        user = "root";
        extraBackupArgs = [
          "--exclude-caches"
          "--exclude-if-present .nobackup"
          "--exclude-file ${homeDirectory}/.backup_exclude"
        ];
        rcloneOptions = {
          # bwlimit = "1M";
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

    home-manager.users."${cfg.username}" = {
      home.file.".backup_exclude".text = concatStringsSep "\n" cfg.restic.excludePaths;
      home.packages = [ pkgs.restic pkgs.rclone resticBackup ];
    };
  };
}
