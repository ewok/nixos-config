{ config, lib, pkgs, ... }:
with lib;
{
  config = {
    environment.systemPackages = with pkgs; [
      ntfs3g
    ];
  };
}

