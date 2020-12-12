{ config, lib, pkgs, ... }:
with lib;
let
  mail = config.modules.mail;
  username = config.properties.user.name;
in
{
  options.modules.mail = {
    accounts = mkOption {
      type = types.attrs;
      default = { };
    };
  };

  config = mkIf mail.enable {
    home-manager.users."${username}" = {
      accounts.email = {
        maildirBasePath = "${config.home.homeDirectory}/mail";
        accounts = mail.accounts;
      };
    };
  };
}
