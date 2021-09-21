{ config, lib, pkgs, inputs, ... }:
with lib;
let
  cfg = config.nixos.dev.virtualisation;
  dev = config.nixos.dev;
  username = config.nixos.username;

  stable = import inputs.stable (
    {
      config = config.nixpkgs.config;
      localSystem = { system = "x86_64-linux"; };
    }
  );

in
{
  options.nixos.dev = {
    virtualisation = {
      enableVirtualbox = mkEnableOption "Enable Virtualbox.";
    };
  };

  config = mkIf (cfg.enableVirtualbox) {

    virtualisation.virtualbox = {
      host = {
        enable = true;
        enableExtensionPack = true;
      };
    };

    users.users.${username}.extraGroups = [ "vboxusers" ];

    home-manager.users."${username}" = {
    };
  };
}
