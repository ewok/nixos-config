{ config, lib, pkgs, ... }:

with lib;

{
  options.properties.user = {
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
  };
  options.properties.device = {
    name = mkOption {
      description = "Device name.";
      type = types.str;
    };
  };
  options.properties = {
    timezone = mkOption {
      description = "Timezone.";
      type = types.str;
    };
  };

  imports = [
    ./backup
    ./base
    ./bin
    ./communication
    ./dev
    ./gui
    ./mail
    ./printer
    ./system
  ];
  # add user to groups wheel, docker, rfkill
}

