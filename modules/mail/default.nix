{ lib, ... }:
with lib;
{
  imports = [
    ./account.nix
    ./neomutt.nix
    ./mailspring.nix
    ./thunderbird.nix
  ];
  options.modules.mail = {
    enable = mkEnableOption "Enable email stuff.";
    neomutt.enable = mkEnableOption "Enable neomutt in addition or only.";
    mailspring.enable = mkEnableOption "Enable mailspring in addition or only.";
    thunderbird.enable = mkEnableOption "Enable thunderbird in addition or only.";
  };
}
