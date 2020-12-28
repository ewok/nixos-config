{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.modules.system.sound;
  username = config.properties.user.name;
in
{
  options.modules.system.sound = {
    enable = mkEnableOption "Enable sound.";
    pulse.enable = mkEnableOption "Enable pulse audio.";
  };

  config = mkMerge [
    (mkIf cfg.enable {
      users.users.${username}.extraGroups = [ "audio" ];
    })
    (mkIf cfg.pulse.enable {
      users.users.${username}.extraGroups = [ "pulse" ];
      hardware.pulseaudio = {
        enable = true;
        support32Bit = true;
        package = pkgs.pulseaudioFull;
        systemWide = true;
        daemon.config = { flat-volumes = "no"; };
        extraConfig = ''
          load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1
        '';
      };
      environment.systemPackages = with pkgs; [ ponymix lxqt.pavucontrol-qt ];
    })
  ];
}
