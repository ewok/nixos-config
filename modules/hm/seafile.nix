{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf types mkOption;
  cfg = config.opt.seafile;
in
{
  options.opt.seafile = {
    enable = mkEnableOption "seafile";
    # httpListenAddr = mkOption
    #   {
    #     type = types.str;
    #     default = "0.0.0.0";
    #   };
    # httpListenPort = mkOption
    #   {
    #     type = types.int;
    #     default = 8888;
    #   };
    # deviceName = mkOption
    #   {
    #     type = types.str;
    #     default = "Resilio Sync";
    #   };
  };

  config = mkIf cfg.enable {

    home.packages = [
      pkgs.seafile-shared
    ];

    systemd.user.services = {
      seafile = {
        Unit = {
          Description = "Seafile Sync Service";
          After = [ "network.target" "local-fs.target" ];
        };
        Service = {
          Restart = "on-abort";
          UMask = "0002";
          ExecStart = "${pkgs.seafile-shared}/bin/seafile-cli start";
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
      };
    };

  };
}
