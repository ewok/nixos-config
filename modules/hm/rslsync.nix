{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf types mkOption;
  inherit (pkgs) fetchurl stdenv autoPatchelfHook libxcrypt-legacy;

  cfg = config.opt.rslsync;

  # https://forum.resilio.com/tags/build/
  resilioVersion = "3.0.1.1414";
  packs = {
    resilio-sync = stdenv.mkDerivation
      {
        pname = "resilio-sync";
        version = resilioVersion;

        src = {
          x86_64-linux = fetchurl {
            url = "https://download-cdn.resilio.com/${resilioVersion}/linux/x64/0/resilio-sync_x64.tar.gz";
            sha256 = "sha256-WJi9KVGqI0oAaBaldcVGuQmyXuqaCFFm9VyI6PB4CkA=";
          };

          i686-linux = fetchurl {
            url = "https://download-cdn.resilio.com/${resilioVersion}/linux/i386/0/resilio-sync_i386.tar.gz";
            # sha256 = "sha256-tWwb9DHLlXeyimzyo/yxVKqlkP3jlAxT2Yzs6h2bIgs=";
          };

          aarch64-linux = fetchurl {
            url = "https://download-cdn.resilio.com/${resilioVersion}/linux/arm64/0/resilio-sync_arm64.tar.gz";
            sha256 = "sha256-I/9eQjqYYf7upejHVOVbHEM9/iXMbIHkAb/S54pK3sQ=";
          };
        }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

        dontStrip = true; # Don't strip, otherwise patching the rpaths breaks
        sourceRoot = ".";

        nativeBuildInputs = [
          autoPatchelfHook
        ];

        buildInputs = [
          stdenv.cc.libc
          libxcrypt-legacy
        ];

        installPhase = ''
          install -D rslsync "$out/bin/rslsync"
        '';

      };
  };


  # home.file."resilio.conf" = {
  #   enable = true;
  #   target = ".config/rslsync/rslsync.conf";
  #   text = ''
  #     {
  #       "device_name" : "${cfg.deviceName}",
  #       "storage_path" : "${config.xdg.configHome}/rslsync",
  #       "pid_file" : "${config.xdg.configHome}/rslsync/resilio.pid",
  #       "use_upnp" : true,
  #       "download_limit" : 0,
  #       "upload_limit" : 0,
  #       "directory_root" : "${config.home.homeDirectory}/",
  #       "webui" :
  #       {
  #         "listen": "${cfg.httpListenAddr}:${toString(cfg.httpListenPort)}"
  #       }
  #     }'';
  # };
  configFile = pkgs.writeText "config.json" (builtins.toJSON ({
    device_name = cfg.deviceName;
    storage_path = "${config.xdg.configHome}/rslsync";
    listening_port = 0;
    use_gui = true;
    check_for_updates = false;
    use_upnp = true;
    download_limit = 0;
    upload_limit = 0;
    webui = { listen = "${cfg.httpListenAddr}:${toString cfg.httpListenPort}"; };
  }));
in
{
  options.opt.rslsync = {
    enable = mkEnableOption "rslsync";
    httpListenAddr = mkOption
      {
        type = types.str;
        default = "0.0.0.0";
      };
    httpListenPort = mkOption
      {
        type = types.int;
        default = 8888;
      };
    deviceName = mkOption
      {
        type = types.str;
        default = "Resilio Sync";
      };
  };

  config = mkIf cfg.enable {

    home.packages = [
      packs.resilio-sync
    ];

    systemd.user.services = {
      resilio = {
        Unit = {
          Description = "Resilio Sync Service";
          After = [ "network.target" "local-fs.target" ];
        };
        Service = {
          Restart = "on-abort";
          UMask = "0002";
          ExecStart = "${packs.resilio-sync}/bin/rslsync --nodaemon --config ${configFile}";
          # ExecStartPre = ''${pkgs.bash}/bin/bash -c "${pkgs.coreutils}/bin/mkdir -p '${cfg.storagePath}'"'';
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
      };
    };

  };
}
