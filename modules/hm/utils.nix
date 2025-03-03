{ pkgs, ... }:
{
  config = {
    home.packages = with pkgs; [
      dfc
      fswatch
      htop
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
