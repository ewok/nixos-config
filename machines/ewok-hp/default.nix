{ config, inputs, lib, pkgs, ... }:
with lib;
{
  imports = [
    ./secrets.nix
    ../common.nix
    ./configuration.nix
  ];

  # Global options
  options.username = mkOption {
    type = types.str;
  };

  options.gui = mkOption { type = types.bool; };
}
