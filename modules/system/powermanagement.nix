{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.system.powermanagement;
  username = config.properties.user.name;

  powertop = pkgs.writeShellScriptBin "powertop" ''
    sudo ${pkgs.powertop}/bin/powertop
  '';
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
  };

  config = mkIf cfg.enable {
    powerManagement = {
      enable = true;
      powertop.enable = cfg.powertop.enable;
      cpuFreqGovernor = lib.mkDefault cfg.governor;
    };
    services.tlp.enable = true;
    services.illum.enable = true;
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
    # TODO: Experimental
    # hardware.nvidia.powerManagement.enable = true;
  };
}

