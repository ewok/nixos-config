{ config, lib, pkgs, utils, ... }:
let
  inherit (lib) mkIf;
  inherit (pkgs) writeScriptBin system;

  cfg = config.opt.wm;
  # spacebar-sh = pkgs.writeScriptBin "spacebar.sh" ''
  #   ${readFile ./config/macos/spacebar.sh}
  # '';
  home-profile = writeScriptBin "home-profile" ''
    displayplacer \
      "id:D6C2035F-7377-4A18-A1CD-BC0BA930526E res:1920x1080 \
      hz:75 color_depth:8 enabled:true scaling:off origin:(0,0) degree:0" \
      "id:37D8832A-2D66-02CA-B9F7-8F30A301B230 res:1512x982 \
      hz:120 color_depth:8 enabled:true scaling:on origin:(217,-982) degree:0" \
  '';

  work-profile = writeScriptBin "work-profile" ''
    displayplacer "id:D6C2035F-7377-4A18-A1CD-BC0BA930526E res:1920x1080 \
    hz:75 color_depth:8 enabled:true scaling:off origin:(0,0) degree:0" \
    "id:37D8832A-2D66-02CA-B9F7-8F30A301B230 res:1512x982 \
    hz:120 color_depth:8 enabled:true scaling:on origin:(-1512,98) degree:0" \
  '';

  vars =
    {
      homePath = cfg.homePath;
    };
in
{
  config = mkIf (cfg.enable && (system == "aarch64-darwin"))
    {
      home.packages = [
        # spacebar-sh
        home-profile
        work-profile
      ];
      # home.file.".skhdrc".source = ./config/macos/skhdrc;
      home.file."finicky.js".source = ./config/macos/finicky.js;
      home.file."bin/new-iterm-window.scpt".source = ./config/macos/new-iterm-window.scpt;
      # home.file.".aerospace.toml".source = utils.templateFile "aerospace.toml" ./config/macos/aerospace.toml vars;
      home.file.".yabairc" = {
        source = ./config/macos/yabairc;
        executable = true;
      };
      home.file.".hammerspoon/init.lua".source = ./config/macos/hammerspoon.lua;

    xdg.configFile."fish/conf.d/99_brew.fish" = {
      text = ''
        set --global --export HOMEBREW_PREFIX "/opt/homebrew";
        set --global --export HOMEBREW_CELLAR "/opt/homebrew/Cellar";
        set --global --export HOMEBREW_REPOSITORY "/opt/homebrew";
        fish_add_path --global --move --path "/opt/homebrew/bin" "/opt/homebrew/sbin";
        if not contains "/opt/homebrew/share/info" $INFOPATH; set --global --export INFOPATH "/opt/homebrew/share/info" $INFOPATH; end;
      '';
    };
      # xdg.configFile."spacebar/spacebarrc" = {
      #   source = ./config/macos/spacebarrc;
      #   executable = true;
      # };
    };
}
