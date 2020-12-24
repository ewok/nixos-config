{ lib, ... }:
with lib;
{
  imports = [
    # Backup:
    # Always enabled
    ./restic.nix
    ./rclone.nix

    # Disabled by default
    ./rslsync.nix
    ./cryptomator.nix
  ];
  options.modules.backup = {
    enable = mkOption {
      type = types.bool;
      description = "Enable backup soft and settings.";
      default = false;
    };
  };
}
