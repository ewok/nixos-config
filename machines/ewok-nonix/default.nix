{ config, inputs, lib, pkgs, ... }:
with lib;
{
  imports = [
    ./secrets.nix
  ] ++ 
  (map (n: ../../modules/home + "/${n}") (builtins.attrNames (builtins.readDir ../../modules/home)));

  # Global options
  options.username = mkOption {
    type = types.str;
  };
}
