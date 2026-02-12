{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (pkgs) fetchurl stdenv;

  cfg = config.opt.parm;

  parmVersion = "0.1.6";

  parm = stdenv.mkDerivation {
    pname = "parm";
    version = parmVersion;

    src = {
      x86_64-linux = fetchurl {
        url = "https://github.com/alxrw/parm/releases/download/v${parmVersion}/parm-linux-amd64.tar.gz";
        sha256 = "sha256-jqtFv9rAwHyo1K/TND8Ktj8L6YgKU6HXQfMFyRgAU34=";
      };

      aarch64-linux = fetchurl {
        url = "https://github.com/alxrw/parm/releases/download/v${parmVersion}/parm-linux-arm64.tar.gz";
        sha256 = "sha256-CrCvYVZKer/UbWG1/kYfAlmNlYDHitrEoZEfvPL3xik=";
      };

      aarch64-darwin = fetchurl {
        url = "https://github.com/alxrw/parm/releases/download/v${parmVersion}/parm-darwin-arm64.tar.gz";
        sha256 = "sha256-XBuHyFwOoF2OMmN+YzthN6C1sPlQtMyHdJlwcxsW38I=";
      };
    }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

    dontConfigure = true;
    dontBuild = true;

    unpackPhase = ''
      tar xzf $src
    '';

    installPhase = ''
      install -D parm "$out/bin/parm"
    '';

    meta = with lib; {
      description = "Cross-platform package manager for GitHub Releases";
      homepage = "https://github.com/alxrw/parm";
      license = licenses.gpl3Only;
      platforms = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
    };
  };
in
{
  options.opt.parm = {
    enable = mkEnableOption "parm - package manager for GitHub Releases";
    github_token = lib.mkOption {
      type = lib.types.str;
      default = "";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ parm ];

    xdg.configFile."bash/rc.d/99_parm.sh".text = ''
      export GITHUB_TOKEN="${cfg.github_token}"
      export PATH="$PATH:$HOME/.local/share/parm/bin"
    '';
  };
}

