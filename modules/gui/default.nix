{ lib, ... }:
with lib;
{
  imports = [
    ./wm
    ./appmenu.nix
    ./browser.nix
    ./clipboard.nix
    ./display.nix
    ./eyessaving.nix
    ./filemanager.nix
    ./fonts.nix
    ./keyboard.nix
    ./misc.nix
    ./notification.nix
    ./office.nix
    ./passwords.nix
    ./screenshots.nix
    ./terminal.nix
    ./touchscreen.nix
    ./video.nix
    ./wallpaper.nix
  ];
  options.modules.gui = {
    enable = mkEnableOption "Enable gui.";
  };
}
