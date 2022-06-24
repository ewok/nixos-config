{ config, lib, pkgs, inputs, firefox, ... }:
with lib;
let
  cfg = config.opt.browser;
in
{
  options.opt.browser = {
    username = mkOption { type = types.str; };
  };

    config ={
        home-manager.users."${cfg.username}" = {
            imports = [
                home/browser.nix
            ];
        };
    };
}
