{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.system.powermanagement;
  username = config.properties.user.name;

  powertop = pkgs.writeShellScriptBin "powertop" ''
    sudo ${pkgs.powertop}/bin/powertop
  '';

  hibernateEnvironment = {
    HIBERNATE_SECONDS = "3600";
    HIBERNATE_LOCK = "/var/run/autohibernate.lock";
  };
in
  {
    options.modules.system.powermanagement = {
      enable = mkEnableOption "Enable powermanagement.";
    # Buggy on P52
    powertop.enable = mkEnableOption "Enable powertop.";
    governor = mkOption {
      type = types.str;
      default = "powersave";
      description = "CPU governor.";
    };
    suspendHibernate.enable = mkEnableOption "Suspend and hibernate.";
  };

  config = mkMerge [
    (mkIf cfg.enable {
      powerManagement = {
        enable = true;
        powertop.enable = cfg.powertop.enable;
        cpuFreqGovernor = lib.mkDefault cfg.governor;
      };
      services.tlp.enable = true;
      services.logind = {
        lidSwitchDocked = "ignore";
        lidSwitchExternalPower = "ignore";
        lidSwitch = "suspend";
      };

      services.logind.extraConfig = ''
        HandlePowerKey=ignore
        HandleSuspendKey=suspend
        HandleHibernateKey=ignore
      '';

      home-manager.users.${username} = {
        home.packages = [ powertop ];
      };

      # Backlight
      programs.light.enable = true;
      services.actkbd = {
        enable = true;
        bindings = [
          { keys = [ 225 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -A 5"; }
          { keys = [ 224 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -U 5"; }
        ];
      };
      users.users.${username}.extraGroups = [ "video" ];
    })

    (mkIf ( cfg.enable && cfg.suspendHibernate.enable ) {

      systemd.services."awake-after-suspend-for-a-time" = {
        description = "Sets up the suspend so that it'll wake for hibernation";
        wantedBy = [ "suspend.target" ];
        before = [ "systemd-suspend.service" ];
        environment = hibernateEnvironment;
        script = ''
          curtime=$(date +%s)
          echo "$curtime $1" >> /tmp/autohibernate.log
          echo "$curtime" > $HIBERNATE_LOCK
          ${pkgs.utillinux}/bin/rtcwake -m no -s $HIBERNATE_SECONDS
        '';
        serviceConfig.Type = "simple";
      };
      systemd.services."hibernate-after-recovery" = {
        description = "Hibernates after a suspend recovery due to timeout";
        wantedBy = [ "suspend.target" ];
        after = [ "systemd-suspend.service" ];
        environment = hibernateEnvironment;
        script = ''
          curtime=$(date +%s)
          sustime=$(cat $HIBERNATE_LOCK)
          rm $HIBERNATE_LOCK
          if [ $(($curtime - $sustime)) -ge $HIBERNATE_SECONDS ] ; then
          systemctl hibernate
          else
          ${pkgs.utillinux}/bin/rtcwake -m no -s 1
          fi
        '';
        serviceConfig.Type = "simple";
      };
    })
  ];
}

