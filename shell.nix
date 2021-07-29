{ pkgs ? import <nixpkgs> {}, ... }:

with pkgs;
let
  nix-test = writeShellScriptBin "nix-my-test" ''
    if [ "$#" -eq 0 ]; then
      sudo nixos-rebuild test --fast --verbose --flake "."
    else
      sudo nixos-rebuild test --fast --verbose --flake ".#$1" $2
    fi
  '';

  nixosMy = writeShellScriptBin "n" ''
    if [ "$#" -eq 0 ]; then
      echo "Provide a command as a first argument please."
    elif [ "$#" -eq 1 ]; then
      sudo nixos-rebuild $1 --flake "." --verbose
    else
      sudo nixos-rebuild $1 --flake ".#$2" $3 --verbose
    fi
    ${nix-copy-nas}/bin/nix-copy-nas /run/current-system
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

  nix-update-all = writeShellScriptBin "nix-my-update-all" ''
    for flake in stable nixpkgs master nixos-hardware neovim-nightly-overlay home-manager;
    do
      nix flake update --update-input $flake
    done
  '';

  nix-update-nix = writeShellScriptBin "nix-my-update-nix" ''
    for flake in stable nixpkgs master home-manager;
    do
      nix flake update --update-input $flake
    done
  '';

  # nix = writeShellScriptBin "nix" ''
  #   ${pkgs.nixFlakes}/bin/nix --option experimental-features "nix-command flakes ca-references" "$@"
  # '';

  git-crypt-status = writeShellScriptBin "git-crypt-status" ''
    git-crypt status | grep -v not
  '';

  nix-clean-store = writeShellScriptBin "nix-my-clean-store" ''
    nix-collect-garbage -d
    sudo nix-collect-garbage -d
    nix-store --gc
    sudo nix-store --gc
  '';

  nvim-test = writeShellScriptBin "nvim-test" ''
    nvim -u ./modules/dev/neovim/config/init.lua $@
  '';

  nix-copy-nas = writeShellScriptBin "nix-copy-nas" ''
    nix copy --to 's3://store?endpoint=http://nas:9000' "$@"
  '';

in
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    git
    git-crypt
    git-crypt-status

    nixFlakes
    nixosMy
    nix-clean-result
    nix-clean-store
    nix-update-all
    nix-update-nix
    nix-test
    nix-copy-nas

    nvim-test
  ];

  shellHook = ''
    # PATH=${nix}/bin:$PATH
    git-crypt-status
  '';
}
