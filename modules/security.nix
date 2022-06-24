{ config, lib, pkgs, inputs, ... }:
with lib;
let
  cfg = config.opt.security;
in
  {
    options.opt.security = {
      enable = mkOption { type = types.bool; };
      username = mkOption { type = types.str; };
    };

    config =  mkIf cfg.enable {
        services.gnome.gnome-keyring.enable = true;
        programs.seahorse.enable = true;
        security.pam.services.lightdm.enableGnomeKeyring = true;

        environment.systemPackages = with pkgs; [
          gnupg
        ];
        services.pcscd.enable = true;

        home-manager.users.${cfg.username} = {
            imports = [
                home/security.nix
            ];
        };
      };
  }
