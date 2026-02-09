{ config, pkgs, ... }:
let
  inherit (config) colors theme exchange_api_key openai_token context7_api_key fullName email workEmail authorizedKeys ssh_config;
  inherit (pkgs) writeShellScriptBin;

  username = "ataranchiev";
  homeDirectory = "/home/${username}";
in
{
  config = {

    nix.settings.trusted-users = [ "root" username ];

    opt =
      {
        ai = {
          enable = true;
          install_opencode = false;
          inherit openai_token context7_api_key;
        };
        nvim = {
          enable = true;
          inherit colors;
          theme = {
            inherit (theme) common nvim;
          };
        };
        vifm.enable = true;
        shell = {
          enable = true;
          homeDirectory = homeDirectory;
          shell = "fish";
        };
        starship.enable = true;
        starship.colors = colors;
        git = {
          enable = true;
          homePath = "${homeDirectory}/";
          workPath = "${homeDirectory}/work/";
          homeEmail = email;
          inherit fullName workEmail;
        };
        ssh = {
          inherit authorizedKeys;
          config = ssh_config;
          enable = true;
          homeDirectory = homeDirectory;
        };
        nix.enable = true;
        languages.go.enable = true;
        terminal = {
          enable = true;
          homeDirectory = homeDirectory;
          inherit colors;
          theme = {
            inherit (theme) common wezterm ghostty;
          };
          zellij.enable = true;
          tmux = {
            enable = false;
            terminal = "xterm-256color";
            install = false;
          };
        };
        direnv.enable = true;
        scripts.enable = true;
      };

    home.username = username;
    home.homeDirectory = homeDirectory;
    home.stateVersion = "25.11";

    nix.package = pkgs.nix;

    # home.file.".termux/font.ttf".source = "${pkgs.maple-mono.NF-unhinted}/share/fonts/truetype/MapleMono-NF-Regular.ttf";

    xdg.configFile."bash/profile.d/00_fix_path_env.sh".text = ''
      . ~/.nix-profile/etc/profile.d//nix.sh
      export PATH="${homeDirectory}/.local/share/parm/bin:$PATH"
    '';
  };
}
