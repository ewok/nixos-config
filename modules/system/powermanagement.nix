{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.system.powermanagement;
  username = config.properties.user.name;
in
{
  options.modules.system.powermanagement = {
    enable = mkEnableOption "Enable powermanagement.";
    governor = mkOption {
      type = types.str;
      default = "powersave";
      description = "CPU governor.";
    };
  };

  config = mkIf cfg.enable {
    powerManagement = {
      enable = true;
      powertop.enable = true;
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
    # TODO: Experimental
    # hardware.nvidia.powerManagement.enable = true;
  };
}

