{ lib, stdenv, fetchFromGitHub }:

with lib;
stdenv.mkDerivation rec {
  pname = "sof-firmware";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "thesofproject";
    repo = "sof-bin";
    rev = "v${version}";
    sha256 = "172mlnhc7qvr65v2k1541inasm5hwsibmqqmpapml5n2a4srx7nr";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/lib/firmware

    find $out

    patchShebangs go.sh
    ROOT=$out SOF_VERSION=v${version} ./go.sh
  '';

  meta = with lib; {
    description = "Sound Open Firmware";
    homepage = "https://www.sofproject.org/";
    license = with licenses; [ bsd3 isc ];
    maintainers = with maintainers; [ lblasc evenbrenden ];
    platforms = with platforms; linux;
  };
}
