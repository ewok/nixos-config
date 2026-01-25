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
      btop
      procps
      rclone
      speedtest-cli
      tldr
      whois
      flock
      rsync
      maple-mono.NF-unhinted
    ] ++ optionals (system != "aarch64-darwin") [
      pkgs.atop
      pkgs.jpeginfo
      pkgs.yt-dlp
      pkgs.aria2
      pkgs.sqlite
      pkgs.iproute2
      pkgs.net-tools
      pkgs.openssl
    ];
  };
}
