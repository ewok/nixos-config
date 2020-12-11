{ lib, ... }:
with lib;
{
  imports = [
    # Development
    ./ctags.nix
    ./docker.nix
    ./fzf.nix
    ./git.nix
    ./k8s.nix
    # meld
    ./neovim
    ./notes.nix
    # npm
    ./python.nix
    ./typora.nix
    ./zeal.nix
  ];
  options.modules.dev = {
    enable = mkEnableOption "Enable dev environment.";
  };
}
