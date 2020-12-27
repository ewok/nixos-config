{ pkgs ? import <nixpkgs> { }, ... }:

with pkgs;
let
  nix-switch = writeShellScriptBin "nix-my-switch" ''
    if [ "$#" -eq 0 ]; then
      sudo nixos-rebuild switch --flake "."
    else
      sudo nixos-rebuild switch --flake ".#$1" $2
    fi
  '';

  nix-boot = writeShellScriptBin "nix-my-boot" ''
    if [ "$#" -eq 0 ]; then
      sudo nixos-rebuild boot --flake "."
    else
      sudo nixos-rebuild boot --flake ".#$1" $2
    fi
  '';

  nix-rebuild = writeShellScriptBin "nix-my-rebuild" ''
    if [ "$#" -eq 0 ]; then
      sudo nixos-rebuild build --flake "."
    else
      sudo nixos-rebuild build --flake ".#$1" $2
    fi
  '';

  nix-rebuild-vm = writeShellScriptBin "nix-my-rebuild-vm" ''
    if [ "$#" -eq 0 ]; then
      sudo nixos-rebuild build-vm --flake "."
    else
      sudo nixos-rebuild build-vm --flake ".#$1" $2
    fi
  '';

  nix = writeShellScriptBin "nix" ''
    ${pkgs.nixFlakes}/bin/nix --option experimental-features "nix-command flakes ca-references" "$@"
  '';

  git-crypt-status = writeShellScriptBin "git-crypt-status" ''
    git-crypt status | grep -v not
  '';

in
  pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      git
      git-crypt
      git-crypt-status

      nix
      nix-switch
      nix-rebuild
      nix-rebuild-vm
      nix-boot
    ];

    shellHook = ''
      PATH=${nix}/bin:$PATH
    '';
  }
