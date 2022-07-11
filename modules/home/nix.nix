{ config, lib, pkgs, inputs, ... }:
with lib;
let
  nix = pkgs.writeShellScriptBin "nix-my" ''
    ${pkgs.nixFlakes}/bin/nix --option experimental-features "nix-command flakes" "$@"
  '';
in
{
  config = {
      home.packages = [nix];
      xdg.configFile."nix/nix.conf".text = ''
        keep-outputs = true       # Nice for developers
        keep-derivations = true   # Idem
        auto-optimise-store = true
        experimental-features = nix-command flakes
      '';
    };
}
