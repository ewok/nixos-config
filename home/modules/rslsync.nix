{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.home.backup.rslsync;
  backup = config.home.backup;

  # Resilio part
  resilioSync = pkgs.resilio-sync;

  sharedFoldersRecord = map (
    entry: {
      secret = entry.secret;
      dir = entry.directory;

      use_relay_server = entry.useRelayServer;
      use_tracker = entry.useTracker;
      use_dht = entry.useDHT;

      search_lan = entry.searchLAN;
      use_sync_trash = entry.useSyncTrash;
      known_hosts = entry.knownHosts;
    }
  ) cfg.sharedFolders;

  configFile = pkgs.writeText "config.json" (
    builtins.toJSON (
      {
        device_name = cfg.deviceName;
        storage_path = cfg.storagePath;
        listening_port = cfg.listeningPort;
        use_gui = false;
        check_for_updates = cfg.checkForUpdates;
        use_upnp = cfg.useUpnp;
        download_limit = cfg.downloadLimit;
        upload_limit = cfg.uploadLimit;
        lan_encrypt_data = cfg.encryptLAN;
      } // optionalAttrs (cfg.directoryRoot != "") { directory_root = cfg.directoryRoot; }
      // optionalAttrs cfg.enableWebUI {
        webui = { listen = "${cfg.httpListenAddr}:${toString cfg.httpListenPort}"; } // (optionalAttrs (cfg.httpLogin != "") { login = cfg.httpLogin; }) // (optionalAttrs (cfg.httpPass != "") { password = cfg.httpPass; }) // (optionalAttrs (cfg.apiKey != "") { api_key = cfg.apiKey; });
      } // optionalAttrs (sharedFoldersRecord != []) {
        shared_folders = sharedFoldersRecord;
      }
    )
  );

in
{
  config = mkIf (cfg.enable && backup.enable) {

    assertions =
      [
        {
          assertion = cfg.deviceName != "";
          message = "Device name cannot be empty.";
        }
        {
          assertion = cfg.enableWebUI -> cfg.sharedFolders == [];
          message = "If using shared folders, the web UI cannot be enabled.";
        }
        {
          assertion = cfg.apiKey != "" -> cfg.enableWebUI;
          message = "If you're using an API key, you must enable the web server.";
        }
      ];

    # networking.firewall.extraCommands = "iptables -A nixos-fw -p tcp -m tcp --dport ${toString cfg.listeningPort} -j nixos-fw-accept";

    xdg.dataFile."rslsync/.keep".text = "";

    home.packages = with pkgs; [
      resilioSync
    ];

    systemd.user.services = {
      rslsync = {
        Unit = {
          Description =
            "Resilio Sync Service";
          After = [ "network.target" ];
        };

        Service = {
          ExecStart = ''
            ${resilioSync}/bin/rslsync --nodaemon --config ${configFile}
          '';
          Restart = "on-failure";
          SuccessExitStatus = [ 3 4 ];
          RestartForceExitStatus = [ 3 4 ];
        };

        Install = { WantedBy = [ "default.target" ]; };
      };
    };
  };
}
