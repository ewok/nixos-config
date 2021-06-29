{ config, lib, pkgs, inputs, ... }:
with lib;
let
  dev = config.modules.dev;
  username = config.properties.user.name;
  master = import inputs.master (
    {
      config = config.nixpkgs.config;
      localSystem = { system = "x86_64-linux"; };
    }
  );
in
{
  options.modules.dev = {
    terraform = {
      enable= mkEnableOption "Enable terraform in dev environment.";
    };
  };
  config = mkIf (dev.enable) {
    home-manager.users."${username}" = {
      home.packages = [ master.terraform ];
    };
  };
}

