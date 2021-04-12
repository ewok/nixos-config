self: super:
{
  sof-firmware = super.callPackage ./sof-firmware.nix {};
  # zeal = super.libsForQt5.callPackage ./zeal.nix { };
  cryptomator = super.callPackage ./cryptomator.nix {};
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

  enpass-my = super.enpass.overrideAttrs (
    oldAttrs: rec {
      version = "6.6.1.809";

      src = super.fetchurl {
        sha256 = "b1b9bd67653c3163bd80b340150ecf123552cbe4af23c350fbadea8ffd7939ba";
        url = "http://repo.sinew.in/pool/main/e/enpass/enpass_6.6.1.809_amd64.deb";
      };
    }
  );
}
