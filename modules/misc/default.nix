{ lib, ... }:
with lib;
{
  imports = [
    ./android.nix
    ./books.nix
    ./edu.nix
    ./gaming.nix
    ./ios.nix
    ./spotify.nix
    ./todo.nix
  ];
}
