{ config, lib, pkgs, ... }:
with lib;
let
  mail = config.modules.mail;
  username = config.properties.user.name;
  homeDirectory = config.home-manager.users.${username}.home.homeDirectory;
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
        maildirBasePath = "${homeDirectory}/mail";
        accounts = mail.accounts;
      };
    };
  };
}
