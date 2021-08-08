{ lib, ... }:
with lib;
{
  imports = [
    ./android.nix
    ./books.nix
    ./edu.nix
    ./gaming.nix
    ./spotify.nix
    ./todo.nix
  ];
}
