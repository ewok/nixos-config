{ config, lib, pkgs, ... }:
let
  inherit (config) colors theme;
  homeDirectory = "/data/data/com.termux.nix/files/home";
  usrDirectory = "/data/data/com.termux.nix/files/usr";
in
{
  imports = [
    ./secrets.nix
  ];

  config = {

    terminal.font = "${pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; }}/share/fonts/truetype/NerdFonts/FiraCodeNerdFontMono-Regular.ttf";

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
            tmux = {
              enable = true;
              inherit colors theme;
            };
            vifm.enable = true;
            fish.enable = true;
            fish.homeDirectory = homeDirectory;
            starship.enable = true;
            git.enable = true;
            hledger.enable = true;
            svn.enable = true;
            ssh.enable = true;
            kube.enable = false;
            bw.enable = false;
            nix.enable = true;
            lisps.enable = true;
            direnv.enable = true;
          };

        home.username = "nix-on-droid";
        home.homeDirectory = homeDirectory;
        home.stateVersion = "23.11";

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

    environment.packages = with pkgs; [
      diffutils
      findutils
      utillinux
      tzdata
      hostname
      man
      gnugrep
      gnused
      openssh
      git
      which
    ];
  };
}
