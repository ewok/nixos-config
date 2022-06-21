{ config, lib, pkgs, inputs, ... }:
with lib;
let
  cfg = config.opt.communication;
in
{
  options.opt.communication = {
    enable = mkOption { type = types.bool; };
    username = mkOption { type = types.str; };
    discord.enable = mkOption {type = types.bool;};
    element.enable = mkOption {type = types.bool;};
    signal.enable = mkOption {type = types.bool;};
    skype.enable = mkOption {type = types.bool;};
    slack.enable = mkOption {type = types.bool;};
    telegram.enable = mkOption {type = types.bool;};
    thunderbird.enable = mkOption {type = types.bool;};
    twitter.enable = mkOption {type = types.bool;};
    zoom.enable = mkOption {type = types.bool;};
  };

  config = mkIf cfg.enable {

      home.packages = [] ++
      optionals (cfg.discord.enable) [
        pkgs.discord
      ] ++
      optionals (cfg.element.enable) [
        pkgs.element-desktop
      ] ++
      optionals (cfg.signal.enable) [
        pkgs.signal-desktop
      ] ++
      optionals (cfg.skype.enable) [
        pkgs.skypeforlinux
      ] ++
      optionals (cfg.slack.enable) [
        pkgs.slack
      ] ++
      optionals (cfg.telegram.enable) [
        pkgs.tdesktop
      ] ++
      optionals (cfg.thunderbird.enable) [
        pkgs.thunderbird
      ] ++
      optionals (cfg.twitter.enable) [
        pkgs.cawbird
      ] ++
      optionals (cfg.zoom.enable) [
        pkgs.zoom-us
      ];

    # xdg.mimeApps.defaultApplications = lib.genAttrs [
    #   "x-scheme-handler/tg"
    # ] (_: [ "telegramdesktop.desktop" ]);
    };
}
