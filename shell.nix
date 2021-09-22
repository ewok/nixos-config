{ pkgs ? import <nixpkgs> {}, ... }:

with pkgs;
let

  nixosMy = writeShellScriptBin "n" ''
    if [ "$#" -eq 0 ]; then
      echo "Provide a command as a first argument please."
      echo "Usual nixos-rebuild commands + clean, clean-result, update-nix, update-all, crypt"

    elif [ "$#" -eq 1 ]; then

      if [ "$1" == "clean-result" ];then
        nix-store --gc --print-roots | awk '{print $1}' | grep '/result$' | sudo xargs rm

      elif [ "$1" == "crypt" ];then
        ${git-crypt-status}/bin/git-crypt-status

      elif [ "$1" == "clean" ];then
        nix-collect-garbage -d
        sudo nix-collect-garbage -d
        nix-store --gc
        sudo nix-store --gc

      elif [ "$1" == "update-nix" ];then
        for flake in stable nixpkgs master home-manager;
        do
          nix flake update --update-input $flake
        done

      elif [ "$1" == "update-all" ];then
        for flake in stable nixpkgs master nixos-hardware neovim-nightly-overlay home-manager;
        do
          nix flake update --update-input $flake
        done

      else
        sudo nixos-rebuild $1 --show-trace --verbose --flake "."
      fi

    else
      sudo nixos-rebuild $1 --show-trace --verbose --flake ".#$2" $3
    fi
    ${nix-copy-nas}/bin/nix-copy-nas /run/current-system
  '';

  # nix = writeShellScriptBin "nix" ''
  #   ${pkgs.nixFlakes}/bin/nix --option experimental-features "nix-command flakes ca-references" "$@"
  # '';

  git-crypt-status = writeShellScriptBin "git-crypt-status" ''
    git-crypt status | grep -v not
  '';

  nvim-test = writeShellScriptBin "nvim-test" ''
    nvim -u ./home/dev/neovim/config/init.lua $@
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
    nix-copy-nas

    nvim-test
  ];

  shellHook = ''
    # PATH=${nix}/bin:$PATH
    git-crypt-status
  '';
}
