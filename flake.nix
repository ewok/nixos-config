{
  description = "ewoks envs";

  inputs = rec {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:NixOS/nixpkgs/nixos-22.05";
    master.url = "github:nixos/nixpkgs/master";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    # neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    # rnix.url = "github:nix-community/rnix-lsp/master";
    # rnix.url = "https://github.com/nix-community/rnix-lsp/archive/master.tar.gz";
    home-manager = {
      url = "github:rycee/home-manager";
      inputs.nixpkgs.follows = "stable";
    };
  };

  outputs = { self, home-manager, ... }@inputs:
    let
      lib = inputs.stable.lib;
      system = "x86_64-linux";
      username = "ataranchiev";
      homeDirectory = "/home/${username}";
      nixpkgs = final: prev: {
        nixpkgs = import inputs.stable {
          config.allowUnfree = true;
          inherit system;
        };
      };
    in
    {
        homeConfigurations = with lib;
        let
            hosts = map (fname: builtins.head (builtins.match "(.*)" fname))
            (builtins.attrNames (builtins.readDir ./machines));

        genConfiguration = hostName:
            home-manager.lib.homeManagerConfiguration {

                # TODO: Extract to file
                inherit username;
                inherit homeDirectory;
                inherit system;

                configuration = { config, pkgs, ... }:
                {
                    nixpkgs.overlays = [ nixpkgs (import ./overlays) ];
                    nixpkgs.config = {
                        allowUnfree = true;
                        allowBroken = true;
                    };

                    imports = [
                        (import (./. + "/machines/${hostName}"))
                    ];
                };
                stateVersion = "22.05";
            };
        in
            genAttrs hosts genConfiguration;

        nixosConfigurations = with lib;
        let
            hosts = map (fname: builtins.head (builtins.match "(.*)" fname))
            (builtins.attrNames (builtins.readDir ./machines));
        mkHost = name:
            nixosSystem {
                inherit system;
                modules = [
                {
                    nixpkgs.overlays = [
                        nixpkgs
                        # inputs.neovim-nightly-overlay.overlay
                        (import ./overlays)
                    ];
                }
                (import (./. + "/machines/${name}"))
                    inputs.home-manager.nixosModules.home-manager
                    inputs.stable.nixosModules.notDetected
                ];
                specialArgs = { inherit inputs; };
            };
        in
            genAttrs hosts mkHost;
    };
}
