{
  description = "ewoks envs";

  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Darwin
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Home Manager(linux)
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Android related
    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = { self, home-manager, nix-on-droid, darwin, ... }@inputs:
    let
      inherit (inputs.nixpkgs-unstable.lib) genAttrs;
      nixpkgsDefaults = {
        config = {
          allowUnfree = true;
        };
      };
      modules = map (n: ./modules + "/${n}") (builtins.attrNames (builtins.readDir ./modules));
    in
    {

      homeConfigurations.steamdeck =
        let
          pkgs = import inputs.nixpkgs-unstable (nixpkgsDefaults // {
            system = "x86_64-linux";
          });
          inherit modules;
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./machines/common.nix
            ./machines/steamdeck
            {
              imports = modules;
              _module.args.utils = import utils/lib.nix { inherit pkgs; };
            }
          ];
        };

      homeConfigurations.orb =
        let
          pkgs = import inputs.nixpkgs-unstable (nixpkgsDefaults // {
            system = "aarch64-linux";
          });
          inherit modules;
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./machines/common.nix
            ./machines/orb
            {
              imports = modules;
              _module.args.utils = import utils/lib.nix { inherit pkgs; };
            }
          ];
        };

      darwinConfigurations.mac =
        let
          pkgs = import inputs.nixpkgs-unstable (nixpkgsDefaults // {
            system = "aarch64-darwin";
          });
        in
        darwin.lib.darwinSystem {
          inherit pkgs;
          modules = [
            ./machines/common.nix
            ./machines/mac
            home-manager.darwinModules.home-manager
          ];
        };

      nixOnDroidConfigurations.android =
        let
          pkgs = import inputs.nixpkgs-unstable (nixpkgsDefaults // {
            system = "aarch64-linux";
          });
          inherit modules;
        in
        nix-on-droid.lib.nixOnDroidConfiguration {
          inherit pkgs;
          modules = [
            ./machines/common.nix
            ./machines/android
            {
              home-manager.config = {
                imports = modules;
                _module.args.utils = import utils/lib.nix { inherit pkgs; };
              };
            }
          ];
        };
    };
}
