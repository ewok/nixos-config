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
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { nixpkgs-unstable, home-manager, nix-on-droid, darwin, flake-utils, ... }@inputs:

    let
      nixpkgsDefaults = {
        config = {
          allowUnfree = true;
        };
      };
      modules = map (n: ./modules/hm + "/${n}") (builtins.attrNames (builtins.readDir ./modules/hm));
      overlays = [
        inputs.neovim-nightly-overlay.overlays.default
      ];
    in
    {

      homeConfigurations.sd =
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
            ./machines/sd
            {
              imports = modules;
              _module.args.utils = import utils/lib.nix { inherit pkgs; };
            }
          ];
        };

      # homeConfigurations.cnt =
      #   let
      #     pkgs = import inputs.nixpkgs-unstable (nixpkgsDefaults // {
      #       system = "x86_64-linux";
      #     });
      #     inherit modules;
      #   in
      #   home-manager.lib.homeManagerConfiguration {
      #     inherit pkgs;
      #     modules = [
      #       ./machines/common.nix
      #       ./machines/cnt
      #       {
      #         imports = modules;
      #         _module.args.utils = import utils/lib.nix { inherit pkgs; };
      #       }
      #     ];
      #   };

      homeConfigurations.rpi =
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
            ./machines/rpi
            {
              imports = modules;
              _module.args.utils = import utils/lib.nix { inherit pkgs; };
            }
          ];
        };

      nixosConfigurations.bup =
        let
          system = "aarch64-linux";
        in
        nixpkgs-unstable.lib.nixosSystem {
          inherit system;
          modules = [
            ./machines/common.nix
            ./machines/bup
            home-manager.nixosModules.default
            # {
            #   nixpkgs.overlays = overlays;
            # }
          ];
        };


      nixosConfigurations.orb =
        let
          system = "aarch64-linux";
        in
        nixpkgs-unstable.lib.nixosSystem {
          inherit system;
          modules = [
            ./machines/common.nix
            ./machines/orb
            home-manager.nixosModules.default
            # {
            #   nixpkgs.overlays = overlays;
            # }
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

      nixOnDroidConfigurations.droid =
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
            ./machines/droid
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
        with pkgs; mkShell {
          packages =
            let

              nixosMy = writeShellScriptBin "n" ''
                if [ "$#" -eq 0 ]; then
                  echo "Provide a command as a first argument please."
                  echo "crypt, clean, update, b, s"
                  echo "b(uild), s(witch) [h(m)|n(ixos)|d(roid)|dw(darwin)]"

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
                elif [ "$#" -eq 2 ]; then

                  CMD=""
                  if [ "$1" == "b" ]; then
                    CMD="build"
                  elif [ "$1" == "s" ]; then
                    CMD="switch"
                  else
                    echo "'$1' wrong, possible b(uild), s(witch)"
                    exit 1
                  fi

                # SteamDeck
                # CNT
                # RPI
                  if [ "$2" == "sd" ] || [ "$2" == "rpi" ]; then
                    CMD="nix run home-manager -- $CMD"
                # nixos
                # orb
                  elif [ "$2" == "bup" ] || [ "$2" == "orb" ]; then
                    CMD="sudo nixos-rebuild $CMD --impure"
                # droid
                  elif [ "$2" == "droid" ]; then
                    CMD="nix-on-droid $CMD"
                # mac
                  elif [ "$2" == "mac" ]; then
                    CMD="nix run nix-darwin -- $CMD"
                  else
                    echo "'$2' wrong, possible options: sd, rpi, bup, orb, droid, mac"
                    exit 1
                  fi
                  CMD="$CMD --flake .#$2"


                  $CMD
                fi
              '';

              git-crypt-status = writeShellScriptBin "git-crypt-status" ''
                git-crypt status -e
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
            ];

          shellHook = ''
            export NIXPKGS_ALLOW_UNFREE=1
            git-crypt-status
          '';
        };
    });
}
