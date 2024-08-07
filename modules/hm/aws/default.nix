{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;

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

    home.file.".gnupg/gpg-agent.conf".text = ''
      pinentry-program ~/.nix-profile/bin/pinentry
      default-cache-ttl 604800
      max-cache-ttl 604800
    '';

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

    xdg.configFile."fish/conf.d/99_granted.fish".text =
      let
        assume-fish = ./assume.fish;
      in
      ''
        if status is-interactive
          alias assume="source ${assume-fish}"
        end
      '';
  };
}
