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
      users.users.${username}.extraGroups = [ "audio" "jackaudio" ];

      #services.jack = {
      #  jackd.enable = true;
      #  # support ALSA only programs via ALSA JACK PCM plugin
      #  alsa.enable = false;
      #  # support ALSA only programs via loopback device (supports programs like Steam)
      #  loopback = {
      #    enable = true;
      #    # buffering parameters for dmix device to work with ALSA only semi-professional sound programs
      #    #dmixConfig = ''
      #    #  period_size 2048
      #    #'';
      #  };
      #};

    })
    (mkIf cfg.pulse.enable {
      users.users.${username}.extraGroups = [ "pulse" ];
      hardware.pulseaudio = {
        enable = true;
        support32Bit = true;
        package = pkgs.pulseaudioFull;
        # systemWide = true;
        daemon.config = { flat-volumes = "no"; };
        extraConfig = ''
          load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1
        '';
      };
      environment.systemPackages = with pkgs; [ ponymix lxqt.pavucontrol-qt ];
    })
  ];
}
