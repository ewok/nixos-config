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

            pkgs = import inputs.stable {
                overlays = [ nixpkgs (import ./overlays) nixgl.overlay ];
                config = {
                    allowUnfree = true;
                    allowBroken = true;
                };
            };

            genConfiguration = hostName:
            home-manager.lib.homeManagerConfiguration {
                inherit pkgs;
                modules = [
                    {
                        home = {
                            username = "$username";
                            homeDirectory = homeDirectory;
                            stateVersion = "22.05";
                        };
                    }
                ] ++ [
                    (import (./. + "/machines/${hostName}"))
                ];
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
