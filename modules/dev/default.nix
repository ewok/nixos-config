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
    # ./typora.nix
    ./zeal.nix
    # meld
    # libgnome-keyring
    ./k8s.nix
    # kubectl
    # kubectx
    ./ctags.nix
  ];
  options.modules.dev = {
    enable = mkEnableOption "Enable dev environment.";
  };
}
