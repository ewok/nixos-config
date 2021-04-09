{ lib, ... }:
with lib;
{
  imports = [
    ./wm
    ./terminal.nix
    ./fonts.nix
    ./keyboard.nix
    ./browser.nix
    ./screenshots.nix
    ./eyessaving.nix
    ./display.nix
    ./video.nix
    ./office.nix
    ./notification.nix
    ./touchscreen.nix
    ./passwords.nix
    ./wallpaper.nix
    ./misc/dmenu.nix
    ./misc/clipit.nix
    ./misc/tools.nix
    ./misc/pcmanfm.nix
  ];
  options.modules.gui = {
    enable = mkEnableOption "Enable gui.";
  };
}
