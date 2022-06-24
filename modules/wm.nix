{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.opt.wm;
in
{
  options.opt.wm = {
    enable = mkOption { type = types.bool; };
    username = mkOption {type = types.str;};
    fonts = {
      dpi = mkOption {
        type = types.int;
        description = "Font DPI.";
      };
      regularFont = mkOption {
        type = types.str;
        description = "Default regular font.";
      };
      regularFontSize = mkOption {
        type = types.int;
        description = "Default regular font size.";
      };
      monospaceFont = mkOption {
        type = types.str;
        description = "Default monospace font.";
      };
      monospaceFontSize = mkOption {
        type = types.int;
        description = "Default monospace font size.";
      };
      consoleFont = mkOption {
        type = types.str;
        description = "Default console font.";
      };
    };
  };

  config = mkIf cfg.enable {

    # Server
    ###################################################
    services.xserver = {
      enable = true;
      dpi = cfg.fonts.dpi;
      windowManager = {
        i3 = {
          enable = true;
          package = pkgs.i3-gaps;
        };
      };

      displayManager = {
        autoLogin = { enable = true; user = "${cfg.username}"; };
        defaultSession = "none+i3";
        sessionCommands = ''
          setxkbmap -rules "evdev" -model "pc105" -layout "us,ru" -option "grp:win_space_toggle,ctrl:swapcaps,altwin:swap_alt_win"
        '';
      };
    };

    environment.sessionVariables.CURRENT_WM = [ "i3" ];

    # Themes
    environment.variables = {
      GTK_THEME = "Adwaita:dark";
    };
    environment.systemPackages = with pkgs; [
      plymouth
      lxqt.lxqt-policykit
    ];

    qt5 = {
      enable = true;
      platformTheme = "gnome";
      style = "adwaita-dark";
    };

    programs.dconf.enable = true;

    # For pcmanfm
    ###################################################
    networking.firewall.extraCommands = "iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns";
    services.gvfs.enable = true;

    # Fonts
    ###################################################
    fonts = {
      fontconfig = {
        enable = true;
        antialias = true;
        # dpi = cfg.dpi;
        defaultFonts.monospace = [ cfg.fonts.monospaceFont ];
      };

      fontDir.enable = true;
      enableGhostscriptFonts = true;
      enableDefaultFonts = true;

      fonts = with pkgs; [
          (nerdfonts.override { fonts = [ "FiraCode" "FiraMono" ]; })
      ];
    };

    console = {
      font = cfg.fonts.consoleFont;
      useXkbConfig = true;
    };

    services.udev.extraRules = ''
      ACTION=="change", SUBSYSTEM=="drm", RUN+="${pkgs.autorandr}/bin/autorandr --batch --change"
    '';

    # Home
    home-manager.users."${cfg.username}" = {
        imports = [
            home/wm.nix
        ];
    };
  };
}
