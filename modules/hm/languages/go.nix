{ config, lib, pkgs, ... }:
let
  cfg = config.opt.languages.go;
in
{
  options.opt.languages.go = {
    enable = lib.mkEnableOption "go";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      go
      delve
      golangci-lint
      gosec
      go-tools
      gotools
      errcheck
      gofumpt
    ];
    xdg.configFile."bash/rc.d/02_go.sh".text = ''
      export GOPATH="$HOME/.go"
      export GOBIN="$GOPATH/bin"
      export GOVCS="*:git|hg"
      export GOFLAGS="-buildvcs=false"
      mkdir -p "$GOBIN"
      case ":$PATH:" in
        *":$GOBIN:"*) :;;
        *) PATH="$GOBIN:$PATH";;
      esac
      export PATH
    '';
    home.file.".golangci.yaml".source = pkgs.writeText "golangci.yaml" ''
      version: "2"
      linters:
        enable:
          - errcheck
          - staticcheck
          - gosec
          - unused
    '';
  };
}
