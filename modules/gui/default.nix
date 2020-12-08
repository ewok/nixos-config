{ lib, ... }:
with lib;
{
  imports = [

    # GUI tools
    # WM:
    ./wm
    ./termite.nix
    ./fonts.nix
    ./keyboard.nix
    ./firefox.nix
    ./enpass.nix
    ./albert.nix
    ./clipit.nix
    ./screenshots.nix
      # ./deadd
    # deadd-notification-center
      # ./nitrogen
      # scrot
      # peek
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
    # flameshot
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
