{ config, lib, pkgs, ... }:
with lib;
let
  dev = config.modules.dev;
  gui = config.modules.gui;
  user = config.properties.user;
  work = config.properties.work_account;
  hm = config.home-manager.users.${user.name};
  homeDirectory = hm.home.homeDirectory;

  gitSignRebase = pkgs.writeShellScriptBin "git-sign-rebase" ''
    if [ "$#" -eq 0 ]; then
      echo "Insert commit to rebase"
      exit 2
    fi
    git rebase --exec 'git commit --amend --no-edit -n -S' -i $1
  '';

  gitIgnoreNix = pkgs.writeShellScriptBin "git-ignore-nix" ''
    ${pkgs.git}/bin/git config --local --add core.excludesfile ${hm.xdg.configHome}/git/exclude_nix
  '';

  gitEnv = pkgs.symlinkJoin {
    name = "git-env";
    paths = with pkgs; [ gomp gitstats gitSignRebase gitIgnoreNix ];
    postBuild = ''
      ln -s $out/bin/gomp $out/bin/git-diff-branch
      ln -s $out/bin/gitstats $out/bin/git-stats
    '';
  };

  ignoreCommon = ''
    .direnv/
    .mypy_cache/
    .out/
    .tmp/
  '';

in
{
  config = mkIf dev.enable {

    environment.systemPackages = with pkgs;
      [
        # gitAndTools.git-absorb
        gitAndTools.git-crypt
        gitAndTools.git-extras
        # gitAndTools.git-filter-repo
        gitAndTools.git-machete
        gitAndTools.git-octopus
        gitAndTools.git-reparent
        gitAndTools.git-trim
        gitAndTools.pass-git-helper
        gitAndTools.gh
        gitEnv
      ] ++ optionals (gui.enable) [
        meld
        git-cola
      ];
    home-manager.users."${user.name}" = {

      home.packages = with pkgs; [
        ripgrep
      ];

      xdg.configFile."git/gitexcludes".text = ''
      ${ignoreCommon}
      '';

      xdg.configFile."git/exclude_nix".text = ''
        .envrc
        shell.nix
        default.nix
        ${ignoreCommon}
      '';

      # FIX: If not enable don't include
      xdg.configFile."git/work.cfg".text = ''
        [user]
        email = ${work.email}
        name = ${work.fullName}
      '';

      xdg.configFile."git/home.cfg".text = ''
        [user]
        email = ${user.email}
        name = ${user.fullName}
      '';

      programs.git = {
        enable = true;
        # userName = user.fullName;
        # userEmail = user.email;
        extraConfig = mkMerge [
          {
            "includeIf \"gitdir:/\"" = {
              path = "${hm.xdg.configHome}/git/home.cfg";
            };
            "rebase" = {
              autoSquash = true;
              autoStash = true;
            };
            "core" = {
              autocrlf = false;
              excludesfile = "${hm.xdg.configHome}/git/gitexcludes";
              quotepath = false;
              askPass = "";
            };
            "credential" = { helper = "${pkgs.gitAndTools.pass-git-helper}/bin/pass-git-helper"; };
            "diff" = {
              algorithm = "patience";
              gpg = { textconv = "${pkgs.gnupg}/bin/gpg2 --no-tty --decrypt"; };
            };
            "push" = { default = "simple"; };
            "absorb" = { maxstack = 75; };
          }
          (
            mkIf work.enable {
              "includeIf \"gitdir:${work.workProjectDir}/\"" = {
                path = "${hm.xdg.configHome}/git/work.cfg";
              };
            }
          )
        ];
      };
    };
  };
}
