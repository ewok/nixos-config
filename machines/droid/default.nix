{ config, pkgs, ... }:
let
  inherit (config) colors theme exchange_api_key openai_token fullName email workEmail authorizedKeys ssh_config;

  username = "nix-on-droid";
  homeDirectory = "/data/data/com.termux.nix/files/home";
in
{
  config = {
    system.stateVersion = "23.11";

    environment.packages = with pkgs; [
      diffutils
      findutils
      util-linux
      tzdata
      hostname
      man
      gnugrep
      gnused
      openssh
      git
      which
    ];

    terminal.font = "${pkgs.maple-mono.NF-unhinted}/share/fonts/truetype/MapleMono-NF-Regular.ttf";
    # terminal.font = "${pkgs.nerd-fonts.fira-code}/share/fonts/truetype/NerdFonts/FiraCode/FiraCodeNerdFontMono-Regular.ttf";

    home-manager = {
      useGlobalPkgs = true;
      backupFileExtension = "backup";

      config = { lib, ... }: {

        opt =
          {
            nvim = {
              enable = true;
              inherit colors theme;
              android = true;
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
            hledger = {
              enable = false;
              inherit exchange_api_key;
            };
            svn.enable = true;
            ssh = {
              inherit authorizedKeys;
              config = ssh_config;
              enable = true;
              homeDirectory = homeDirectory;
            };
            kube.enable = false;
            bw.enable = false;
            nix.enable = true;
            languages.lisps.enable = false;
            languages.go.enable = true;
            direnv.enable = true;
            ai.enable = true;
            terminal = {
              enable = true;
              inherit colors theme;
              tmux = {
                enable = true;
              };
            };
          };

        home.username = username;
        home.homeDirectory = homeDirectory;
        home.stateVersion = "24.11";

        # TODO: Inherit Theme
        home.activation = {
          copyTheme =
            let
              colors-properties = pkgs.writeText "colors.properties" ''
                foreground=#${colors.base05}
                background=#${colors.base00}
                cursor=#${colors.base05}

                color0=#${colors.base00}
                color1=#${colors.base08}
                color2=#${colors.base0B}
                color3=#${colors.base0A}
                color4=#${colors.base0D}
                color5=#${colors.base0E}
                color6=#${colors.base0C}
                color7=#${colors.base05}

                color8=#${colors.base03}
                color9=#${colors.base08}
                color10=#${colors.base0B}
                color11=#${colors.base0A}
                color12=#${colors.base0D}
                color13=#${colors.base0E}
                color14=#${colors.base0C}
                color15=#${colors.base07}

                color16=#${colors.base09}
                color17=#${colors.base0F}
                color18=#${colors.base01}
                color19=#${colors.base02}
                color20=#${colors.base04}
                color21=#${colors.base06}
              '';
              theme_src = "${colors-properties}";
              theme_dst = "${homeDirectory}/.termux/colors.properties";
            in
            lib.hm.dag.entryAfter [ "writeBoundary" ] ''
              ( test ! -e "${theme_dst}" || test $(sha1sum "${theme_src}"|cut -d' ' -f1 ) != $(sha1sum "${theme_dst}" |cut -d' ' -f1)) && $DRY_RUN_CMD install $VERBOSE_ARG -D "${theme_src}" "${theme_dst}"
            '';
        };
      };
    };
  };
}
