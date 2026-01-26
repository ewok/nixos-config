{ pkgs, lib, ... }:
let
  inherit (pkgs) system;
  inherit (lib) optionals;
in
{
  config = {
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
    };
    environment.systemPackages = [ pkgs.distrobox ];
  };
}
