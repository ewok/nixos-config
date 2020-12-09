{ config, lib, pkgs, ... }:
with lib;
let
  dev = config.modules.dev;
  user = config.properties.user;
in
{
  config = mkIf dev.enable {

    environment.systemPackages = with pkgs;
    [
      gitAndTools.git-absorb
      gitAndTools.git-crypt
      gitAndTools.git-extras
      gitAndTools.git-machete
      gitAndTools.git-octopus
      gitAndTools.pass-git-helper
      gitstats
      gomp

      gitAndTools.git-trim
      gitAndTools.git-reparent
      gitAndTools.git-filter-repo
    ];
    home-manager.users."${user.name}" = {

      home.packages = with pkgs; [
        ripgrep
      ];

      programs.git = {
        enable = true;
        userName = user.fullName;
        userEmail = user.email;
        extraConfig = {
          "rebase" = {
          autoSquash = true;
          autoStash = true;
          };
          "core" = {
          autocrlf = false;
          excludesfile = "~/.gitexcludes";
          quotepath = false;
          askPass = "";
          };
          "credential" = { helper = "${pkgs.gitAndTools.pass-git-helper}/bin/pass-git-helper"; };
          "diff" = {
          algorithm = "patience";
          gpg = { textconv = "${pkgs.gnupg}/bin/gpg2 --no-tty --decrypt"; };
          };
          "push" = { default = "current"; };
          "absorb" = { maxstack = 75; };
        };
      };
    };
  };
}

