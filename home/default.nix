{ config, lib, ... }:
with lib;
{
  imports = map (n: ./modules + "/${n}") (builtins.attrNames (builtins.readDir ./modules));

  options.home = {

    user = {
      name = mkOption {
        description = "Username.";
        type = types.str;
      };
      email = mkOption {
        description = "Email.";
        type = types.str;
      };
      group = mkOption {
        description = "Group.";
        type = types.str;
        default = "users";
      };
      fullName = mkOption {
        description = "Full name.";
        type = types.str;
      };
      work = {
        enable = mkEnableOption "Enable work accoung";
        email = mkOption {
          description = "Email.";
          type = types.str;
        };
        fullName = mkOption {
          description = "Full name.";
          type = types.str;
        };
        workProjectDir = mkOption {
          description = "Directiry with work projects.";
          type = types.str;
          default = "~/projects/work";
        };
      };
    };

    device = {
      name = mkOption {
        description = "Device name.";
        type = types.str;
      };
    };

    timezone = mkOption {
      description = "Timezone.";
      type = types.str;
    };

    terminal = mkOption {
      description = "Default terminal";
      type = types.str;
    };

    latitude = mkOption {
      type = types.str;
    };
    longitude = mkOption {
      type = types.str;
    };
    day = mkOption {
      type = types.int;
    };
    night = mkOption {
      type = types.int;
    };

    theme = {
      fonts = {
        dpi = mkOption {
          type = types.int;
          default = 115;
          description = "Font DPI.";
        };
        regularFont = mkOption {
          type = types.str;
          default = "FiraCode Nerd Font";
          description = "Default regular font.";
        };
        regularFontSize = mkOption {
          type = types.int;
          default = 10;
          description = "Default regular font size.";
        };
        monospaceFont = mkOption {
          type = types.str;
          default = "FiraCode Nerd Font Mono";
          description = "Default monospace font.";
        };
        monospaceFontSize = mkOption {
          type = types.int;
          default = 13;
          description = "Default monospace font size.";
        };
        consoleFont = mkOption {
          type = types.str;
          default = "Lat2-Terminus16";
          description = "Default console font.";
        };
      };

      colors = {
        background = mkOption {
          type = types.str;
        };
        foreground = mkOption {
          type = types.str;
        };
        text = mkOption {
          type = types.str;
        };
        cursor = mkOption {
          type = types.str;
        };
        # Black
        color0 = mkOption {
          type = types.str;
        };
        # Red
        color1 = mkOption {
          type = types.str;
        };
        # Green
        color2 = mkOption {
          type = types.str;
        };
        # Yellow
        color3 = mkOption {
          type = types.str;
        };
        # Blue
        color4 = mkOption {
          type = types.str;
        };
        # Magenta
        color5 = mkOption {
          type = types.str;
        };
        # Cyan
        color6 = mkOption {
          type = types.str;
        };
        # White
        color7 = mkOption {
          type = types.str;
        };
        # Br Black
        color8 = mkOption {
          type = types.str;
        };
        # Br Red
        color9 = mkOption {
          type = types.str;
        };
        # Br Green
        color10 = mkOption {
          type = types.str;
        };
        # Br Yellow
        color11 = mkOption {
          type = types.str;
        };
        # Br Blue
        color12 = mkOption {
          type = types.str;
        };
        # Br Magenta
        color13 = mkOption {
          type = types.str;
        };
        # Br Cyan
        color14 = mkOption {
          type = types.str;
        };
        # Br White
        color15 = mkOption {
          type = types.str;
        };
      };
    };

    base = {
      ssh = {
        config = mkOption {
          type = types.lines;
          default = "{}";
        };
      };
    };

    backup = {
      enable = mkEnableOption "Enable backup soft and settings.";

      # paths = mkOption {
      #   description = "Backup directories.";
      #   type = types.listOf types.str;
      # };
      # repo = mkOption {
      #   type = types.str;
      #   default = "";
      # };
      # backupPass = mkOption {
      #   type = types.str;
      # };
      # excludePaths = mkOption {
      #   type = types.listOf types.str;
      #   default = [];
      # };

      rslsync = {

        enable = mkOption {
          type = types.bool;
          default = false;
          description = ''
            If enabled, start the Resilio Sync daemon. Once enabled, you can
            interact with the service through the Web UI, or configure it in your
            NixOS configuration.
          '';
        };

        deviceName = mkOption {
          type = types.str;
          example = "Voltron";
          default = false;
          description = ''
            Name of the Resilio Sync device.
          '';
        };

        # processUser = mkOption {
        #   type = types.str;
        #   example = "user";
        #   default = username;
        #   description = ''
        #     Username to run resilio process.
        #   '';
        # };

        listeningPort = mkOption {
          type = types.int;
          default = 44600;
          example = 44444;
          description = ''
            Listening port. Defaults to 0 which randomizes the port.
          '';
        };

        checkForUpdates = mkOption {
          type = types.bool;
          default = true;
          description = ''
            Determines whether to check for updates and alert the user
            about them in the UI.
          '';
        };

        useUpnp = mkOption {
          type = types.bool;
          default = true;
          description = ''
            Use Universal Plug-n-Play (UPnP)
          '';
        };

        downloadLimit = mkOption {
          type = types.int;
          default = 0;
          example = 1024;
          description = ''
            Download speed limit. 0 is unlimited (default).
          '';
        };

        uploadLimit = mkOption {
          type = types.int;
          default = 0;
          example = 1024;
          description = ''
            Upload speed limit. 0 is unlimited (default).
          '';
        };

        httpListenAddr = mkOption {
          type = types.str;
          default = "[::1]";
          example = "0.0.0.0";
          description = ''
            HTTP address to bind to.
          '';
        };

        httpListenPort = mkOption {
          type = types.int;
          default = 9000;
          description = ''
            HTTP port to bind on.
          '';
        };

        httpLogin = mkOption {
          type = types.str;
          example = "allyourbase";
          default = "";
          description = ''
            HTTP web login username.
          '';
        };

        httpPass = mkOption {
          type = types.str;
          example = "arebelongtous";
          default = "";
          description = ''
            HTTP web login password.
          '';
        };

        encryptLAN = mkOption {
          type = types.bool;
          default = true;
          description = "Encrypt LAN data.";
        };

        enableWebUI = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Enable Web UI for administration. Bound to the specified
            <literal>httpListenAddress</literal> and
            <literal>httpListenPort</literal>.
          '';
        };

        storagePath = mkOption {
          type = types.path;
          default = "${config.xdg.dataHome}/rslsync/";
          description = ''
            Where BitTorrent Sync will store it's database files (containing
            things like username info and licenses). Generally, you should not
            need to ever change this.
          '';
        };

        apiKey = mkOption {
          type = types.str;
          default = "";
          description = "API key, which enables the developer API.";
        };

        directoryRoot = mkOption {
          type = types.str;
          default = "";
          example = "/media";
          description = "Default directory to add folders in the web UI.";
        };

        sharedFolders = mkOption {
          default = [];
          type = types.listOf (types.attrsOf types.anything);
          example =
            [
              {
                secret = "AHMYFPCQAHBM7LQPFXQ7WV6Y42IGUXJ5Y";
                directory = "/home/user/sync_test";
                useRelayServer = true;
                useTracker = true;
                useDHT = false;
                searchLAN = true;
                useSyncTrash = true;
                knownHosts = [
                  "192.168.1.2:4444"
                  "192.168.1.3:4444"
                ];
              }
            ];
          description = ''
            Shared folder list. If enabled, web UI must be
            disabled. Secrets can be generated using <literal>rslsync
            --generate-secret</literal>. Note that this secret will be
            put inside the Nix store, so it is realistically not very
            secret.

            If you would like to be able to modify the contents of this
            directories, it is recommended that you make your user a
            member of the <literal>rslsync</literal> group.

            Directories in this list should be in the
            <literal>rslsync</literal> group, and that group must have
            write access to the directory. It is also recommended that
            <literal>chmod g+s</literal> is applied to the directory
            so that any sub directories created will also belong to
            the <literal>rslsync</literal> group. Also,
            <literal>setfacl -d -m group:rslsync:rwx</literal> and
            <literal>setfacl -m group:rslsync:rwx</literal> should also
            be applied so that the sub directories are writable by
            the group.
          '';
        };
      };

    };

    communication = {
      enableTwitter = mkEnableOption "Enable Twitter.";
      enableElement = mkEnableOption "Enable Element.";
      enableSignal = mkEnableOption "Enable Signal.";
      enableSkype = mkEnableOption "Enable Skype.";
      enableSlack = mkEnableOption "Enable Slack.";
      enableTelegram = mkEnableOption "Enable Telegram.";
      enableZoom = mkEnableOption "Enable Zoom.";
      enableDiscord = mkEnableOption "Enable Discord.";
    };

    dev = {
      enable = mkEnableOption "Enable dev soft and settings.";
      aws.enable = mkEnableOption "Enable aws in dev environment.";
      docker.enable = mkEnableOption "Enable docker";
      dbtools.enable = mkEnableOption "Enable dbtools in dev environment.";
      emacs.enable = mkEnableOption "Enable emacs in dev environment.";
      go.enable = mkEnableOption "Enable go in dev environment.";
      java.enable = mkEnableOption "Enable java in dev environment.";
      k8s.enable = mkEnableOption "Enable k8s environment.";
      terraform.enable = mkEnableOption "Enable terraform in dev environment.";
    };

    gui = {
      enable = mkEnableOption "Enable backup soft and settings.";
      touchscreen = {
        enable = mkEnableOption "Support touchscreen laptop.";
        autoRotate = mkEnableOption "Enable auto-rotate.";
      };
    };

    mail = {
      enable = mkEnableOption "Enable mail soft and settings.";
      accounts = mkOption {
        type = types.attrs;
        default = {};
      };
      neomutt.enable = mkEnableOption "Enable neomutt in addition or only.";
      mailspring.enable = mkEnableOption "Enable mailspring in addition or only.";
      thunderbird.enable = mkEnableOption "Enable thunderbird in addition or only.";
    };

    sound = {
      enable = mkEnableOption "Enable sound soft and settings.";
      enableSpotify = mkEnableOption "Enable Spotify";
    };

    misc = {
      android.enable = mkEnableOption "Enable android soft.";
      books.enable = mkEnableOption "Enable books soft.";
      edu.enable = mkEnableOption "Enable edu soft.";
      gaming.enable = mkEnableOption "Enable gaming soft.";
    };
  };
}
