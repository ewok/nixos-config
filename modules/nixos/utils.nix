{ pkgs, lib, ... }:
let
  inherit (pkgs) system;
  inherit (lib) optionals;
in
{
  config = {
    virtualisation.podman = {
      enable = false;
      dockerCompat = true;
    };
    environment.systemPackages = [ pkgs.distrobox ];
  };
}
