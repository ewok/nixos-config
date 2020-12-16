{ lib, ... }:
with lib;
{
  imports = [

    # GUI tools
    # WM:
    ./wm
    ./terminal.nix
    ./fonts.nix
    ./keyboard.nix
    ./browser.nix
    ./screenshots.nix
    ./eyessaving.nix
    ./display.nix
    ./video.nix

    ./misc/enpass.nix
    ./misc/albert.nix
    ./misc/clipit.nix
    ./misc/tools.nix
    ./misc/network.nix
    ./misc/gparted.nix
    # deadd-notification-center
      # ./deadd
      # ./nitrogen
      # xkb-switch-i3

    # Books:
      # calibre
      # fbreader
      # zathura
      #   zathura-cb
      #   zathura-djvu
      #   zathura-mupdf

    # blueman

    # Communication:

# ldoce5viewer-pyqt5-git

    # browsers:
    #   qutebrowser

      # create dirs:
    # - "~/.local/share/albert/org.albert.extension.python/modules/"
    # - "~/.config/albert"
    # - "~/Pictures/Screenshots"

    # wallpaper

# - name: Set wallpaper from unsplash
#   get_url:
#     url: "https://unsplash.com/photos/aL7SA1ASVdQ/download?force=true"
#     dest: "/usr/share/backgrounds/unsplash.jpg"
#     mode: 0644
#     force: True
#   become: True
#   notify: nitrogen-restore
  ];
  options.modules.gui = {
    enable = mkEnableOption "Enable gui.";
  };
}
