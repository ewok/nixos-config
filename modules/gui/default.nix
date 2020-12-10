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

    ./misc/enpass.nix
    ./misc/albert.nix
    ./misc/clipit.nix
    # deadd-notification-center
      # ./deadd
      # ./nitrogen
      # xclip
      # xsel
      # xkb-switch-i3
    # redshift

      # autorandr
      # backlight

    # Books:
      # calibre
      # fbreader
      # zathura
      #   zathura-cb
      #   zathura-djvu
      #   zathura-mupdf

    # Sound:
      # pa-applet
      # pavucontrol
      # Pulseaudio
      # Pulseaudio.bluetooth
# playerctl

    # blueman

    # Communication:
      # slack
      # telegram
      # cawbird

# ldoce5viewer-pyqt5-git

    # browsers:
    #[x]   firefox
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
