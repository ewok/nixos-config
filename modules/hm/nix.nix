{ config, lib, pkgs, ... }:
let
  cfg = config.opt.nix;
  ncps-run = pkgs.writeShellScriptBin "ncps-run" ''
    #!/bin/env bash
    set -e
    mkdir -p nix-cache-data
    podman run -ti -v ./nix-cache-data:/storage:z alpine:latest \
    /bin/sh -c "mkdir -m 0755 -p /storage/var && mkdir -m 0700 -p /storage/var/ncps && mkdir -m 0700 -p /storage/var/ncps/db"

    podman run -ti -v ./nix-cache-data:/storage:z kalbasit/ncps:latest \
    /bin/dbmate --url=sqlite:/storage/var/ncps/db/db.sqlite migrate up

    podman run -ti -v ./nix-cache-data:/storage:z  -p 5000:8501 kalbasit/ncps:latest \
        /bin/ncps serve \
        --cache-hostname=ewok-lgo.ewok.email \
        --cache-data-path=/storage \
        --cache-database-url=sqlite:/storage/var/ncps/db/db.sqlite \
        --upstream-cache=https://cache.nixos.org \
        --upstream-cache=https://nix-community.cachix.org \
        --upstream-public-key=cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= \
        --upstream-public-key=nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=
  '';
in
{
  options.opt.nix = {
    enable = lib.mkEnableOption "nix";
  };

  config = lib.mkIf cfg.enable {

    home.packages = with pkgs; [
      ncps-run
      nix-tree
      # cachix use nix-community
      cachix
      nix-index
      ncps
      # nix-serve
      devenv
    ];
  };
}
