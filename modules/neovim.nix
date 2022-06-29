{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.opt.nvim;
  colors = cfg.colors;
in
{
  options.opt.nvim = {
    enable = mkOption { type = types.bool; };
    username = mkOption {type = types.str;};
  };

  config = mkIf cfg.enable {
    home-manager.users.${cfg.username} = {
        imports = [
            home/neovim.nix
        ];
    };
  };
}
