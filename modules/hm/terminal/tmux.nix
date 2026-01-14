{ config, lib, pkgs, utils, ... }:
let
  inherit (lib) mkIf optionals;
  inherit (pkgs) writeScriptBin buildGoModule fetchFromGitHub;

  cfg = config.opt.terminal;

  tm = writeScriptBin "tm" ''
    #!${pkgs.bash}/bin/bash
    if [[ $1 == "" ]];then
      SESSION="main"
    else
      SESSION="$1"
    fi
    tmux attach -t $SESSION || tmux new -s $SESSION
  '';

  tssh = writeScriptBin "tssh" ''
    #!${pkgs.bash}/bin/bash
    argv=( "$@" )
    C=1
    tmux new-window "ssh ''${argv[0]}"
    for i in "''${argv[@]:1}";do
    tmux split-window -h "ssh $i"
    C=$((C + 1))
    done
    if [ "$#" -gt 4 ];then
    tmux select-layout tiled
    else
    tmux select-layout even-vertical
    fi
  '';

  zoxide-rm = writeScriptBin "zoxide-rm" ''
    #!${pkgs.bash}/bin/bash
    EXP=$(echo "$1" | sed "s|~|$HOME|g")
    ${pkgs.zoxide}/bin/zoxide remove "$EXP"
  '';

  vars = {
    conf.colors = cfg.colors;
    conf.theme = cfg.theme;
    conf.terminal = cfg.tmux.terminal;
    conf.orb = cfg.orb;
  };

  # packs =
  #   let
  #     pname = "sesh";
  #     version = "2";
  #     hash = "sha256-EKIekXABLnCAPMJNRPTdPXeWI5KK0HStyPT/OK7U8R8=";
  #   in
  #   {
  #     sesh-v2 = buildGoModule
  #       {
  #         inherit pname version hash;
  #
  #         src = fetchFromGitHub {
  #           owner = "joshmedeski";
  #           repo = "sesh";
  #           rev = "v${version}";
  #           hash = hash;
  #         };
  #
  #         vendorHash = "sha256-a45P6yt93l0CnL5mrOotQmE/1r0unjoToXqSJ+spimg=";
  #
  #         ldflags = [ "-s" "-w" ];
  #
  #         overrideModAttrs = (_: {
  #           TZ = "CDT";
  #         });
  #       };
  #   };

in
{
  config = mkIf (cfg.enable && cfg.tmux.enable) {
    home.packages =
      let
        optionalPkgs = optionals cfg.tmux.install [ pkgs.tmux ];
        external = with pkgs; [
          sesh
          zoxide
          fzf
          gnugrep
          procps
          bc
        ];
      in
      [
        zoxide-rm
        tm
        tssh
      ] ++ external ++ optionalPkgs;
    xdg.configFile."tmux/tmux.conf".source = utils.templateFile "tmux.conf" ./config/tmux.conf vars;
    xdg.configFile."tmux/tmux_blocks" = {
      source = utils.templateFile "tmux_blocks" ./config/tmux_blocks vars;
      executable = true;
    };
    xdg.configFile."tmux/tmux_battery" = {
      source = utils.templateFile "tmux_battery" ./config/tmux_battery vars;
      executable = true;
    };
    xdg.configFile."tmux/tmux_cpu" = {
      source = utils.templateFile "tmux_cpu" ./config/tmux_cpu vars;
      executable = true;
    };
    xdg.configFile."tmux/tmux_network" = {
      source = utils.templateFile "tmux_network" ./config/tmux_network vars;
      executable = true;
    };
    xdg.configFile."tmux/tmux_ram" = {
      source = utils.templateFile "tmux_ram" ./config/tmux_ram vars;
      executable = true;
    };
    xdg.configFile."tmux/tmux_toggle" = {
      source = utils.templateFile "tmux_toggle" ./config/tmux_toggle vars;
      executable = true;
    };
    xdg.configFile."tmux/sesh" = {
      source = utils.templateFile "sesh" ./config/sesh.sh vars;
      executable = true;
    };
    xdg.configFile."sesh/sesh.toml" = {
      text = ''
        dir_length = 2
      '';
    };
  };
}
