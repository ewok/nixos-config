{ config, lib, pkgs, ... }:

with lib;

{
  options.properties.defaultTerminal = mkOption {
    description = "Default terminal";
    type = types.str;
    default = "alacritty";
  };
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
  options.properties.work_account = {
    enable = mkEnableOption "Enable work accoung";
    email = mkOption {
      description = "Email.";
      type = types.str;
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
  options.properties.theme = {
    colors = {
      background = mkOption {
        type = types.str;
        default = "";
      };
      foreground = mkOption {
        type = types.str;
        default = "";
      };
      text = mkOption {
        type = types.str;
        default = "";
      };
      cursor = mkOption {
        type = types.str;
        default = "";
      };
      # Black
      color0 = mkOption {
        type = types.str;
        default = "";
      };
      # Red
      color1 = mkOption {
        type = types.str;
        default = "";
      };
      # Green
      color2 = mkOption {
        type = types.str;
        default = "";
      };
      # Yellow
      color3 = mkOption {
        type = types.str;
        default = "";
      };
      # Blue
      color4 = mkOption {
        type = types.str;
        default = "";
      };
      # Magenta
      color5 = mkOption {
        type = types.str;
        default = "";
      };
      # Cyan
      color6 = mkOption {
        type = types.str;
        default = "";
      };
      # White
      color7 = mkOption {
        type = types.str;
        default = "";
      };
      # Br Black
      color8 = mkOption {
        type = types.str;
        default = "";
      };
      # Br Red
      color9 = mkOption {
        type = types.str;
        default = "";
      };
      # Br Green
      color10 = mkOption {
        type = types.str;
        default = "";
      };
      # Br Yellow
      color11 = mkOption {
        type = types.str;
        default = "";
      };
      # Br Blue
      color12 = mkOption {
        type = types.str;
        default = "";
      };
      # Br Magenta
      color13 = mkOption {
        type = types.str;
        default = "";
      };
      # Br Cyan
      color14 = mkOption {
        type = types.str;
        default = "";
      };
      # Br White
      color15 = mkOption {
        type = types.str;
        default = "";
      };
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
    ./misc
    ./system
  ];
}
