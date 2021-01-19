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

  nix-clean-result = writeShellScriptBin "nix-my-clean-result" ''
    if [  "$1" == "-f" ]
    then
      echo "Deleting..."
      nix-store --gc --print-roots | awk '{print $1}' | grep '/result$' | sudo xargs rm
    else
      nix-store --gc --print-roots | awk '{print $1}' | grep '/result$' | sudo xargs echo
      echo
      echo "To delete run:"
      echo "nix-my-clean-result -f"
    fi
  '';

  nix = writeShellScriptBin "nix" ''
    ${pkgs.nixFlakes}/bin/nix --option experimental-features "nix-command flakes ca-references" "$@"
  '';

  git-crypt-status = writeShellScriptBin "git-crypt-status" ''
    git-crypt status | grep -v not
  '';

  nix-clean-store = writeShellScriptBin "nix-my-clean-store" ''
    nix-collect-garbage -d
    sudo nix-collect-garbage -d
    nix-store --gc
    sudo nix-store --gc
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
      nix-clean-result
      nix-clean-store
    ];

    shellHook = ''
      PATH=${nix}/bin:$PATH
    '';
  }
