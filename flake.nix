{
  description = "ewoks envs";

  # nixConfig = {
  #   extra-substituters = [
  #     "https://yazi.cachix.org"
  #   ];
  #   extra-trusted-public-keys = [
  #     "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
  #   ];
  # };

  inputs = {
    nixpkgs-unstable = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

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
    # neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    # yazi.url = "github:sxyazi/yazi";
  };

  outputs = { self, nixpkgs-unstable, home-manager, nix-on-droid, darwin, flake-utils, ... }@inputs:

    let
      nixpkgsDefaults = {
        config = {
          allowUnfree = true;
        };
      };
      modules = map (n: ./modules/nixos + "/${n}") (builtins.attrNames (builtins.readDir ./modules/nixos));
      modulesHm = map (n: ./modules/hm + "/${n}") (builtins.attrNames (builtins.readDir ./modules/hm));
      overlays = [
        # inputs.neovim-nightly-overlay.overlays.default
        # yazi.overlays.default
        self.overlays.default
      ];
    in
    {

      overlays.default = import ./overlays { inherit inputs; };

      homeConfigurations.lgo =
        let
          pkgs = import inputs.nixpkgs-unstable (nixpkgsDefaults // {
            system = "x86_64-linux";
          });
          inherit modulesHm;
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./machines/common.nix
            ./machines/lgo
            {
              imports = modulesHm;
              _module.args.utils = import utils/lib.nix { inherit pkgs; };
            }
            {
              nixpkgs.overlays = overlays;
            }
          ];
        };

      homeConfigurations.rpi =
        let
          pkgs = import inputs.nixpkgs-unstable (nixpkgsDefaults // {
            system = "aarch64-linux";
          });
          inherit modulesHm;
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./machines/common.nix
            ./machines/rpi
            {
              imports = modulesHm;
              _module.args.utils = import utils/lib.nix { inherit pkgs; };
            }
          ];
        };

      homeConfigurations.orb =
        let
          pkgs = import inputs.nixpkgs-unstable (nixpkgsDefaults // {
            system = "aarch64-linux";
          });
          inherit modulesHm;
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./machines/common.nix
            ./machines/orb
            {
              imports = modulesHm;
              _module.args.utils = import utils/lib.nix { inherit pkgs; };
            }
            {
              nixpkgs.overlays = overlays;
            }
          ];
        };

      nixosConfigurations.bup =
        let
          system = "x86_64-linux";
          pkgs = import inputs.nixpkgs-unstable (nixpkgsDefaults // {
            system = "x86_64-linux";
          });
        in
        nixpkgs-unstable.lib.nixosSystem {
          inherit system;
          inherit pkgs;
          modules = [
            ./machines/common.nix
            ./machines/bup
            home-manager.nixosModules.default
            # {
            #   nixpkgs.overlays = overlays;
            # }
          ] ++ modules;
        };


      # nixosConfigurations.orb =
      #   let
      #     system = "aarch64-linux";
      #     pkgs = import inputs.nixpkgs-unstable (nixpkgsDefaults // {
      #       system = "aarch64-linux";
      #     });
      #   in
      #   nixpkgs-unstable.lib.nixosSystem {
      #     inherit system;
      #     inherit pkgs;
      #     modules = [
      #       ./machines/common.nix
      #       ./machines/orb
      #       home-manager.nixosModules.default
      #       {
      #         nixpkgs.overlays = overlays;
      #       }
      #     ] ++ modules;
      #   };

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
          inherit modulesHm;
        in
        nix-on-droid.lib.nixOnDroidConfiguration {
          inherit pkgs;
          modules = [
            ./machines/common.nix
            ./machines/droid
            {
              home-manager.config = {
                imports = modulesHm;
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

              nixosMy = writeShellScriptBin "nn" ''

                SUBS_CHECK="--connect-timeout 5 http://ewok-lgo.ewok.email:5000"
                SUBS_CMD="--option substituters http://ewok-lgo.ewok.email:5000 --option trusted-public-keys ewok-lgo.ewok.email:rezvQJxpUcXH3TEgkoM9dJTdceSmf0c+LBoJ3r+9hf4="

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
                  elif [ "$1" == "repair" ];then
                      nix-store --verify --check-contents --repair
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
                  if [ "$2" == "lgo" ] || [ "$2" == "rpi" ] || [ "$2" == "orb" ]; then
                    if curl --silent $SUBS_CHECK > /dev/null; then
                        CMD="nix run home-manager -- -b backup $SUBS_CMD $CMD"
                    else
                        CMD="nix run home-manager -- -b backup $CMD"
                    fi
                # nixos
                # orb
                  elif [ "$2" == "bup" ] ; then
                    if curl --silent $SUBS_CHECK > /dev/null; then
                      CMD="sudo nixos-rebuild $SUBS_CMD $CMD --impure"
                    else
                      CMD="sudo nixos-rebuild $CMD --impure"
                    fi
                # droid
                  elif [ "$2" == "droid" ]; then
                    CMD="nix-on-droid $CMD"
                # mac
                  elif [ "$2" == "mac" ]; then
                    if curl --silent $SUBS_CHECK > /dev/null; then
                      CMD="sudo nix run nix-darwin -- $SUBS_CMD $CMD"
                    else
                      CMD="sudo nix run nix-darwin -- $CMD"
                    fi
                  else
                    echo "'$2' wrong, possible options: lgo, rpi, bup, orb, droid, mac"
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
