{ lib, ... }:
with lib;
{
  imports = [
    ./spotify.nix
    ./steam.nix
  ];
}

