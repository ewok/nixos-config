{ lib, stdenv, fetchFromGitHub }:

with lib;
stdenv.mkDerivation rec {
  pname = "sof-firmware";
  version = "1.7-rc2";

  src = fetchFromGitHub {
    owner = "thesofproject";
    repo = "sof-bin";
    # rev = "v${version}";
    # rev = "0c9b35cabd85897877f1c18ec1ea3ccc4b590d5f";
    rev = "90ca706ea65e7979135d927c6ed3303e40067189";
    # sha256 = "172mlnhc7qvr65v2k1541inasm5hwsibmqqmpapml5n2a4srx7nr";
    # sha256 = "0lqs07k8pdjkdk2wafz8kbadgvr5z1vgss2hxii2i908pim63wd2";
    sha256 = "1iwjx1cv9r7lzaz12iqqzjy8zz3gjv6s3lvk1bjmbhsdzsdinml0";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    set -x
    # find .
    # ls -la lib/firmware/intel/sof-tplg-v1.7
    mkdir -p $out/lib/firmware

    find $out

    cat go.sh
    patchShebangs go.sh
    INTEL_PATH= ROOT=$out SOF_VERSION=v${version} ./go.sh
  '';

  meta = with lib; {
    description = "Sound Open Firmware";
    homepage = "https://www.sofproject.org/";
    license = with licenses; [ bsd3 isc ];
    maintainers = with maintainers; [ lblasc evenbrenden ];
    platforms = with platforms; linux;
  };
}
