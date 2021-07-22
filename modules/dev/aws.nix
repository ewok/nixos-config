{ config, lib, pkgs, inputs, ... }:
with lib;
let
  dev = config.modules.dev;
  username = config.properties.user.name;
  stable = import inputs.stable (
    {
      config = config.nixpkgs.config;
      localSystem = { system = "x86_64-linux"; };
    }
  );
in
{
  options.modules.dev = {
    aws = {
      enable= mkEnableOption "Enable aws in dev environment.";
    };
  };
  config = mkIf (dev.enable) {
    home-manager.users."${username}" = {
      home.packages = [ stable.awscli2 ];
    };
  };
}

