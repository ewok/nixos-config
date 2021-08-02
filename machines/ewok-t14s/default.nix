{ config, inputs, lib, pkgs, ... }:
let
  properties = config.properties;
in
{
  imports = [
    ./secrets.nix
    ../common.nix
    ../secrets.nix
    ../../modules
    ./configuration.nix
    "${inputs.nixos-hardware}/common/pc/ssd"
    "${inputs.nixos-hardware}/lenovo/thinkpad/t14s"
  ];

  time.timeZone = properties.timezone;

  # Enabled by default
  modules.base.enable = true;

  modules.backup.enable = true;
  modules.backup.rslsync = {
    enable = true;
    enableWebUI = true;
    httpListenAddr = "127.0.0.1";
    httpListenPort = 8888;
  };
  modules.backup.restic = {
    repo = properties.backup.repo;
    excludePaths = properties.backup.excludePaths;
    pass = properties.backup.backupPass;
    paths = properties.backup.paths;
  };

  modules.dev = {
    enable = true;
    docker.enable = true;
    docker.autoPrune = true;
    k8s.enable = true;
    virtualisation.enableVirtualbox = true;
    terraform.enable = true;
    aws.enable = true;
    emacs.enable = true;
  };

  # environment.variables = {
  #   GDK_SCALE = "1.1";
  #   GDK_DPI_SCALE = "1.1";
  #   _JAVA_OPTIONS = "-Dsun.java2d.uiScale=1.1";
  # };

  modules.gui = {
    enable = true;
    fonts = {
      dpi = 115;
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
            gamma = "1.389:1.0:0.714";
            rate = "60.00";
          };
        };
        hooks = {
          postswitch = ''
            echo "Xft.dpi: 110" | xrdb -merge
            i3-msg restart
          '';
        };
      };
      "home-hdm1" = {
        fingerprint = {
          HDMI-2 = "00ffffffffffff00220e483600000000251d0103805021782a4784aa524da026115054a54b00d1c0a9c081c0b3009500810081800101e77c70a0d0a0295030203a00204f3100001a000000fd001e4c1e5e22000a202020202020000000fc0048502045333434630a20202020000000ff00334351393337324b50480a20200140020322b14a901f041302031112015a67030c001000003c67d85dc401448000e2006b9f3d70a0d0a0155030203a00204f3100001a565e00a0a0a0295030203500204f3100001a483f403062b0324040c01300204f3100001e7d4b80a072b02d4088c83600204f3100001c023a801871382d40582c4500204f3100001e0000009a";
        };
        config = {
          HDMI-2 = {
            enable = true;
            crtc = 0;
            primary = true;
            position = "0x0";
            mode = "3440x1440";
            gamma = "1.389:1.0:0.714";
            rate = "60.00";
            # transform = [
            #   [1.1 0.0 0.0]
            #   [0.0 1.1 0.0]
            #   [0.0 0.0 1.0]
            # ];
          };
        };
        hooks = {
          postswitch = ''
            echo "Xft.dpi: 110" | xrdb -merge
            i3-msg restart
          '';
        };
      };

      "dacha-ext" = {
        fingerprint = {
          DP-1 = "00ffffffffffff0010acf64142524442091f0103803c2278eab9a5a356509f260e5054a54b00714f8180a9c0d1c00101010101010101023a801871382d40582c450056502100001e000000ff00375756355138330a2020202020000000fc0044454c4c205332373231480a20000000fd00304b1e5312000a202020202020011202032bf14f90050403020716010611121513141f230907078301000065030c002000681a00000100304be62a4480a0703827403020350056502100001a011d8018711c1620582c250056502100009e011d007251d01e206e28550056502100001e8c0ad08a20e02d10103e9600565021000018000000000000000000000000e1";
        };
        config = {
          DP-1 = {
            enable = true;
            crtc = 1;
            primary = true;
            position = "0x0";
            mode = "1920x1080";
            gamma = "1.0:0.909:0.833";
            rate = "60.00";
          };
        };
        hooks = {
          postswitch = ''
            echo "Xft.dpi: 87" | xrdb -merge
            i3-msg restart
          '';
        };
      };

      "home-both" = {
        fingerprint = {
          eDP-1 = "00ffffffffffff0006af3d5700000000001c0104a51f1178022285a5544d9a270e505400000001010101010101010101010101010101b43780a070383e401010350035ae100000180000000f0000000000000000000000000020000000fe0041554f0a202020202020202020000000fe004231343048414e30352e37200a0070";
          DP-1 = "00ffffffffffff00220e483600000000251d0103805021782a4784aa524da026115054a54b00d1c0a9c081c0b3009500810081800101e77c70a0d0a0295030203a00204f3100001a000000fd001e4c1e5e22000a202020202020000000fc0048502045333434630a20202020000000ff00334351393337324b50480a20200140020322b14a901f041302031112015a67030c001000003c67d85dc401448000e2006b9f3d70a0d0a0155030203a00204f3100001a565e00a0a0a0295030203500204f3100001a483f403062b0324040c01300204f3100001e7d4b80a072b02d4088c83600204f3100001c023a801871382d40582c4500204f3100001e0000009a";
        };
        config = {
          eDP-1 = {
            enable = true;
            gamma = "1.0:0.769:0.588";
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
            gamma = "1.389:1.0:0.714";
            rate = "60.00";
          };
        };
        hooks = {
          postswitch = ''
            echo "Xft.dpi: 110" | xrdb -merge
            i3-msg restart
          '';
        };
      };
      "laptop" = {
        fingerprint = {
          eDP-1 = "00ffffffffffff0006af3d5700000000001c0104a51f1178022285a5544d9a270e505400000001010101010101010101010101010101b43780a070383e401010350035ae100000180000000f0000000000000000000000000020000000fe0041554f0a202020202020202020000000fe004231343048414e30352e37200a0070";
        };
        config = {
          eDP-1 = {
            enable = true;
            gamma = "1.0:0.769:0.588";
            mode = "1920x1080";
            position = "3440x0";
            rate = "60.00";
          };
        };
        hooks = {
          postswitch = ''
            echo "Xft.dpi: 115" | xrdb -merge
            i3-msg restart
          '';
        };
      };
    };
    longitude = properties.longitude;
    latitude = properties.latitude;
    day = 5500;
    night = 3500;

    office.enable = true;
  };

  modules.base.ssh.config = properties.ssh.config;

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
    enableZoom = true;
    enableDiscord = true;
  };

  modules.system.powermanagement = {
    enable = true;
    powertop.enable = true;
    governor = "powersave";
    suspendHibernate.enable = true;
  };

  modules.mail = {
    enable = true;
    thunderbird.enable = true;
  };

  # modules.antivirus = {
  #   enable = true;
  # };
}
