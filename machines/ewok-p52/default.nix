{ config, inputs, lib, pkgs, ... }:
with lib;
{
  imports = [
    ./secrets.nix
    ../common.nix
    ./configuration.nix
  ];

  options.username = mkOption {
    type = types.str;
  };
}
