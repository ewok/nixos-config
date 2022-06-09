{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.opt.cleanup;
in
  {
    options.opt.cleanup = {
      enable = mkOption { type = types.bool; };
      username = mkOption { type = types.str; };
      slack = mkOption { type = types.bool; };
      discord = mkOption { type = types.bool; };
      element = mkOption { type = types.bool; };
      signal = mkOption { type = types.bool; };
      skype = mkOption { type = types.bool; };
      telegram = mkOption { type = types.bool; };
      spotify = mkOption { type = types.bool; };
      docker = mkOption { type = types.bool; };
    };

    config = mkIf cfg.enable {

      home-manager.users.${cfg.username} = {

        systemd = {
          user.timers.cleanup = {
            Unit = { Description = "Weekly cleanup"; };
            Timer = {
              Unit = "cleanup.service";
              OnCalendar = "weekly";
              Persistent = true;
            };
            Install = { WantedBy = [ "timers.target" ]; };
          };
          user.services.cleanup = {
            Unit = { Description = "Home cleanup"; };
            Service = {
              CPUSchedulingPolicy = "idle";
              IOSchedulingClass = "idle";
              ExecStart = with pkgs; let
                cleanSlack = writeShellScript "clean-slack" ''
                    ${pkgs.coreutils}/bin/rm -rf "/home/${cfg.username}/.config/Slack/Service Worker/CacheStorage"
                    ${pkgs.coreutils}/bin/rm -rf "/home/${cfg.username}/.config/Slack/Cache"
                    ${pkgs.coreutils}/bin/rm -rf "/home/${cfg.username}/.config/Slack/logs"
                '';
                cleanDiscord = writeShellScript "clean-discord" ''
                    ${pkgs.coreutils}/bin/rm -rf "/home/${cfg.username}/.config/discord/Cache"
                '';
                cleanElement = writeShellScript "clean-element" ''
                    ${pkgs.coreutils}/bin/rm -rf "/home/${cfg.username}/.config/Element/Cache"
                '';
                cleanSignal = writeShellScript "clean-signal" ''
                    ${pkgs.coreutils}/bin/rm -rf "/home/${cfg.username}/.config/Signal/Cache"
                '';
                cleanSkype = writeShellScript "clean-skype" ''
                    ${pkgs.coreutils}/bin/rm -rf "/home/${cfg.username}/.config/skypeforlinux/Cache"
                '';
                cleanTelegram = writeShellScript "clean-telegram" ''
                    ${pkgs.coreutils}/bin/rm -rf "/home/${cfg.username}/.local/share/TelegramDesktop/tdata/user_data/media_cache"
                '';
                cleanSpotify = writeShellScript "clean-spotify" ''
                    ${pkgs.coreutils}/bin/rm -rf "/home/${cfg.username}/.cache/spotify/Browser/Cache"
                    ${pkgs.coreutils}/bin/rm -rf "/home/${cfg.username}/.cache/spotify/Data"
                '';
                cleanDocker = writeShellScript "clean-docker" ''
                    ${pkgs.docker}/bin/docker system prune -f
                '';
              in
              toString (
                pkgs.writeShellScript "cleanup" ''
                ${pkgs.coreutils}/bin/rm -rf "/home/${cfg.username}/.cache/nix/eval-cache-v2"
                ${pkgs.coreutils}/bin/rm -rf "/home/${cfg.username}/.cache/pip"
                ${pkgs.coreutils}/bin/rm -rf "/home/${cfg.username}/.local/share/vifm/Trash"
                ${pkgs.trash-cli}/bin/trash-empty
                ${optionalString (cfg.slack) cleanSlack}
                ${optionalString (cfg.discord) cleanDiscord}
                ${optionalString (cfg.element) cleanElement}
                ${optionalString (cfg.signal) cleanSignal}
                ${optionalString (cfg.skype) cleanSkype}
                ${optionalString (cfg.telegram) cleanTelegram}
                ${optionalString (cfg.spotify) cleanSpotify}
                ${optionalString (cfg.docker) cleanDocker}
                ''
                );
              };
            };
          };
        };
      };
    }
