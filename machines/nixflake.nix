{ pkgs, ... }:

{

  nixpkgs.config = {
    allowUnfree = true;
    allowedUsers = [ "@wheel" ];
    trustedUsers = [ "@wheel" ];
  };

  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
    experimental-features = nix-command flakes
  '';

  nix = {
    package = pkgs.nixFlakes;
  };

}
