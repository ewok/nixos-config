self: super:
{
  sof-firmware = super.callPackage ./sof-firmware.nix {};
  # zeal = super.libsForQt5.callPackage ./zeal.nix { };
  lbry = super.callPackage ./lbry.nix {};
  sparkleshare = super.callPackage ./sparkleshare.nix {};
  todofish = super.callPackage ./todofish.nix {};
  rofi-bluetooth = super.callPackage ./rofi-bluetooth.nix {};
  todo-txt-again = super.callPackage ./todoagain.nix {};
  qtile-plasma = super.python37Packages.callPackage ./qtile-plasma.nix {};

  qtile = super.qtile.overrideAttrs (
    oldAttrs: rec {
      pythonPath = oldAttrs.pythonPath ++ [ self.qtile-plasma ];
    }
  );

  # enpass-my = super.enpass.overrideAttrs (
  #   oldAttrs: rec {
  #     version = "6.6.1.809";

  #     src = super.fetchurl {
  #       sha256 = "b1b9bd67653c3163bd80b340150ecf123552cbe4af23c350fbadea8ffd7939ba";
  #       url = "http://repo.sinew.in/pool/main/e/enpass/enpass_6.6.1.809_amd64.deb";
  #     };
  #   }
  # );

  filebot = super.filebot.overrideAttrs (
    oldAttrs: rec {
      installPhase = ''
        mkdir -p $out/opt $out/bin
        # Since FileBot has dependencies on relative paths between files, all required files are copied to the same location as is.
        cp -r filebot.sh lib/ jar/ $out/opt/
        # Filebot writes to $APP_DATA, which fails due to read-only filesystem. Using current user .local directory instead.
        substituteInPlace $out/opt/filebot.sh \
          --replace 'APP_DATA="$FILEBOT_HOME/data/$(id -u)"' 'APP_DATA=''${XDG_DATA_HOME:-$HOME/.local/share}/filebot/data' \
          --replace '$FILEBOT_HOME/data/.license' '$APP_DATA/.license'
        wrapProgram $out/opt/filebot.sh \
          --prefix PATH : ${super.lib.makeBinPath [ super.jdk ]}
        # Expose the binary in bin to make runnable.
        ln -s $out/opt/filebot.sh $out/bin/filebot
      '';
    }
  );

}
