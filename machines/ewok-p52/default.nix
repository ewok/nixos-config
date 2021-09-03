{ config, inputs, lib, pkgs, ... }:
let
  properties = config.properties;
  username = config.properties.user.name;
  homeDirectory = config.home-manager.users.${username}.home.homeDirectory;
  homeDisplay = {
        fingerprint = {
          HDMI-0 = "00ffffffffffff0010acf54142524442091f0103803c2278eab9a5a356509f260e5054a54b00714f8180a9c0d1c00101010101010101023a801871382d40582c450056502100001e000000ff00375756355138330a2020202020000000fc0044454c4c205332373231480a20000000fd00304b1e5312000a202020202020011302032bf14f90050403020716010611121513141f230907078301000065030c001000681a00000101304be62a4480a0703827403020350056502100001a011d8018711c1620582c250056502100009e011d007251d01e206e28550056502100001e8c0ad08a20e02d10103e9600565021000018000000000000000000000000f0";
          DP-0 = "00ffffffffffff00220e483600000000251d0103805021782a4784aa524da026115054a54b00d1c0a9c081c0b3009500810081800101e77c70a0d0a0295030203a00204f3100001a000000fd001e4c1e5e22000a202020202020000000fc0048502045333434630a20202020000000ff00334351393337324b50480a20200140020322b14a901f041302031112015a67030c001000003c67d85dc401448000e2006b9f3d70a0d0a0155030203a00204f3100001a565e00a0a0a0295030203500204f3100001a483f403062b0324040c01300204f3100001e7d4b80a072b02d4088c83600204f3100001c023a801871382d40582c4500204f3100001e0000009a";
        };
        config = {
          DP-0 = {
            enable = true;
            crtc = 0;
            gamma = "1.0:1.0:1.0";
            mode = "3440x1440";
            position = "0x0";
            primary = true;
            rate = "60.00";
          };
          HDMI-0 = {
            enable = true;
            crtc = 2;
            gamma = "1.0:1.0:1.0";
            mode = "1920x1080";
            position = "3440x0";
            rate = "60.00";
          };
        };
        hooks = {
          postswitch = ''
            echo "Xft.dpi: 110" | xrdb -merge
            xrandr --output HDMI-0 --scale 1.25x1.25 --mode 1920x1080
            i3-msg restart
          '';
        };
      };
  laptopDisplay = {
        fingerprint = {
          eDP-1-1 = "00ffffffffffff0009e59207000000002c1b0104a5221378021bb0a658559d260e5054000000010101010101010101010101010101019c3b803671383c403020360058c21000001aa82f803671383c403020360058c21000001a000000fe00424f452043510a202020202020000000fe004e5631353646484d2d4e36310a00ed";
        };
        config = {
          eDP-1-1 = {
            enable = true;
            gamma = "1.0:1.0:1.0";
            mode = "1920x1080";
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

  home-manager.users.${properties.user.name} = {
    home.backup.enable = true;
    imports = [
      ../../home
    ];
  };

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
      home.fingerprint = lib.mkMerge [
        homeDisplay.fingerprint
        laptopDisplay.fingerprint
      ];
      home.config = lib.mkMerge [
        homeDisplay.config
        laptopDisplay.config
        {
          eDP-1-1 = {
            position = "5840x0";
          };
        }
      ];
      home.hooks = homeDisplay.hooks;

      laptop = laptopDisplay;
      home2 = homeDisplay;
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
