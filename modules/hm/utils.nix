{ pkgs, ... }:
{
  config = {
    home.packages = with pkgs; [
      dfc
      fswatch
      htop
      atop
      please-cli
      procps
      rclone
      speedtest-cli
      tldr
      whois
      flock
      yt-dlp
    ];
  };
}
