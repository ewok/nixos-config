{ config, lib, pkgs, ... }:
with lib;
let
  username = config.properties.user.name;
in
{
  config = {
    services.timesyncd.enable = true;
  };
}
