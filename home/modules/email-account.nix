{ config, lib, pkgs, ... }:
with lib;
let
  mail = config.home.mail;
in
{
  config = mkIf mail.enable {
    accounts.email = {
      maildirBasePath = "${homeDirectory}/mail";
      accounts = mail.accounts;
    };
  };
}
