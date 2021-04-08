{ lib, ... }:
with lib;
{
  imports = [
    ./ctags.nix
    ./db.nix
    ./direnv.nix
    ./docker.nix
    ./fzf.nix
    ./git.nix
    ./java.nix
    ./k8s.nix
    ./neovim
    ./python.nix
    ./svn.nix
    ./typora.nix
    ./zeal.nix
  ];
  options.modules.dev = {
    enable = mkEnableOption "Enable dev environment.";
  };
}
