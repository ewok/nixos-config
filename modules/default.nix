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
  options.properties.backup = {
    repo = mkOption {
      type = types.str;
      default = "";
    };
    backupPass = mkOption {
      type = types.str;
    };
    excludePaths = mkOption {
      type = types.listOf types.str;
      default = [];
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
    ssh.config = mkOption {
      type = types.lines;
      default = "";
    };
    displayProfiles = mkOption {
      type = types.lines;
      default = "";
    };
    latitude = mkOption {
      type = types.str;
    };
    longitude = mkOption {
      type = types.str;
    };
    # email.accounts = mkOption {
    #   type = types.attrsOf (types.submodule mailAccountOpts);
    #   default = { };
    # };
  };

  imports = [
    ./backup
    ./base
    ./bin
    ./communication
    ./dev
    ./gui
    ./mail
    ./misc
    ./printer
    ./system
  ];
}
