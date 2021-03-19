{ lib, stdenv, fetchFromGitHub }:

with lib;
stdenv.mkDerivation rec {
  pname = "rofi-bluetooth";
  version = "ffaf191";

  src = fetchFromGitHub {
    owner = "ewok";
    repo = "rofi-bluetooth";
    rev = "ffaf19113e39a9010b8b6fccb11023fe7a3a767d";
    sha256 = "1arhg64r5j2jawphgk70nrrcif5x9cmb2x1ykz00d3250gnajy3w";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    mv rofi-bluetooth $out/bin
    chmod +x $out/bin/rofi-bluetooth
  '';

  meta = with lib; {
    description = "A rofi menu to connect to bluetooth devices and display status info.";
    homepage = "https://github.com/ClydeDroid/rofi-bluetooth/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ewok ];
    platforms = platforms.linux;
  };
}
