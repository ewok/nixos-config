{ lib, stdenv, fetchFromGitHub }:

with lib;
stdenv.mkDerivation rec {
  pname = "todofish";
  version = "12c8283";

  src = fetchFromGitHub {
    owner = "ewok";
    repo = "todofi.sh";
    rev = "b5b048d28b0cc432f33ca27e649766b6a38c2896";
    sha256 = "0xw58w56zya5i2sa1y1v1n49rcjvkq171372zciicic8q7bhxmy4";
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
