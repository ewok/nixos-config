{ lib, ... }:
with lib;
{
  options.opt.wm = {
    enable = mkEnableOption "wm";
  };
  imports = [ ./mac.nix ];
}
