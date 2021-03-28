{ lib, ... }:
with lib;
{
  imports = [
    ./account.nix
    ./neomutt.nix
    ./mailspring.nix
    # "goobook"
    # "lbdb"
    # "vcal"
  ];
  options.modules.mail = {
    enable = mkEnableOption "Enable mailing soft.";
    mailspring.enable = mkEnableOption "Enable mailspring in addition or only.";
  };
}
