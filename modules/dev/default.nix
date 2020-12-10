{ lib, ... }:
with lib;
{
  imports = [

    # Development
    ./fzf.nix
    ./neovim
    ./python.nix
    # npm
    ./git.nix
    ./docker.nix
    ./typora.nix
    ./zeal.nix
    # meld
    ./k8s.nix
    ./ctags.nix
  ];
  options.modules.dev = {
    enable = mkEnableOption "Enable dev environment.";
  };
}
