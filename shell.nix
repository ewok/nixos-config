{ pkgs ? import <nixpkgs> { }, ... }:

pkgs.mkShell {
  buildInputs = [
    pkgs.git
    pkgs.git-crypt
    pkgs.nixUnstable
    pkgs.gnumake
  ];
}
