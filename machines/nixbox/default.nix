{ config, inputs, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  imports = [
    ../../modules
    ./configuration.nix
    "${inputs.nixos-hardware}/common/pc/ssd"
  ];

  home-manager = {
    useGlobalPkgs = true;
  };

  properties.user = {
    name = "vagrant";
    email = "vagrant@localhost";
  };

  properties.device = {
    name = "nixbox";
  };

  modules.bin.enable = true;
  modules.fish.enable = true;
  modules.fzf.enable = true;
  modules.starship.enable = true;
  modules.tmux.enable = true;
  modules.neovim.enable = true;
  modules.vifm.enable = true;
  modules.rslsync.enable = true;
  modules.restic = {
    enable = true;
    repo = "test_restic_repo";
    excludePaths = [ ".cache" "tmp" "mnt" ];
    pass = "123";
  };
  modules.rclone.enable = true;
}
