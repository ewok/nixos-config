{ config, inputs, lib, pkgs, ... }:
let
  properties = config.properties;
  username = config.properties.user.name;
  homeDirectory = config.home-manager.users.${username}.home.homeDirectory;
in
{
  imports = [
    ./secrets.nix
    ../common.nix
    ../secrets.nix
    ../../modules
    ./configuration.nix
    "${inputs.nixos-hardware}/common/pc/ssd"
  ];

  time.timeZone = properties.timezone;

  # Enabled by default
  modules.base.enable = true;

  modules.backup = {
    enable = true;
    rslsync = {
      enable = true;
      enableWebUI = true;
      httpListenAddr = "127.0.0.1";
      httpListenPort = 8888;
    };

    restic = {
      repo = properties.backup.repo;
      excludePaths = properties.backup.excludePaths;
      pass = properties.backup.backupPass;
      paths = properties.backup.paths;
    };
  };

  modules.dev = {
    enable = true;
    docker.enable = true;
    docker.autoPrune = true;
    k8s.enable = true;
    java.enable = true;
    virtualisation.enableVirtualbox = true;
    terraform.enable = true;
    aws.enable = true;
    emacs.enable = true;
  };

  modules.gui = {
    enable = true;
    fonts = {
      dpi = 110;
    };
    displayProfiles = builtins.toJSON {
      "home-dp1" = {
        fingerprint = {
          DP-1 = "00ffffffffffff00220e483600000000251d0103805021782a4784aa524da026115054a54b00d1c0a9c081c0b3009500810081800101e77c70a0d0a0295030203a00204f3100001a000000fd001e4c1e5e22000a202020202020000000fc0048502045333434630a20202020000000ff00334351393337324b50480a20200140020322b14a901f041302031112015a67030c001000003c67d85dc401448000e2006b9f3d70a0d0a0155030203a00204f3100001a565e00a0a0a0295030203500204f3100001a483f403062b0324040c01300204f3100001e7d4b80a072b02d4088c83600204f3100001c023a801871382d40582c4500204f3100001e0000009a";
        };
        config = {
          DP-1 = {
            enable = true;
            crtc = 0;
            primary = true;
            position = "0x0";
            mode = "3440x1440";
            gamma = "1.0:1.0:1.0";
            rate = "60.00";
          };
        };
        # hooks.postswitch = readFile ./work-postswitch.sh;
      };
      "home-hdm1" = {
        fingerprint = {
          HDMI-0 = "00ffffffffffff00220e483600000000251d0103805021782a4784aa524da026115054a54b00d1c0a9c081c0b3009500810081800101e77c70a0d0a0295030203a00204f3100001a000000fd001e4c1e5e22000a202020202020000000fc0048502045333434630a20202020000000ff00334351393337324b50480a20200140020322b14a901f041302031112015a67030c001000003c67d85dc401448000e2006b9f3d70a0d0a0155030203a00204f3100001a565e00a0a0a0295030203500204f3100001a483f403062b0324040c01300204f3100001e7d4b80a072b02d4088c83600204f3100001c023a801871382d40582c4500204f3100001e0000009a";
        };
        config = {
          HDMI-0 = {
            enable = true;
            crtc = 0;
            primary = true;
            position = "0x0";
            mode = "3440x1440";
            gamma = "1.0:1.0:1.0";
            rate = "60.00";
          };
        };
        # hooks.postswitch = readFile ./work-postswitch.sh;
      };
      "home-both" = {
        fingerprint = {
          eDP-1-1 = "00ffffffffffff0009e59207000000002c1b0104a5221378021bb0a658559d260e5054000000010101010101010101010101010101019c3b803671383c403020360058c21000001aa82f803671383c403020360058c21000001a000000fe00424f452043510a202020202020000000fe004e5631353646484d2d4e36310a00ed";
          DP-1 = "00ffffffffffff00220e483600000000251d0103805021782a4784aa524da026115054a54b00d1c0a9c081c0b3009500810081800101e77c70a0d0a0295030203a00204f3100001a000000fd001e4c1e5e22000a202020202020000000fc0048502045333434630a20202020000000ff00334351393337324b50480a20200140020322b14a901f041302031112015a67030c001000003c67d85dc401448000e2006b9f3d70a0d0a0155030203a00204f3100001a565e00a0a0a0295030203500204f3100001a483f403062b0324040c01300204f3100001e7d4b80a072b02d4088c83600204f3100001c023a801871382d40582c4500204f3100001e0000009a";
        };
        config = {
          eDP-1-1 = {
            enable = true;
            gamma = "1.0:1.0:1.0";
            mode = "1920x1080";
            position = "3440x0";
            rate = "60.00";
          };
          DP-1 = {
            enable = true;
            crtc = 0;
            primary = true;
            position = "0x0";
            mode = "3440x1440";
            gamma = "1.0:1.0:1.0";
            rate = "60.00";
          };
        };
        # hooks.postswitch = readFile ./work-postswitch.sh;
      };
      "laptop" = {
        fingerprint = {
          eDP-1-1 = "00ffffffffffff0009e59207000000002c1b0104a5221378021bb0a658559d260e5054000000010101010101010101010101010101019c3b803671383c403020360058c21000001aa82f803671383c403020360058c21000001a000000fe00424f452043510a202020202020000000fe004e5631353646484d2d4e36310a00ed";
        };
        config = {
          eDP-1-1 = {
            enable = true;
            gamma = "1.0:1.0:1.0";
            mode = "1920x1080";
            position = "3440x0";
            rate = "60.00";
          };
        };
      };
    };
    longitude = properties.longitude;
    latitude = properties.latitude;
    day = 5000;
    night = 3500;

    office.enable = true;
  };

  modules.base.ssh.config = properties.ssh.config;

  # modules.system.sudo.askPass = false;

  modules.system.sound.enable = true;
  modules.system.sound.pulse.enable = true;
  modules.system.printing.enable = true;

  modules.communication = {
    enable = true;
    enableTwitter = true;
    enableElement = false;
    enableSignal = false;
    enableSkype = false;
    enableSlack = true;
    enableTelegram = true;
    enableZoom = false;
    enableDiscord = false;
  };

  modules.system.powermanagement.enable = true;

  modules.mail = {
    enable = true;
    thunderbird.enable = true;
  };

  modules.gaming.enable = false;
  modules.misc.android.enable = true;
}
