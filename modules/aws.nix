{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.opt.aws;
in
{
  options.opt.aws = {
    enable = mkEnableOption "aws";
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      awscli2
      granted
      pass
      gnupg
      pinentry-curses
    ];

    # home.file.".dgranted/config".text = ''
    #   DefaultBrowser = "STDOUT"
    #   CustomBrowserPath = ""
    #   CustomSSOBrowserPath = ""
    #   Ordering = ""
    #   ExportCredentialSuffix = ""
    #
    #   [Keyring]
    #     Backend = "pass"
    # '';

    xdg.configFile."fish/conf.d/99_aws.fish" = {
      text = ''
        if status --is-interactive
          # Installation:
          # gpg --gen-key
          # gpg --list-keys
          # pass init <KEY>
          export GPG_TTY=$(tty)
        end
      '';
    };
  };
}
