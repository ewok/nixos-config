{ config, lib, pkgs, ... }:
with lib;
let
    cfg = config.opt.apps;
in
{
    options.opt.apps = {
        username = mkOption { type = types.str; };

    };
    config ={
        home-manager.users."${cfg.username}" = {
            imports = [
                home/apps.nix
            ];
        };
    };
}

