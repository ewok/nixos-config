self: super:
{
  sof-firmware = super.callPackage ./sof-firmware.nix { };
  # zeal = super.libsForQt5.callPackage ./zeal.nix { };
  cryptomator = super.callPackage ./cryptomator.nix { };
  lbry = super.callPackage ./lbry.nix { };
  sparkleshare = super.callPackage ./sparkleshare.nix { };
  todofish = super.callPackage ./todofish.nix { };
  rofi-bluetooth = super.callPackage ./rofi-bluetooth.nix { };
  todo-txt-again = super.callPackage ./todoagain.nix { };
}
