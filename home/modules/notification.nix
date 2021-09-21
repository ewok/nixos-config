{ config, lib, pkgs, ... }:
with lib;
let
  gui = config.home.gui;
  colors = config.home.theme.colors;
in
{
  config = mkIf gui.enable {

    services.dunst = {
      enable = true;
      iconTheme = {
        name = "Papirus";
        package = pkgs.papirus-icon-theme;
      };
      settings = {
        global = {
          alignment = "left";
          ellipsize = "middle";
          format = ''%s %p\n%b'';
          geometry = "0x4-25+25";
          hide_duplicate_count = false;
          horizontal_padding = 10;
          idle_threshold = 120;
          ignore_newline = false;
          indicate_hidden = true;
          line_height = 0;
          markup = "full";
          notification_height = 0;
          padding = 8;
          separator_height = 1;
          show_age_threshold = 60;
          show_indicators = true;
          shrink = false;
          sort = true;
          stack_duplicates = true;
          transparency = 15;
          vertical_alignment = "center";
          word_wrap = true;

          icon_position = "left";
          min_icon_size = 0;
          max_icon_size = 64;

          sticky_history = true;
          history_length = 20;
          always_run_script = true;

          title = "Dunst";
          class = "Dunst";

          startup_notification = false;
          verbosity = "mesg";

          corner_radius = 0;
          ignore_dbusclose = false;

          mouse_left_click = "close_current";
          mouse_middle_click = "do_action, close_current";
          mouse_right_click = "close_all";

          frame_color = "#${colors.color7}";
          separator_color = "#${colors.color7}";
          font = "Monospace 10";
          follow = "mouse";
          browser = "xdg-open";
        };
        shortcuts = {
          history = "ctrl+shift+n";
        };

        urgency_low = {
          background = "#${colors.color10}";
          foreground = "#${colors.color7}";
          timeout = 5;
        };
        urgency_normal = {
          background = "#${colors.color11}";
          foreground = "#${colors.color3}";
          timeout = 10;
        };
        urgency_critical = {
          background = "#${colors.color1}";
          foreground = "#${colors.color0}";
        };
      };
    };

    home.packages = [ pkgs.dunst ];

  };
}
