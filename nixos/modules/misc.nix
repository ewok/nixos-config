{ config, lib, pkgs, ... }:
with lib;
{
  config = {
    services.timesyncd.enable = true;
  };
}
