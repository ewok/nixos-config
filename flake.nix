{
  description = "ewoks envs";

  inputs = rec {
    stable.url = "github:NixOS/nixpkgs/nixos-22.05";
    master.url = "github:nixos/nixpkgs/master";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager = {
      url = "github:rycee/home-manager";
      inputs.nixpkgs.follows = "stable";
    };
    nixgl.url = "github:guibou/nixGL";
  };

  outputs = { self, home-manager, nixgl, ... }@inputs:
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
                    nixpkgs.overlays = [ nixpkgs (import ./overlays) nixgl.overlay ];
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
                        nixgl.overlay
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
