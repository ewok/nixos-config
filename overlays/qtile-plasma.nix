{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "qtile-plasma";
  version = "1.5.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0inv0in3mk777fir870fr7nvzx2ycn8lwjd5asqrsrk99ydjwxwb";
    # 0.17
    # sha256 = "197gdifvnk5dfqcpq43lc1pvaf2wsad8zn85anaaaw65jdhmmzjw";
  };

  # buildInputs = [ qtile ];

  pipInstallFlags = [
    "--no-deps"
  ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/numirias/qtile-plasma";
    license = licenses.mit;
    description = "Plasma is a flexible, tree-based layout for Qtile";
  };

}
