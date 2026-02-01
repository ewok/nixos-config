{ config, lib, pkgs, ... }:
let
  cfg = config.opt.languages.rust;
in
{
  options.opt.languages.rust = {
    enable = lib.mkEnableOption "rust";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      rustup
      # rust-analyzer
      cargo-edit
      cargo-expand
      cargo-outdated
      cargo-watch
    ];

    xdg.configFile."bash/rc.d/02_rust.sh".text = ''
      export CARGO_HOME="$HOME/.local/share/cargo"
      export RUSTUP_HOME="$HOME/.local/share/rustup"

      mkdir -p "$CARGO_HOME/bin"
      case ":$PATH:" in
        *:"$CARGO_HOME/bin":*) :;;
        *) PATH="$CARGO_HOME/bin:$PATH";;
      esac
      export PATH
    '';
  };
}
