{
  description = "ewoks envs";

  inputs = rec {
    stable.url = "github:NixOS/nixpkgs/nixos-20.09";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    neovim-nightly-overlay.url = "github:mjlbach/neovim-nightly-overlay";
    home-manager = {
      url = "github:rycee/home-manager";
      inputs.nixpkgs.follows = "unstable";
    };
    my-nixpkgs.url = "github:ewok/nixpkgs";

  };

  outputs = { self, ... }@inputs:
    let
      lib = inputs.unstable.lib;
      system = "x86_64-linux";
      unstable = final: prev: {
        unstable = (import inputs.unstable {
          config.allowUnfree = true;
          inherit system;
        });
      };
    in {

      # nixosModules = { roles = (import ./roles/default.nix); };

      nixosConfigurations = {
        nixbox = lib.nixosSystem {
          inherit system;
          modules = [
            {
              nixpkgs.overlays = [
                unstable
                inputs.neovim-nightly-overlay.overlay
              ];
            }

            (import ./machines/nixbox)
            inputs.home-manager.nixosModules.home-manager
            inputs.unstable.nixosModules.notDetected
          ];
          specialArgs = { inherit inputs; };
        };
        main = lib.nixosSystem {
          inherit system;
          modules = [
            {
              nixpkgs.overlays = [
                unstable
                inputs.neovim-nightly-overlay.overlay
              ];
            }

            (import ./machines/main)
            inputs.home-manager.nixosModules.home-manager
            inputs.unstable.nixosModules.notDetected
          ];
          specialArgs = { inherit inputs; };
        };
        working = lib.nixosSystem {
          inherit system;
          modules = [
            {
              nixpkgs.overlays = [
                unstable
                inputs.neovim-nightly-overlay.overlay
              ];
            }

            (import ./machines/working)
            inputs.home-manager.nixosModules.home-manager
            inputs.unstable.nixosModules.notDetected
          ];
          specialArgs = { inherit inputs; };
        };
        terminal = lib.nixosSystem {
          inherit system;
          modules = [
            {
              nixpkgs.overlays = [
                unstable
                inputs.neovim-nightly-overlay.overlay
              ];
            }

            (import ./machines/terminal)
            inputs.home-manager.nixosModules.home-manager
            inputs.unstable.nixosModules.notDetected
          ];
          specialArgs = { inherit inputs; };
        };
      };

    nixbox = inputs.self.nixosConfigurations.nixbox.config.system.build.toplevel;
    working = inputs.self.nixosConfigurations.working.config.system.build.toplevel;
    main = inputs.self.nixosConfigurations.main.config.system.build.toplevel;
    terminal = inputs.self.nixosConfigurations.terminal.config.system.build.toplevel;
  };
}
