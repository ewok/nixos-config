{
  description = "ewoks envs";

  inputs = rec {
    stable.url = "github:NixOS/nixpkgs/nixos-20.09";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    master.url = "github:nixos/nixpkgs/master";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    neovim-nightly-overlay.url = "github:mjlbach/neovim-nightly-overlay";
    # rnix.url = "github:nix-community/rnix-lsp/master";
    # rnix.url = "https://github.com/nix-community/rnix-lsp/archive/master.tar.gz";
    home-manager = {
      url = "github:rycee/home-manager";
      inputs.nixpkgs.follows = "unstable";
    };
  };

  outputs = { self, ... }@inputs:
    let
      lib = inputs.unstable.lib;
      system = "x86_64-linux";
      unstable = final: prev: {
        unstable = import inputs.unstable {
          config.allowUnfree = true;
          inherit system;
        };
      };
    in {

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
                unstable
                inputs.neovim-nightly-overlay.overlay
                (import ./overlays)
              ];
            }
            (import (./. + "/machines/${name}"))
            inputs.home-manager.nixosModules.home-manager
            inputs.unstable.nixosModules.notDetected
          ];
          specialArgs = { inherit inputs; };
        };
      in genAttrs hosts mkHost;
    };
  }
