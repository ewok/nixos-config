{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf mkOption types;
  inherit (pkgs) stdenv writeTextFile;

  cfg = config.opt.ai;

  opencodeConfig = {
    "$schema" = "https://opencode.ai/config.json";

    autoupdate = false;
    share = "manual";
    theme = "catppuccin-macchiato";

    mcp = {
      context7 = {
        type = "remote";
        url = "https://mcp.context7.com/mcp";
        headers = {
          CONTEXT7_API_KEY = "{env:CONTEXT7_API_KEY}";
        };
      };
      gh_grep = {
        type = "remote";
        url = "https://mcp.grep.app";
      };
    };

    permission = {
      edit = "ask";
      bash = "ask";
      write = "ask";
    };

    keybinds = {
      # changed:
      agent_cycle = "<leader>n"; # "tab";
      agent_cycle_reverse = "none"; # "shift+tab";
      app_exit = "ctrl+q"; # "ctrl+d,ctrl+c,<leader>q";
      editor_open = "<leader>i"; # "<leader>e"
      input_delete_to_line_start = "none"; # "ctrl+u";
      input_line_end = "end"; # "ctrl+e";
      input_line_home = "home"; # "ctrl+a";
      leader = "tab"; # "ctrl+x";
      messages_half_page_down = "ctrl+e"; # "ctrl+alt+d";
      messages_half_page_up =  "ctrl+y"; #"ctrl+alt+u";
      messages_last = "<leader>e"; #"ctrl+alt+g,end";
      messages_next = "none";
      messages_page_down = "ctrl+d,pagedown"; # "pagedown";
      messages_page_up = "ctrl+u,pageup"; # "pageup";
      messages_previous = "none";
      messages_redo = "none"; # "<leader>r";
      messages_undo = "none"; # "<leader>u";
      model_cycle_recent = "none"; # "f2";
      model_cycle_recent_reverse = "none"; # "shift+f2";
      session_list = "<leader>o"; # "leader+l";
      session_new = "none"; # "<leader>n";

      # useful defaults:
      command_list = "ctrl+p";
      input_clear = "ctrl+c";
      input_newline = "shift+return,ctrl+return,alt+return,ctrl+j";
      messages_first = "ctrl+g";
      messages_toggle_conceal = "<leader>h";
      model_list = "<leader>m";
      session_compact = "<leader>c";
      session_interrupt = "esc";
      session_timeline = "<leader>g";
      variant_cycle = "ctrl+t";

      # defaults:
      agent_list = "<leader>a";
      history_next = "down";
      history_previous = "up";
      input_backspace = "backspace,shift+backspace";
      input_buffer_end = "end";
      input_buffer_home = "home";
      input_delete = "ctrl+d,delete,shift+delete";
      input_delete_line = "ctrl+shift+d";
      input_delete_to_line_end = "ctrl+k";
      input_delete_word_backward = "ctrl+w,ctrl+backspace,alt+backspace";
      input_delete_word_forward = "alt+d,alt+delete,ctrl+delete";
      input_move_down = "down";
      input_move_left = "left,ctrl+b";
      input_move_right = "right,ctrl+f";
      input_move_up = "up";
      input_paste = "ctrl+v";
      input_redo = "ctrl+.,super+shift+z";
      input_select_buffer_end = "shift+end";
      input_select_buffer_home = "shift+home";
      input_select_down = "shift+down";
      input_select_left = "shift+left";
      input_select_line_end = "ctrl+shift+e";
      input_select_line_home = "ctrl+shift+a";
      input_select_right = "shift+right";
      input_select_up = "shift+up";
      input_select_visual_line_end = "alt+shift+e";
      input_select_visual_line_home = "alt+shift+a";
      input_select_word_backward = "alt+shift+b,alt+shift+left";
      input_select_word_forward = "alt+shift+f,alt+shift+right";
      input_submit = "return";
      input_undo = "ctrl+-,super+z";
      input_visual_line_end = "alt+e";
      input_visual_line_home = "alt+a";
      input_word_backward = "alt+b,alt+left,ctrl+left";
      input_word_forward = "alt+f,alt+right,ctrl+right";
      messages_copy = "<leader>y";
      messages_last_user = "none";
      model_cycle_favorite = "none";
      model_cycle_favorite_reverse = "none";
      scrollbar_toggle = "none";
      session_child_cycle = "<leader>right";
      session_child_cycle_reverse = "<leader>left";
      session_export = "<leader>x";
      session_fork = "none";
      session_parent = "<leader>up";
      session_rename = "none";
      session_share = "none";
      session_unshare = "none";
      sidebar_toggle = "<leader>b";
      status_view = "<leader>s";
      terminal_suspend = "ctrl+z";
      terminal_title_toggle = "none";
      theme_list = "<leader>t";
      tips_toggle = "<leader>h";
      tool_details = "none";
      username_toggle = "none";
    };

  };

  opencodeConfigFile = writeTextFile {
    name = "opencode-config.json";
    text = builtins.toJSON opencodeConfig;
  };
in
{
  options.opt.ai = {
    enable = mkEnableOption "AI terminal tools";
    context7_api_key = mkOption {
      type = types.str;
      description = "API key for Context7 services.";
    };
    openai_token = mkOption {
      type = types.str;
      description = "API key for OpenAI services.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      opencode
    ];

    # Install OpenCode configuration
    xdg.configFile."opencode/opencode.json".source = opencodeConfigFile;
    xdg.configFile."bash/profile.d/99-opencode.sh".text = ''
      export CONTEXT7_API_KEY="${cfg.context7_api_key}"
      export OPENAI_API_KEY="${cfg.openai_token}"
    '';
  };
}

