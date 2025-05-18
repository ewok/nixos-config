{ config, lib, pkgs, utils, ... }:
let
  inherit (lib) mkEnableOption mkIf mkOption types;
  inherit (pkgs) writeShellScriptBin symlinkJoin;

  cfg = config.opt.git;
  vars =
    {
      conf.accounts.home.path = cfg.homePath;
      conf.accounts.home.email = cfg.homeEmail;
      conf.accounts.work.path = cfg.workPath;
      conf.accounts.work.email = cfg.workEmail;
      conf.full_name = cfg.fullName;
    };

  git-sign-rebase = writeShellScriptBin "git-sign-rebase" ''
    if [ "$#" -eq 0 ]; then
      echo "Insert commit to rebase"
      exit 2
    fi
    git rebase --exec 'git commit --amend --no-edit -n -S' -i $1
  '';

  git-env = symlinkJoin {
    name = "git-env";
    paths = with pkgs; [ gomp gitstats ];
    postBuild = ''
      ln -s $out/bin/gomp $out/bin/git-diff-branch
      ln -s $out/bin/gitstats $out/bin/git-stats
    '';
  };
  gg = symlinkJoin {
    name = "gg";
    paths = [ pkgs.lazygit ];
    postBuild = ''
      ln -s $out/bin/lazygit $out/bin/gg
    '';
  };
in
{
  options.opt.git = {
    enable = mkEnableOption "git";
    homePath = mkOption { type = types.str; };
    homeEmail = mkOption { type = types.str; };
    workPath = mkOption { type = types.str; };
    workEmail = mkOption { type = types.str; };
    fullName = mkOption { type = types.str; };
  };

  config = mkIf cfg.enable {
    home =
      let
        external = with pkgs; [
          git
          gitAndTools.git-crypt
          gitAndTools.git-extras
          gitAndTools.git-filter-repo
          gitAndTools.git-trim
          # gitAndTools.git-machete
          # gitAndTools.git-octopus
          gitAndTools.git-reparent
          gitAndTools.git-lfs
        ];
      in
      {
        packages =
          external ++ [
            git-sign-rebase
            git-env
            gg
          ];
      };
    xdg = {
      configFile = {
        "fish/conf.d/90_git-aliases.fish".source = ./config/90_git-aliases.fish;
        "nushell/autoload/git-aliases.nu".source = ./config/git-aliases.nu;
        "git/config".source = utils.templateFile "config" ./config/git/config vars;
        "git/home.cfg".source = utils.templateFile "config" ./config/git/home.cfg vars;
        "git/work.cfg".source = utils.templateFile "config" ./config/git/work.cfg vars;
        "git/gitexcludes".source = ./config/git/gitexcludes;
      };
    };
  };
}
