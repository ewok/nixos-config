{
  description = "ewoks envs";

  inputs = rec {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:NixOS/nixpkgs/nixos-20.09";
    master.url = "github:nixos/nixpkgs/master";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    # rnix.url = "github:nix-community/rnix-lsp/master";
    # rnix.url = "https://github.com/nix-community/rnix-lsp/archive/master.tar.gz";
    home-manager = {
      url = "github:rycee/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, ... }@inputs:
    let
      lib = inputs.nixpkgs.lib;
      system = "x86_64-linux";
      nixpkgs = final: prev: {
        nixpkgs = import inputs.nixpkgs {
          config.allowUnfree = true;
          inherit system;
        };
      };
    in
      {

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
                      inputs.neovim-nightly-overlay.overlay
                      (import ./overlays)
                    ];
                  }
                  (import (./. + "/machines/${name}"))
                  inputs.home-manager.nixosModules.home-manager
                  inputs.nixpkgs.nixosModules.notDetected
                ];
                specialArgs = { inherit inputs; };
              };
          in
            genAttrs hosts mkHost;
      };
}
