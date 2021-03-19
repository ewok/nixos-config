{ lib, stdenv, fetchFromGitHub }:

with lib;
stdenv.mkDerivation rec {
  pname = "todofish";
  version = "12c8283";

  src = fetchFromGitHub {
    owner = "ewok";
    repo = "todofi.sh";
    rev = "8a739ce12f2612a24090d435f19e196d7c4e4ab5";
    sha256 = "1l7bbmx669kgdgdnjf72lnk4l75vbsn42a5xi780jvn9x5bm675z";
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
