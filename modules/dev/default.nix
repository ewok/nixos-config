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
    ./go.nix
    ./java.nix
    ./k8s.nix
    ./neovim
    ./python.nix
    ./svn.nix
    ./terraform.nix
    ./typora.nix
    ./virtualisation.nix
    ./zeal.nix
  ];
  options.modules.dev = {
    enable = mkEnableOption "Enable dev environment.";
  };
}
