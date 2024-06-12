{
  description = "ewoks envs";

  inputs = {
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
      url = "github:nix-community/nix-on-droid";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.home-manager.follows = "home-manager";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs-unstable, home-manager, nix-on-droid, darwin, flake-utils, ... }@inputs:

    let
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

      homeConfigurations.cnt =
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
            ./machines/cnt
            {
              imports = modules;
              _module.args.utils = import utils/lib.nix { inherit pkgs; };
            }
          ];
        };

      nixosConfigurations.orb =
        let
          # pkgs = import inputs.nixpkgs-unstable (nixpkgsDefaults // {
          #   system = "aarch64-linux";
          # });
          system = "aarch64-linux";
          inherit modules;
        in
        nixpkgs-unstable.lib.nixosSystem {
          inherit system;
          modules = [
            ./machines/common.nix
            ./machines/orb
            home-manager.nixosModules.default
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

    } // flake-utils.lib.eachDefaultSystem (system: {
      devShells.default =
        let
          pkgs = import inputs.nixpkgs-unstable (nixpkgsDefaults // {
            system = "${system}";
          });
        in
        with pkgs; pkgs.mkShell {
          packages =
            let

              nixosMy = writeShellScriptBin "n" ''
                if [ "$#" -eq 0 ]; then
                  echo "Provide a command as a first argument please."
                  echo "Usual nixos-rebuild commands + clean, update, crypt"

                elif [ "$#" -eq 1 ]; then

                  if [ "$1" == "crypt" ];then
                    ${git-crypt-status}/bin/git-crypt-status

                  elif [ "$1" == "clean" ];then
                    nix-store --gc --print-roots | awk '{print $1}' | grep '/result$' | sudo xargs rm
                    nix-collect-garbage -d
                    nix-store --gc
                    sudo nix-collect-garbage -d || echo error running sudo
                    sudo nix-store --gc || echo error running sudo

                  elif [ "$1" == "update" ];then
                      nix flake update
                  fi
                fi
              '';

              git-crypt-status = writeShellScriptBin "git-crypt-status" ''
                git-crypt status -e
              '';

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
                nix run home-manager -- switch -b bakup --flake '.#steamdeck'
              '';
              n-cnt-build = writeShellScriptBin "n-cnt-build" ''
                nix run home-manager -- build --flake '.#cnt'
              '';
              n-cnt-switch = writeShellScriptBin "n-cnt-switch" ''
                nix run home-manager -- switch -b bakup --flake '.#cnt'
              '';
              n-orb-build = writeShellScriptBin "n-orb-build" ''
                sudo nixos-rebuild build --flake '.#orb' --impure
              '';
              n-orb-switch = writeShellScriptBin "n-orb-switch" ''
                sudo nixos-rebuild switch --flake '.#orb' --impure
              '';
            in
            [
              git
              git-crypt
              git-crypt-status
              nixosMy
              nixpkgs-fmt
              neovim
              nix
              n-darwin-build
              n-darwin-switch
              n-droid-build
              n-droid-switch
              n-steam-build
              n-steam-switch
              n-orb-build
              n-orb-switch
              n-cnt-build
              n-cnt-switch
            ];

          shellHook = ''
            export NIXPKGS_ALLOW_UNFREE=1
            git-crypt-status
          '';
        };
    });
}
