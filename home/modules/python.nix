{ config, lib, pkgs, ... }:
with lib;
let
  dev = config.home.dev;
  my-python-packages = python-packages: with python-packages; [
    virtualenv

    pynvim
    msgpack

    bandit
    black
    flake8
    jedi
    mypy
    #pudb
    pydocstyle
    pylint

    debugpy

    ipython

    # For qutebrowser
    # pynacl
  ];
  python-with-my-packages = pkgs.python3.withPackages my-python-packages;
in
{
  config = mkIf dev.enable {
    home.packages = with pkgs; [
      python-with-my-packages
    ];
  };
}
