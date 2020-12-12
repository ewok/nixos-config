{ config, lib, pkgs, ... }:
with lib;
let
  mail = config.modules.mail;
  username = config.properties.user.name;
in
{
  options.modules.mail = mkOption {
    type = jjjjjjjj
  };

  config = mkIf mail.enable {

    home-manager.users."${username}" = {
      accounts.email = {
        maildirBasePath = "${config.home.homeDirectory}/mail";
        accounts = {
          name = "main";
          primary = true/false;
          flavor = "gmail.com";
          address = "ewok@ewok.ru";
          aliases = "artur@taranchiev.ru";
          realName = "Artur Taranchiev";
          userName = "ewok@ewok.ru";
          passwordCommand = "pass main";
        };
      }
    };
  };
}

