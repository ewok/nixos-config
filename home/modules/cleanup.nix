{ config, lib, pkgs, ... }:
with lib;
let
  username = config.home.username;
  docker = config.home.dev.docker;
  sound = config.home.sound;
  gui = config.home.gui;
  comm = config.home.communication;
in
{
  config = {
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
          ExecStart =
            with pkgs;
            let
              cleanSlack = writeShellScript "clean-slack" ''
                ${pkgs.coreutils}/bin/rm -rf "/home/${username}/.config/Slack/Service Worker/CacheStorage"
                ${pkgs.coreutils}/bin/rm -rf "/home/${username}/.config/Slack/Cache"
                ${pkgs.coreutils}/bin/rm -rf "/home/${username}/.config/Slack/logs"
              '';
              cleanDiscord = writeShellScript "clean-discord" ''
                ${pkgs.coreutils}/bin/rm -rf "/home/${username}/.config/discord/Cache"
              '';
              cleanElement = writeShellScript "clean-element" ''
                ${pkgs.coreutils}/bin/rm -rf "/home/${username}/.config/Element/Cache"
              '';
              cleanSignal = writeShellScript "clean-signal" ''
                ${pkgs.coreutils}/bin/rm -rf "/home/${username}/.config/Signal/Cache"
              '';
              cleanSkype = writeShellScript "clean-skype" ''
                ${pkgs.coreutils}/bin/rm -rf "/home/${username}/.config/skypeforlinux/Cache"
              '';
              cleanTelegram = writeShellScript "clean-telegram" ''
                ${pkgs.coreutils}/bin/rm -rf "/home/${username}/.local/share/TelegramDesktop/tdata/user_data/media_cache"
              '';
              cleanSpotify = writeShellScript "clean-spotify" ''
                ${pkgs.coreutils}/bin/rm -rf "/home/${username}/.cache/spotify/Browser/Cache"
                ${pkgs.coreutils}/bin/rm -rf "/home/${username}/.cache/spotify/Data"
              '';
              cleanDocker = writeShellScript "clean-docker" ''
                ${pkgs.docker}/bin/docker system prune -f
              '';
            in
              toString (
                pkgs.writeShellScript "cleanup" ''
                  ${pkgs.coreutils}/bin/rm -rf "/home/${username}/.cache/nix/eval-cache-v2"
                  ${pkgs.coreutils}/bin/rm -rf "/home/${username}/.cache/pip"
                  ${pkgs.coreutils}/bin/rm -rf "/home/${username}/.local/share/vifm/Trash"
                  ${pkgs.trash-cli}/bin/trash-empty
                  ${optionalString (gui.enable && comm.enableSlack) cleanSlack}
                  ${optionalString (gui.enable && comm.enableDiscord) cleanDiscord}
                  ${optionalString (gui.enable && comm.enableElement) cleanElement}
                  ${optionalString (gui.enable && comm.enableSignal) cleanSignal}
                  ${optionalString (gui.enable && comm.enableSkype) cleanSkype}
                  ${optionalString (gui.enable && comm.enableTelegram) cleanTelegram}
                  ${optionalString (gui.enable && sound.enableSpotify) cleanSpotify}
                  ${optionalString (docker.enable) cleanDocker}
                ''
              );
        };
      };
    };
  };
}
