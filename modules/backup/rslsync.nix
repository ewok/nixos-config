{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.backup.rslsync;
  backup = config.modules.backup;
  username = config.properties.user.name;
  deviceName = config.properties.device.name;
  homeDirectory = config.home-manager.users.${username}.home.homeDirectory;
in
{
  options.modules.backup = {
    rslsync = {
      enable = mkEnableOption  "Enable rslsync.";
      deviceName = mkOption {
        type = types.str;
        default = "${deviceName}";
        description = "Device name.";
      };
      port = mkOption {
        type = types.int;
        default = 0;
        description = "Listening port. 0 - random.";
      };
      dirWhitelist = mkOption {
        type = types.listOf types.str;
        default = [ "" ];
        description = "List of directories allowed to sync.";
      };
      httpListenAddr = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "HTTP address to bind to.";
      };
      httpListenPort = mkOption {
        type = types.int;
        default = 8888;
        description = "HTTP port to bind to.";
      };
      httpLogin = mkOption {
        type = types.str;
        default = "";
        description = "HTTP web login username.";
      };
      httpPass = mkOption {
        type = types.str;
        default = "";
        description = "HTTP web login password.";
      };
      downloadLimit = mkOption {
        type = types.int;
        default = 0;
        description = "Download speed limit. 0 - no limits.";
      };
      uploadLimit = mkOption {
        type = types.int;
        default = 0;
        description = "Upload speed limit. 0 - no limits.";
      };
    };
  };

  config = mkIf (cfg.enable && backup.enable) {
    services.resilio = {
      enable = true;
      deviceName = cfg.deviceName;
      listeningPort = cfg.port;
      checkForUpdates = true;
      downloadLimit = cfg.downloadLimit;
      uploadLimit = cfg.uploadLimit;
      httpListenAddr = cfg.httpListenAddr;
      httpListenPort = cfg.httpListenPort;
      enableWebUI = true;
      httpLogin = cfg.httpLogin;
      httpPass = cfg.httpPass;
      directoryRoot = "${homeDirectory}";
    };

  };
}
