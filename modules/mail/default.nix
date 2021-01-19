{ lib, ... }:
with lib;
{
  imports = [
    ./account.nix
    ./neomutt.nix
    # "goobook"
    # "lbdb"
    # "vcal"
  ];
  options.modules.mail = {
    enable = mkEnableOption "Enable mailing soft.";
  };
}
