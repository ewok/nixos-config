{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.opt.wm;
  # spacebar-sh = pkgs.writeScriptBin "spacebar.sh" ''
  #   ${readFile ./config/macos/spacebar.sh}
  # '';
  home-profile = pkgs.writeScriptBin "home-profile" ''
    displayplacer \
      "id:D6C2035F-7377-4A18-A1CD-BC0BA930526E res:1920x1080 \
      hz:75 color_depth:8 enabled:true scaling:off origin:(0,0) degree:0" \
      "id:37D8832A-2D66-02CA-B9F7-8F30A301B230 res:1512x982 \
      hz:120 color_depth:8 enabled:true scaling:on origin:(1920,98) degree:0" \
  '';

  work-profile = pkgs.writeScriptBin "work-profile" ''
    displayplacer "id:D6C2035F-7377-4A18-A1CD-BC0BA930526E res:1920x1080 \
    hz:75 color_depth:8 enabled:true scaling:off origin:(0,0) degree:0" \
    "id:37D8832A-2D66-02CA-B9F7-8F30A301B230 res:1512x982 \
    hz:120 color_depth:8 enabled:true scaling:on origin:(-1512,98) degree:0" \
  '';
in
{
  config = mkIf (cfg.enable && (pkgs.system == "aarch64-darwin"))
    {
      home.packages = [
        # spacebar-sh
        home-profile
        work-profile
      ];
      home.file.".skhdrc".source = ./config/macos/skhdrc;
      home.file.".finicky.js".source = ./config/macos/finicky.js;
      home.file.".wezterm.lua".source = ./config/macos/wezterm.lua;
      home.file."bin/new-iterm-window.scpt".source = ./config/macos/new-iterm-window.scpt;
      # home.file.".yabairc" = {
      #   source = ./config/macos/yabairc;
      #   executable = true;
      # };
      # xdg.configFile."spacebar/spacebarrc" = {
      #   source = ./config/macos/spacebarrc;
      #   executable = true;
      # };
    };
}
