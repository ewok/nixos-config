{ lib, ... }:
with lib;
{
  imports = [
    ./books.nix
    ./edu.nix
    ./gaming.nix
    ./spotify.nix
    ./todo.nix
  ];
}

