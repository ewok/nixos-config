{ lib, stdenv, fetchFromGitHub }:

with lib;
stdenv.mkDerivation rec {
  pname = "todofish";
  version = "ec5c77a";

  src = fetchFromGitHub {
    owner = "ewok";
    repo = "todofi.sh";
    rev = "ec5c77ab292f59da01dee489749da494c7ba7404";
    sha256 = "07kv4q0mzxr4hk0aar3jkmdlp8qnhch9lxhibq6djbcvpbsizv75";
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
