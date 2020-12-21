{ pkgs ? import <nixpkgs> { }, ... }:

with pkgs;
let
  nix-switch = writeShellScriptBin "nix-switch" ''
    if [ "$#" -eq 0 ]; then
      sudo nixos-rebuild switch --flake "."
    else
      sudo nixos-rebuild switch --flake ".#$1" $2
    fi
  '';

  nix-rebuild = writeShellScriptBin "nix-rebuild" ''
    if [ "$#" -eq 0 ]; then
      sudo nixos-rebuild build --flake "."
    else
      sudo nixos-rebuild build --flake ".#$1" $2
    fi
  '';

  nix-rebuild-vm = writeShellScriptBin "nix-rebuild-vm" ''
    if [ "$#" -eq 0 ]; then
      sudo nixos-rebuild build-vm --flake "."
    else
      sudo nixos-rebuild build-vm --flake ".#$1" $2
    fi
  '';

  nix = writeShellScriptBin "nix" ''
    ${pkgs.nixFlakes}/bin/nix --option experimental-features "nix-command flakes ca-references" "$@"
  '';

in
  pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      git
      git-crypt

      nix
      nix-switch
      nix-rebuild
      nix-rebuild-vm
    ];

    shellHook = ''
      PATH=${pkgs.nix}/bin:$PATH
    '';
  }
