{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.opt.wm;
  spacebar-sh = pkgs.writeScriptBin "spacebar.sh" ''
    ${readFile ./config/macos/spacebar.sh}
  '';
in
{
  config = mkIf (cfg.enable && (pkgs.system == "aarch64-darwin"))
    {
      home.packages = [ spacebar-sh ];
      home.file.".skhdrc".source = ./config/macos/skhdrc;
      home.file.".finicky.js".source = ./config/macos/finicky.js;
      home.file.".yabairc" = {
        source = ./config/macos/yabairc;
        executable = true;
      };
      xdg.configFile."spacebar/spacebarrc" = {
        source = ./config/macos/spacebarrc;
        executable = true;
      };
    };
}
