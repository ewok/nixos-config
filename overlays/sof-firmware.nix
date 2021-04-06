{ lib, stdenv, fetchFromGitHub }:

with lib;
stdenv.mkDerivation rec {
  pname = "sof-firmware";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "thesofproject";
    repo = "sof-bin";
    rev = "v${version}";
    sha256 = "1fb4rxgg3haxqg2gcm89g7af6v0a0h83c1ar2fyfa8h8pcf7hik7";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/lib/firmware

    find $out

    mkdir -p tools lib/firmware/intel/sof

    mv sof-tplg-v1.7 lib/firmware/intel/
    mv sof-v1.7 lib/firmware/intel/sof/v1.7
    mv tools-v1.7 tools/v1.7

    patchShebangs go.sh
    sed -i 's/\-''${SOF_VERSION}.ri/.ri/g' go.sh
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
