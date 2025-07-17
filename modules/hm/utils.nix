{ pkgs, lib, ... }:
let
  inherit (pkgs) system;
  inherit (lib) optionals;
in
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
    ] ++ optionals (system != "aarch64-darwin") [
      pkgs.atop
      pkgs.jpeginfo
      pkgs.yt-dlp
      pkgs.aria2
      pkgs.sqlite
    ];
  };
}
