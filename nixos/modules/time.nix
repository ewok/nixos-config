{ config, lib, pkgs, ... }:
with lib;
let
  timezone = config.nixos.timezone;
in
{
  config = {
    time.timeZone = timezone;
  };
}
