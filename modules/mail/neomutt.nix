{ config, lib, pkgs, ... }:
with lib;
let
  mail = config.modules.mail;
  username = config.properties.user.name;
in
{
  config = mkIf mail.enable {
    home-manager.users.${username} = {
      home.packages = [ pkgs.pass ];

      programs.neomutt = {
        enable = true;
        sidebar = {
          enable = true;
        };
        binds = [
          {
            map = "index";
            key = "" ;
            action = "";
          }
        ];
      };

      # xdg.configFile."neomutt/neomuttrc".source = ./mutt/config/neomuttrc;
      # xdg.configFile."neomutt/colors".source = ./mutt/config/colors;

      # xdg.configFile."neomutt/profile_main".source = mutt/config/profile_main;
      # xdg.configFile."neomutt/profile_work".source = mutt/config/profile_work;

      # xdg.configFile."neomutt/view_attachment.sh".source = mutt/config/view_attachment.sh;
      # xdg.configFile."neomutt/view_attachment.sh".executable = true;

      # xdg.configFile."neomutt/mailcap".source = mutt/config/mailcap;
      # xdg.configFile."neomutt/mailcap_reply".source = mutt/config/mailcap_reply;
    };
  };
}
