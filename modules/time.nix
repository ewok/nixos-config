{ config, lib, pkgs, ... }:
with lib;
let
  timezone = config.opt.time.timezone;
in
{
  options.opt.time.timezone = mkOption {
    type = types.str;
  };

  config = {
    time.timeZone = timezone;
    services.timesyncd.enable = true;
  };
}
