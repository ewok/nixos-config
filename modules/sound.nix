{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.opt.sound;
in
{
  options.opt.sound = {
    enable = mkOption { type = types.bool; };
    username = mkOption { type = types.str; };
    pipewire.enable = mkOption { type = types.bool; };
    sof.enable = mkOption { type = types.bool; };
  };

  config = mkMerge [
    (
      mkIf cfg.enable {
        users.users.${cfg.username}.extraGroups = [ "audio" "jackaudio" ];

        # sound.enable = true;
        hardware = {
          enableAllFirmware = true;
          enableRedistributableFirmware = true;
        };
      }
    )
    (
      mkIf (cfg.enable && cfg.pipewire.enable) {
        security.rtkit.enable = true;
        services.pipewire = {
          enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          pulse.enable = true;
        };

        users.users.${cfg.username}.extraGroups = [ "sound" ];

        environment.systemPackages = with pkgs; [
          ponymix
          lxqt.pavucontrol-qt
        ] ++ optionals (cfg.sof.enable) [
          sof-firmware
        ];
      }
    )
  ];
}
