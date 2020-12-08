{ config, lib, ... }:
with lib;
let
  base = config.modules.base;
  username = config.properties.user.name;
in
{
  imports = [
    ./fish
    ./tmux
    ./vifm
    ./starship.nix
    ./tools.nix
    ./ssh.nix
  ];
  options.modules.base = {
    enable = mkOption {
      type = types.bool;
      description = "Enable base soft.";
      default = true;
    };
  };
}
