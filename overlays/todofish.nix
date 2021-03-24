{ lib, stdenv, fetchFromGitHub }:

with lib;
stdenv.mkDerivation rec {
  pname = "todofish";
  version = "12c8283";

  src = fetchFromGitHub {
    owner = "ewok";
    repo = "todofi.sh";
    rev = "aaecb8bd575b2d2bc0b50daa3171cef2aec2e6a8";
    sha256 = "0mhizx7x1x2pjc6kjawlhiiw1y0qflbadsnrr9kzahn2h5dnfzf8";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    mv todofi.sh $out/bin
    chmod +x $out/bin/todofi.sh
  '';

  meta = with lib; {
    description = "Todo-txt + Rofi = Todofi.sh";
    homepage = "https://github.com/hugokernel/todofi.sh/";
    license = licenses.mit;
    maintainers = with maintainers; [ ewok ];
    platforms = platforms.linux;
  };
}
