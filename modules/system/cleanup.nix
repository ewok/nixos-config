{ config, lib, pkgs, ... }:
with lib;
let
  username = config.properties.user.name;
  docker = config.modules.dev.docker;
  sound = config.modules.system.sound;
  gui = config.modules.gui;
  comm = config.modules.communication;
in
{
  config = {
    systemd = {
      timers.cleanup-timer = {
        wantedBy = [ "timers.target" ];
        partOf = [ "cleanup-timer.service" ];
        timerConfig.OnCalendar = "weekly";
      };
      services.cleanup-timer = {
        serviceConfig.Type = "oneshot";
        script = ''
          journalctl --vacuum-size=500M
          rm -rf "/home/${username}/.cache/nix/eval-cache-v2"
          rm -rf "/home/${username}/.cache/pip"
        '' + optionalString (gui.enable && comm.enable && comm.enableSlack) ''
          rm -rf "/home/${username}/.config/Slack/Service Worker/CacheStorage"
          rm -rf "/home/${username}/.config/Slack/Cache"
          rm -rf "/home/${username}/.config/Slack/logs"
        '' + optionalString (gui.enable && comm.enable && comm.enableDiscord) ''
          rm -rf "/home/${username}/.config/discord/Cache"
        '' + optionalString (gui.enable && comm.enable && comm.enableElement) ''
          rm -rf "/home/${username}/.config/Element/Cache"
        '' + optionalString (gui.enable && comm.enable && comm.enableSignal) ''
          rm -rf "/home/${username}/.config/Signal/Cache"
        '' + optionalString (gui.enable && comm.enable && comm.enableSkype) ''
          rm -rf "/home/${username}/.config/skypeforlinux/Cache"
        '' + optionalString (gui.enable && comm.enable && comm.enableTelegram) ''
          rm -rf "/home/${username}/.local/share/TelegramDesktop/tdata/user_data/media_cache"
        '' + optionalString (gui.enable && sound.enable) ''
          rm -rf "/home/${username}/.cache/spotify/Browser/Cache"
          rm -rf "/home/${username}/.cache/spotify/Data"
        '' + optionalString (docker.enable) ''
          ${pkgs.docker}/bin/docker system prune -f
        '' + ''
          rm -rf "/home/${username}/.local/share/vifm/Trash"
          ${pkgs.sudo}/bin/sudo -u ${username} ${pkgs.trash-cli}/bin/trash-empty
        '';
      };
    };
  };
}
