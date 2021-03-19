{ lib, stdenv, fetchFromGitHub }:

with lib;
stdenv.mkDerivation rec {
  pname = "todofish";
  version = "12c8283";

  src = fetchFromGitHub {
    owner = "ewok";
    repo = "todofi.sh";
    rev = "master";
    sha256 = "1wjray3k8h73rh7fdr83s19fybwv3k3w1xrw6dwcrn834pwy5n1k";
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
