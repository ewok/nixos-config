{ config, lib, pkgs, ... }:
with lib;
let
  mail = config.modules.mail;
  username = config.properties.user.name;
in
{
  config = mkIf mail.enable {
    home-manager.users.${username} = {

      home.packages = [ pkgs.pandoc pkgs.davmail ];

      programs.password-store.enable = true;
      programs.gpg.enable = true;
      services.gpg-agent.enable = true;
      programs.mbsync.enable = true;

      programs.neomutt = {
        enable = true;
        sidebar = {
          enable = true;
          width = 20;
          shortPath = true;
          format = "%D%?F? [%F]?%* %?N?%N/? %?S?%S?";
        };

        binds = [
          # index
          { key = "_"; action = "collapse-all"; }
          { key = "-"; action = "collapse-thread"; }
          { key = "G"; action = "last-entry"; }
          { key = "U"; action = "undelete-message"; }
          { key = "u"; action = "half-up"; }
          { key = "\\Cu"; action = "half-up"; }
          { key = "d"; action = "half-down"; }
          { key = "\\Cd"; action = "half-down"; }
          { key = "g"; action = "noop"; }
          { key = "gg"; action = "first-entry"; }
          { key = "j"; action = "next-entry"; }
          { key = "k"; action = "previous-entry"; }
          { key = "S"; action = "save-message"; }
          { key = "s"; action = "sort-mailbox"; }
          { key = "R"; action = "group-reply"; }
          { key = "N"; action = "mail"; }
          { key = "m"; action = "noop"; }
          { key = "\\Ct"; action = "noop"; }
          { key = "\\Ctt"; action = "tag-thread"; }
          { key = "\\Ctp"; action = "tag-pattern"; }
          { key = "\\Ctu"; action = "untag-pattern"; }
          { key = "F"; action = "imap-fetch-mail"; }
          { key = "o"; action = "sidebar-open"; }
          { key = "\\Co"; action = "sidebar-open"; }
          { key = "\\Co"; action = "sidebar-open"; }
          { key = "\\Cp"; action = "sidebar-prev"; }
          { key = "\\Cn"; action = "sidebar-next"; }
          { key = "B"; action = "sidebar-toggle-visible"; }

          # pager
          { map = "pager"; key = "u"; action = "half-up"; }
          { map = "pager"; key = "\\Cu"; action = "half-up"; }
          { map = "pager"; key = "d"; action = "half-down"; }
          { map = "pager"; key = "\\Cd"; action = "half-down"; }
          { map = "pager"; key = "g"; action = "noop"; }
          { map = "pager"; key = "G"; action = "bottom"; }
          { map = "pager"; key = "gg"; action = "top"; }
          { map = "pager"; key = "j"; action = "next-line"; }
          { map = "pager"; key = "k"; action = "previous-line"; }
          { map = "pager"; key = "S"; action = "save-message"; }
          { map = "pager"; key = "R"; action = "group-reply"; }
          { map = "pager"; key = "\\Cp"; action = "previous-undeleted"; }
          { map = "pager"; key = "\\Cn"; action = "next-undeleted"; }
          { map = "pager"; key = "N"; action = "mail"; }
          { map = "pager"; key = "m"; action = "noop"; }

          # editor
          { map = "editor"; key = "<space>"; action = "noop"; }

          # attach
          { map = "attach"; key = "<return>"; action = "view-mailcap"; }
        ];

        macros = [

          {
            key = "S";
            action = "<save-entry><kill-line>~/Downloads/";
          }

          {
            map = "attach";
            key = "S";
            action = "<save-entry><kill-line>~/Downloads/";
          }

          {
            map = "compose";
            key = "\\Cr";
            action = "F pandoc -s -f markdown_mmd -t html \\ny^T^Utext/html; charset=utf-8\\n";
          }

          {
            map = "compose";
            key = "\\Cy";
            action = "F pandoc -s -f markdown_mmd -t html \\ny^T^Utext/html; charset=utf-8\\n";
          }

          # {
          #   key = "<F8>";
          #   action = ''
          #     <enter-command>set my_old_pipe_decode=\$pipe_decode my_old_wait_key=\$wait_key nopipe_decode nowait_key<enter>\
          #     <shell-escape>notmuch new;clear<enter>\
          #     <shell-escape>notmuch-mutt -r --prompt search<enter>\
          #     <change-folder-readonly>`echo ''${XDG_CACHE_HOME:-$HOME/.cache}/notmuch/mutt/results`<enter>\
          #     <enter-command>set pipe_decode=\$my_old_pipe_decode wait_key=\$my_old_wait_key<enter> \
          #     "notmuch: search mail"
          #   '';
          # }

        ];

        settings = {
          mailcap_path = "~/.config/neomutt/mailcap";
          sort = "threads";
          strict_threads = "yes";
          sort_browser = "reverse-date";
          sort_aux = "reverse-last-date-received";
          mail_check = "60";
          timeout = "15";

          date_format = ''"%m/%d %I:%M"'';
          index_format = ''"%2C %Z %?X?A& ? %D %-15.15F %s (%-4.4c)"'';
          pager_context = "3";
          pager_index_lines   = "10";

          markers = "no";
          mark_old = "no";
          mime_forward = "yes";
          wait_key = "no";
          rfc2047_parameters = "yes";

          sidebar_next_new_wrap = "yes";

          delete = "yes";
          auto_tag = "yes";
          use_from = "yes";
          envelope_from = "yes";
        };

        extraConfig = ''
          source ~/.config/neomutt/colors
          unset collapse_unread
          send2-hook . 'set mailcap_path=~/.config/neomutt/mailcap'
          set fast_reply           # skip to compose when replying
          set fcc_attach           # save attachments with the body
          unset mime_forward       # forward attachments as part of body
          set forward_format = "Fwd: %s"       # format of subject when forwarding
          set forward_decode                   # decode when forwarding
          set forward_quote                    # include message in forwards
          set reverse_name                     # reply as whomever it was to
          set include                          # include message in replies

          auto_view text/html application/text application/pdf
          alternative_order text/enriched text/html text/plain text

          set mail_check_stats
          set sidebar_delim_chars="/"
          set sidebar_new_mail_only = no
          set sidebar_non_empty_mailbox_only = no
          set sidebar_sort_method = 'name'
        '';
      };

      xdg.configFile."neomutt/colors".source = ./mutt/config/colors;

      xdg.configFile."neomutt/view_attachment.sh".source = mutt/config/view_attachment.sh;
      xdg.configFile."neomutt/view_attachment.sh".executable = true;

      xdg.configFile."neomutt/mailcap".source = mutt/config/mailcap;
      xdg.configFile."neomutt/mailcap_reply".source = mutt/config/mailcap_reply;
    };
  };
}
