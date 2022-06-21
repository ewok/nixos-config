{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.opt.git;

  gitSignRebase = pkgs.writeShellScriptBin "git-sign-rebase" ''
    if [ "$#" -eq 0 ]; then
      echo "Insert commit to rebase"
      exit 2
    fi
    git rebase --exec 'git commit --amend --no-edit -n -S' -i $1
  '';

  gitIgnoreNix = pkgs.writeShellScriptBin "git-ignore-nix" ''
    ${pkgs.git}/bin/git config --local --add core.excludesfile ${config.xdg.configHome}/git/exclude_nix
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
  options.opt.git = {
    enable = mkOption { type = types.bool; };
    gui = mkOption { type = types.bool; };
    username = mkOption {type = types.str;};
    home = {
      email = mkOption {type = types.str;};
      fullName = mkOption {type = types.str;};
    };
    work = {
      enable = mkOption { type = types.bool; };
      email = mkOption {type = types.str;};
      fullName = mkOption {type = types.str;};
      projectDir = mkOption {type = types.str;};
    };
  };

  config = mkIf cfg.enable {
      home.packages = with pkgs; [
        ripgrep
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
      ] ++ optionals (cfg.gui) [
        meld
        git-cola
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
        email = ${cfg.work.email}
        name = ${cfg.work.fullName}
      '';

      xdg.configFile."git/home.cfg".text = ''
        [user]
        email = ${cfg.home.email}
        name = ${cfg.home.fullName}
      '';

      programs.git = {
        enable = true;
        # userName = user.fullName;
        # userEmail = user.email;
        extraConfig = mkMerge [
          {
            "includeIf \"gitdir:/\"" = {
              path = "${config.xdg.configHome}/git/home.cfg";
            };
            "rebase" = {
              autoSquash = true;
              autoStash = true;
            };
            "core" = {
              autocrlf = false;
              excludesfile = "${config.xdg.configHome}/git/gitexcludes";
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
            mkIf cfg.work.enable {
              "includeIf \"gitdir:${cfg.work.projectDir}/\"" = {
                path = "${config.xdg.configHome}/git/work.cfg";
              };
            }
          )
        ];
      };
  };
}
