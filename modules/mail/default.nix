{ lib, ... }:
with lib;
{
  imports = [
    ./account.nix
    ./neomutt.nix
    # "mbsync"
    # "msmtp"
    # "notmuch"
    # "notmuch-mutt"
    # "davmail"
    # "goobook"
    # "lbdb"
    # "vcal"
    # "pass"
    # "pandoc"
  ];
  options.modules.mail = {
    enable = mkEnableOption "Enable mailing soft.";
  };
}
