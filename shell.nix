{ pkgs ? import <nixpkgs> { }, ... }:

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
        # sudo nix-collect-garbage -d
        nix-store --gc
        # sudo nix-store --gc

      # elif [ "$1" == "update-nix" ];then
      #   for flake in stable nixpkgs master home-manager;
      #   do
      #     nix flake update --update-input $flake
      #   done

      elif [ "$1" == "update-all" ];then
        # for flake in stable nixpkgs master nixos-hardware neovim-nightly-overlay home-manager;
        # do
          nix flake update
        # done

      elif [ "$1" == "switch" ];then
        sudo nixos-rebuild $1 --show-trace --verbose --flake "."
        # $${nix-copy-nas}/bin/nix-copy-nas /run/current-system
      else
        sudo nixos-rebuild $1 --verbose --flake "."
      fi

    else
      sudo nixos-rebuild $1 --show-trace --verbose --flake ".#$2" $3
    fi
  '';

  hmMy = writeShellScriptBin "hm" ''
    if [ "$#" -eq 0 ]; then
      echo "Provide a command as a first argument please."
      echo "Usual h switch build"

    elif [ "$#" -eq 1 ]; then
      home-manager --impure --flake "." $1
    else
      home-manager --impure --flake ".#$2" $1
    fi
  '';

  nix = writeShellScriptBin "nix" ''
    ${pkgs.nixFlakes}/bin/nix --option experimental-features "nix-command flakes" "$@"
  '';

  git-crypt-status = writeShellScriptBin "git-crypt-status" ''
    git-crypt status -e
  '';

  nvim-test = writeShellScriptBin "nvim-test" ''
    nvim -u ./modules/config/neovim/nvim/init.lua $@
  '';

  # nix-copy-nas = writeShellScriptBin "nix-copy-nas" ''
  #   nix copy --to 's3://store?endpoint=http://nas:9000' "$@"
  # '';

  n-darwin-build = writeShellScriptBin "n-darwin-build" ''
    nix run nix-darwin -- build --flake '.#mac'
    '';
  n-darwin-switch = writeShellScriptBin "n-darwin-switch" ''
    nix run nix-darwin -- switch --flake '.#mac'
    '';
  n-droid-build = writeShellScriptBin "n-droid-build" ''
    nix-on-droid build --flake '.#android'
    '';
  n-droid-switch = writeShellScriptBin "n-droid-switch" ''
    nix-on-droid switch --flake '.#android'
    '';
  n-steam-build = writeShellScriptBin "n-steam-build" ''
    nix run home-manager -- build --flake '.#steamdeck'
    '';
  n-steam-switch = writeShellScriptBin "n-steam-switch" ''
    nix run home-manager -- switch --flake '.#steamdeck'
    '';

in
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    git
    git-crypt
    git-crypt-status

    # nixFlakes
    nixosMy
    #nix-copy-nas
    hmMy
    nixpkgs-fmt

    nvim-test

    neovim
    nix
    n-darwin-build
    n-darwin-switch
    n-droid-build
    n-droid-switch
    n-steam-build
    n-steam-switch
    #rnix-lsp
  ];

  shellHook = ''
    # PATH=${nix}/bin:$PATH
    export NIXPKGS_ALLOW_UNFREE=1
    git-crypt-status
  '';
}
