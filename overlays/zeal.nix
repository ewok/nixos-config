{ lib, fetchFromGitHub, cmake, extra-cmake-modules, pkg-config
, qtbase, qtimageformats, qtwebengine, qtx11extras, mkDerivation
, libarchive, libXdmcp, libpthreadstubs, xcbutilkeysyms  }:

mkDerivation rec {
  pname = "zeal";
  version = "0.6.999";

  src = fetchFromGitHub {
    owner = "zealdocs";
    repo = "zeal";
    rev = "d3c5521c501d24050f578348ff1b9d68244b992c";
    sha256 = "1ky2qi2cmjckc51lm3i28815ixgqdm36j7smixxr16jxpmbqs6sl";
  };

  # we only need this if we are using a version that hasn't been released. We
  # could also match on the "VERSION x.y.z" bit but then it would have to be
  # updated based on whatever is the latest release, so instead just rewrite the
  # line.
  postPatch = ''
    sed -i CMakeLists.txt \
      -e 's@^project.*@project(Zeal VERSION ${version})@'
  '';

  nativeBuildInputs = [ cmake extra-cmake-modules pkg-config ];

  buildInputs = [
    qtbase qtimageformats qtwebengine qtx11extras
    libarchive
    libXdmcp libpthreadstubs xcbutilkeysyms
  ];

  meta = with lib; {
    description = "A simple offline API documentation browser";
    longDescription = ''
      Zeal is a simple offline API documentation browser inspired by Dash (macOS
      app), available for Linux and Windows.
    '';
    homepage = "https://zealdocs.org/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ skeidel peterhoeg ];
    platforms = platforms.linux;
  };
}
