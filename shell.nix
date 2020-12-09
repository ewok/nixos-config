{ pkgs ? import <nixpkgs> { }, ... }:

pkgs.mkShell {
  buildInputs = [
    pkgs.git-crypt
    pkgs.nixUnstable
    pkgs.gnumake
  ];
}
