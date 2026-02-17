{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf mkOption types;
  inherit (pkgs) symlinkJoin writeTextFile;

  cfg = config.opt.ai;

  uvLibPath = lib.makeLibraryPath [
    pkgs.stdenv.cc.cc.lib
    pkgs.zlib
  ];

  uvWrapped = pkgs.symlinkJoin {
    name = "uv-wrapped";
    paths = [ pkgs.uv ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/uv --prefix LD_LIBRARY_PATH : "${uvLibPath}"
      wrapProgram $out/bin/uvx --prefix LD_LIBRARY_PATH : "${uvLibPath}"
    '';
  };

  opencodeConfig = {
    "$schema" = "https://opencode.ai/config.json";

    autoupdate = false;
    share = "manual";
    theme = cfg.opencode_theme;
    plugin = [ "@zenobius/opencode-skillful" ];
    mcp = {
      mcp_context7 = {
        enabled = false;
        type = "remote";
        url = "https://mcp.context7.com/mcp";
        headers = {
          CONTEXT7_API_KEY = "{env:CONTEXT7_API_KEY}";
        };
      };
      mcp_gh_grep = {
        enabled = false;
        type = "remote";
        url = "https://mcp.grep.app";
      };
      # aws_cloudtrail = {
      #   enabled = false;
      #   type = "local";
      #   command = [ "uvx" "awslabs.cloudtrail-mcp-server@latest" ];
      #   environment = {
      #     AWS_PROFILE = "{file:./.profile}";
      #     FASTMCP_LOG_LEVEL = "ERROR";
      #   };
      # };
      # aws_cloudwatch = {
      #   enabled = false;
      #   type = "local";
      #   command = [ "uvx" "awslabs.cloudwatch-mcp-server@latest" ];
      #   environment = {
      #     AWS_PROFILE = "{file:./.profile}";
      #     FASTMCP_LOG_LEVEL = "ERROR";
      #   };
      # };
      # aws_cost_explorer = {
      #   enabled = false;
      #   type = "local";
      #   command = [ "uvx" "awslabs.cost-explorer-mcp-server@latest" ];
      #   environment = {
      #     AWS_PROFILE = "{file:./.profile}";
      #     FASTMCP_LOG_LEVEL = "ERROR";
      #   };
      # };
      # aws_documentation = {
      #   enabled = false;
      #   type = "local";
      #   command = [ "uvx" "awslabs.aws-documentation-mcp-server@latest" ];
      #   environment = {
      #     AWS_DOCUMENTATION_PARTITION = "aws";
      #     FASTMCP_LOG_LEVEL = "ERROR";
      #     MCP_USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36";
      #   };
      # };
      # aws_terraform = {
      #   enabled = false;
      #   type = "local";
      #   command = [ "uvx" "awslabs.terraform-mcp-server@latest" ];
      #   environment = {
      #     FASTMCP_LOG_LEVEL = "ERROR";
      #   };
      # };
      # aws_iam = {
      #   enabled = false;
      #   type = "local";
      #   command = [ "uvx" "awslabs.iam-mcp-server@latest" ];
      #   environment = {
      #     AWS_PROFILE = "{file:./.profile}";
      #     AWS_REGION = "us-east-1";
      #     FASTMCP_LOG_LEVEL = "ERROR";
      #   };
      # };
    };

    keybinds = {
      # changed:
      agent_cycle = "ctrl+n"; # "tab";
      agent_cycle_reverse = "shift+tab"; # "shift+tab";
      app_exit = "ctrl+q"; # "ctrl+d,ctrl+c,<leader>q";
      editor_open = "<leader>i"; # "<leader>e"
      input_delete_to_line_start = "none"; # "ctrl+u";
      input_line_end = "end"; # "ctrl+e";
      input_line_home = "home"; # "ctrl+a";
      # leader = "shift+tab"; # "ctrl+x";
      messages_half_page_down = "ctrl+e"; # "ctrl+alt+d";
      messages_half_page_up = "ctrl+y"; #"ctrl+alt+u";
      messages_last = "<leader>e"; #"ctrl+alt+g,end";
      messages_next = "none";
      messages_page_down = "ctrl+d,pagedown"; # "pagedown";
      messages_page_up = "ctrl+u,pageup"; # "pageup";
      messages_previous = "none";
      messages_redo = "none"; # "<leader>r";
      messages_undo = "none"; # "<leader>u";
      model_cycle_recent = "none"; # "f2";
      model_cycle_recent_reverse = "none"; # "shift+f2";
      session_list = "ctrl+o"; # "leader+l";
      session_new = "none"; # "<leader>n";
      input_submit = "ctrl+s"; # "shift+return,ctrl+return,alt+return,ctrl+j,ctrl+alt+j";
      input_newline = "return";

      # useful defaults:
      command_list = "ctrl+p";
      input_clear = "ctrl+c";
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

    agent = {
      build = {
        permission = {

          read = {
            "*" = "allow";
            "*.env" = "deny";
            "*.env.*" = "deny";
            "secret*" = "deny";
            "*.key" = "deny";
            "*.pem" = "deny";
            "*passwd*" = "deny";
            "*shadow*" = "deny";
            "*.env.example" = "allow";
          };

          # Tool permissions
          edit = "allow";
          glob = "allow";
          grep = "allow";
          list = "allow";
          task = "allow";
          skill = "allow";
          lsp = "allow";
          todoread = "allow";
          todowrite = "allow";
          webfetch = "allow";
          websearch = "allow";
          codesearch = "allow";
          external_directory = "ask";
          doom_loop = "ask";

          bash = {

            "*" = "ask";

            # File operations (read-only)
            "cat *" = "allow"; # cat > file, all files can be overwritten with that
            "ls *" = "allow";
            "find *" = "allow";
            "grep *" = "allow";
            "wc *" = "allow";
            "head *" = "allow";
            "tail *" = "allow";
            "file *" = "allow";

            "*>*" = "ask"; # Block output redirection
            "*>>*" = "ask"; # Block append redirection
            "*|*" = "ask"; # Block pipes
            "*;*" = "ask"; # Block command chaining
            "*&&*" = "ask"; # Block conditional execution
            "*||*" = "ask"; # Block alternative execution
            "*\$(*" = "ask"; # Block command substitution
            "*\`*\`*" = "ask"; # Block backtick substitution

            # Text processing
            "diff *" = "allow";
            "sort *" = "allow";
            "uniq *" = "allow";
            "cut *" = "allow";
            "awk *" = "allow";

            # Environment awareness
            "echo *" = "allow";
            "pwd *" = "allow";
            "which *" = "allow";
            "env *" = "allow";
            "uname *" = "allow";

            # Git operations
            "git status*" = "allow";
            "git log*" = "allow";
            "git show*" = "allow";
            "git diff*" = "allow";
            "git branch*" = "allow";

            # Nix ecosystem essentials
            "nix build*" = "allow"; # Safe builds
            "nix eval*" = "allow"; # Safe evaluation
            "nix flake check*" = "allow"; # Safe validation
            "nix flake show*" = "allow"; # Safe display
            "nix search*" = "allow"; # Safe search
            "nix log*" = "allow"; # Safe log viewing
            "nix why-depends*" = "allow"; # Safe dependency analysis
            "nix path-info*" = "allow"; # Safe store info

            # Language tools
            "go *" = "allow";
            "lua *" = "allow";

            # Formatters (safe)
            "prettier *" = "allow";
            "rustfmt *" = "allow";
            "gofmt *" = "allow";
            "black *" = "allow";
            "stylua *" = "allow";
            "nixpkgs-fmt *" = "allow";

            # Archive inspection (READ-ONLY)
            "tar -t*" = "allow"; # List contents only
            "unzip -l*" = "allow"; # List contents only
            "zcat *" = "allow";
            "bzcat *" = "allow";
            "xzcat *" = "allow";

            # Process inspection (PRIVACY CONSCIOUS)
            "jobs *" = "allow"; # Current shell only
            "ps aux*" = "allow"; # Basic process list

            # Binary/hex tools
            "base64 *" = "allow";
            "xxd *" = "allow";
            "od *" = "allow";
            "hexdump *" = "allow";
          };
        };
      };
    };
  };

  claudeCodeConfig = {
    permissions = {
      allow = [
        "Read"
        "Edit"
        "Bash(cat *)"
        "Bash(ls *)"
        "Bash(find *)"
        "Bash(grep *)"
        "Bash(wc *)"
        "Bash(head *)"
        "Bash(tail *)"
        "Bash(file *)"
        "Bash(diff *)"
        "Bash(sort *)"
        "Bash(uniq *)"
        "Bash(cut *)"
        "Bash(awk *)"
        "Bash(echo *)"
        "Bash(pwd *)"
        "Bash(which *)"
        "Bash(env *)"
        "Bash(uname *)"
        "Bash(git status*)"
        "Bash(git log*)"
        "Bash(git show*)"
        "Bash(git diff*)"
        "Bash(git branch*)"
        "Bash(nix build*)"
        "Bash(nix eval*)"
        "Bash(nix flake check*)"
        "Bash(nix flake show*)"
        "Bash(nix search*)"
        "Bash(nix log*)"
        "Bash(nix why-depends*)"
        "Bash(nix path-info*)"
        "Bash(go *)"
        "Bash(lua *)"
        "Bash(prettier *)"
        "Bash(rustfmt *)"
        "Bash(gofmt *)"
        "Bash(black *)"
        "Bash(stylua *)"
        "Bash(nixpkgs-fmt *)"
        "Bash(tar -t*)"
        "Bash(unzip -l*)"
        "Bash(zcat *)"
        "Bash(bzcat *)"
        "Bash(xzcat *)"
        "Bash(jobs *)"
        "Bash(ps aux*)"
        "Bash(base64 *)"
        "Bash(xxd *)"
        "Bash(od *)"
        "Bash(hexdump *)"
      ];
      ask = [
        "Bash"
      ];
      deny = [
        "Read(./.env)"
        "Read(./.env.*)"
        "Read(./secret*)"
        "Read(*.key)"
        "Read(*.pem)"
        "Read(*passwd*)"
        "Read(*shadow*)"
      ];
    };
  };

  claudeKeybindingsConfig = {
    "$schema" = "https://platform.claude.com/docs/schemas/claude-code/keybindings.json";
    "$docs" = "https://code.claude.com/docs/en/keybindings";
    bindings = [
      {
        context = "Global";
        bindings = {
          "ctrl+q" = "app:exit";
          "ctrl+o" = "app:toggleTranscript";
        };
      }
      {
        context = "Chat";
        bindings = {
          "ctrl+s" = "chat:submit";
          "escape" = "chat:cancel";
          "ctrl+p" = "chat:modelPicker";
          "ctrl+t" = "chat:thinkingToggle";
          "ctrl+g" = "chat:externalEditor";
          "up" = "history:previous";
          "down" = "history:next";
          "ctrl+n" = "chat:cycleMode";
          "ctrl+x" = "chat:stash";
          "enter" = null;
        };
      }
    ];
  };

  opencodeConfigFile = writeTextFile {
    name = "opencode-config.json";
    text = builtins.toJSON opencodeConfig;
  };

  claudeCodeConfigFile = writeTextFile {
    name = "claude-code-settings.json";
    text = builtins.toJSON claudeCodeConfig;
  };

  claudeKeybindingsConfigFile = writeTextFile {
    name = "claude-code-keybindings.json";
    text = builtins.toJSON claudeKeybindingsConfig;
  };

  my-opencode = symlinkJoin {
    name = "my-opencode";
    paths = [
      pkgs.opencode
    ];
    postBuild = ''
      ln -s $out/bin/opencode $out/bin/oc
    '';
  };

  anthropicSkills = builtins.fetchGit {
    url = "https://github.com/anthropics/skills.git";
    rev = "1ed29a03dc852d30fa6ef2ca53a67dc2c2c2c563";
  };

  # clawbotSkills = builtins.fetchGit {
  #   url = "https://github.com/openclaw/skills.git";
  #   rev = "6410136271c1f3dab8f5b413e626ac63e8ae07fa";
  # };

in
{
  options.opt.ai = {
    enable = mkEnableOption "AI terminal tools";
    install_opencode = mkOption {
      type = types.bool;
      description = "Install OpenCode AI terminal tool.";
      default = true;
    };
    opencode_theme = mkOption {
      type = types.str;
      description = "Opencode theme";
      default = "opencode";
    };
    install_claude = mkOption {
      type = types.bool;
      description = "Install Claude AI terminal tool.";
      default = false;
    };
    context7_api_key = mkOption {
      type = types.str;
      description = "API key for Context7 services.";
      default = "";
    };
    openai_token = mkOption {
      type = types.str;
      description = "API key for OpenAI services.";
      default = "";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      uvWrapped
      please-cli
    ] ++ lib.optional cfg.install_opencode my-opencode
    ++ lib.optional cfg.install_claude pkgs.claude-code;

    # Install OpenCode configuration
    xdg.configFile."opencode/opencode.json".source = opencodeConfigFile;
    xdg.configFile."opencode/.opencode-skillful.json".text = ''
      {
        "debug": false,
        "basePaths": ["~/.config/opencode/skills", ".opencode/skills"],
        "promptRenderer": "xml",
        "modelRenderers": {}
      }
    '';
    xdg.configFile."opencode/agent".source = ./agents;
    xdg.configFile."opencode/skills/terraform-skill".source =
      builtins.fetchGit {
        url = "https://github.com/antonbabenko/terraform-skill";
        rev = "2271bc4a037a99523b1750d078bbcb3eae05a8e0";
      };

    xdg.configFile."opencode/skills/mcp-builder".source = "${anthropicSkills}/skills/mcp-builder";
    xdg.configFile."opencode/skills/doc-coauthoring".source = "${anthropicSkills}/skills/doc-coauthoring";
    # xdg.configFile."opencode/skills/garmin-health-analysis".source = "${clawbotSkills}/skills/eversonl/garmin-health-analysis";
    # xdg.configFile."opencode/skills/firefly-iii".source = "${clawbotSkills}/skills/pushp1997/firefly-iii";

    xdg.configFile."bash/profile.d/99-opencode.sh".text = ''
      export CONTEXT7_API_KEY="${cfg.context7_api_key}"
      export OPENAI_API_KEY="${cfg.openai_token}"
    '';

    home.file.".claude/settings.json".source = claudeCodeConfigFile;
    # home.file.".claude/keybindings.json".source = claudeKeybindingsConfigFile;


  };
}
