{ lib, ... }:
with lib;
{
  imports = [

    # Development
    ./cawbird.nix
    ./element.nix
    # ./skype.nix
    ./slack.nix
    ./telegram.nix
    ./zoom.nix
  ];
  options.modules.communication = {
    enable = mkEnableOption "Enable communication soft.";
  };
}
