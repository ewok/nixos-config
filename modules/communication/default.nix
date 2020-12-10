{ lib, ... }:
with lib;
{
  imports = [

    # Development
    ./skype
    ./slack
    ./telegram
    ./zoom
  ];
  options.modules.communication = {
    enable = mkEnableOption "Enable communication soft.";
  };
}

