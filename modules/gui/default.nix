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
    ./office.nix
    ./notification.nix
    ./touchscreen.nix
    ./passwords.nix

    # ./misc/enpass.nix
    # ./misc/albert.nix
    ./misc/dmenu.nix
    ./misc/clipit.nix
    ./misc/tools.nix
    ./misc/pcmanfm.nix
    # deadd-notification-center
    # ./deadd
    # ./nitrogen

    # Books:
    # calibre
    # fbreader

    # Communication:

    # ldoce5viewer-pyqt5-git

    # browsers:
    #   qutebrowser

    # create dirs:
    # - "~/.local/share/albert/org.albert.extension.python/modules/"
    # - "~/.config/albert"
    # - "~/Pictures/Screenshots"

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
