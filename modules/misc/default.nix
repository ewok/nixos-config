{ lib, ... }:
with lib;
{
  imports = [
    ./edu.nix
    ./gaming.nix
    ./spotify.nix
  ];
}

