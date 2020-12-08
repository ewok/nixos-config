{ lib, ... }:
with lib;
{
  imports = [

    # Development
    ./fzf.nix
    ./neovim
    ./python.nix
      # [X] python2
      # [X] python3
      # [X] virtualenv
      # [X] pynvim for neovim in directrory
        # [X] - neovim
        # [X] - pynvim
        # [X] - msgpack
      # npm
      # git with funny things
      ./docker.nix
    # typora
    # meld
    # ./zeal
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
