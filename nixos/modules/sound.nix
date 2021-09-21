{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.nixos.system.sound;
  username = config.nixos.username;
in
{
  options.nixos.system.sound = {
    enable = mkEnableOption "Enable sound.";
    pulse.enable = mkEnableOption "Enable pulse audio.";
    sof.enable = mkEnableOption "Enable sof-firmware.";
  };

  config = mkMerge [
    (
      mkIf cfg.enable {
        users.users.${username}.extraGroups = [ "audio" "jackaudio" ];

        sound.enable = true;
        hardware = {
          enableAllFirmware = true;
          enableRedistributableFirmware = true;
        };
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

      }
    )
    (
      mkIf (cfg.enable && cfg.pulse.enable) {
        users.users.${username}.extraGroups = [ "pulse" ];
        nixpkgs.config.pulseaudio = true;
        hardware = {
          pulseaudio = {
            enable = true;
            support32Bit = true;
            package = pkgs.pulseaudioFull;
            extraModules = [ pkgs.pulseaudio-modules-bt ];
            # systemWide = true;
            daemon.config = { flat-volumes = "no"; };
            extraConfig = ''
              load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1
              load-module module-alsa-sink   device=hw:0,0 channels=4
              load-module module-alsa-source device=hw:0,6 channels=4
              load-module module-switch-on-connect
            '';
          };
        };

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
