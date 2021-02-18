{ lib, stdenv, fetchurl, fetchFromGitHub
, autoPatchelfHook
, makeDesktopItem
, fuse, packer
, maven, openjdk, makeWrapper, glib, wrapGAppsHook
}:

let
  pname = "cryptomator";
  version = "1.5.12";

  src = fetchFromGitHub {
    owner = "cryptomator";
    repo = "cryptomator";
    rev = "${version}";
    sha256 = "1v7s3y0dh00vbi4zdlg3msv3034sa5qzx5fq5xwi76vs2r37nk2j";
  };

  desktopItem = makeDesktopItem {
    name = "cryptomator";
    comment = "Cloud Storage Encryption Utility";
    desktopName = "Cryptomator";
    type = "Application";
    exec = "cryptomator";
    icon = "org.cryptomator.Cryptomator";
    mimeType="application/x-vnd.cryptomator-vault-metadata";
    categories = "Utility;Security;FileTools;";
    terminal = "false";
    extraEntries = ''
      StartupWMClass=org-cryptomator-launcher-Cryptomator
    '';
  };

  # perform fake build to make a fixed-output derivation out of the files downloaded from maven central (120MB)
  deps = stdenv.mkDerivation {
    name = "cryptomator-${version}-deps";
    inherit src;

    buildInputs = [ openjdk maven ];

    buildPhase = ''
      cd main
      while mvn -Prelease package -Dmaven.repo.local=$out/.m2 -Dmaven.wagon.rto=5000; [ $? = 1 ]; do
        echo "timeout, restart maven to continue downloading"
      done
    '';

    # keep only *.{pom,jar,sha1,nbm} and delete all ephemeral files with lastModified timestamps inside
    installPhase = ''
      find $out/.m2 -type f -regex '.+\(\.lastUpdated\|resolver-status\.properties\|_remote\.repositories\)' -delete
      find $out/.m2 -type f -iname '*.pom' -exec sed -i -e 's/\r\+$//' {} \;
    '';

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "15gwldn9dc4gxi8ja4lay5qdadvhxry17ggj3cqamk8g38rh97v0";
  };

in stdenv.mkDerivation rec {
  inherit pname;
  inherit version;
  inherit src;

  buildPhase = ''
    cd main
    mvn -Prelease package --offline -Dmaven.repo.local=$(cp -dpR ${deps}/.m2 ./ && chmod +w -R .m2 && pwd)/.m2
  '';

  installPhase = ''
    mkdir -p $out/usr/share/cryptomator/libs/
    mkdir -p $out/bin/

    cp buildkit/target/libs/* buildkit/target/linux-libs/* $out/usr/share/cryptomator/libs/

    cat > $out/usr/share/cryptomator/cryptomator <<EOF
    #!/usr/bin/env sh
    exec ${openjdk}/bin/java -verbose \
        -cp "$out/usr/share/cryptomator/libs/*" \
        -Dcryptomator.settingsPath="~/.config/Cryptomator/settings.json" \
        -Dcryptomator.ipcPortPath="~/.config/Cryptomator/ipcPort.bin" \
        -Dcryptomator.logDir="~/.local/share/Cryptomator/logs" \
        -Dcryptomator.mountPointsDir="~/.local/share/Cryptomator/mnt" \
        -Djdk.gtk.version=2 \
        -Xss20m \
        -Xmx512m \
        org.cryptomator.launcher.Cryptomator
EOF

    chmod +x $out/usr/share/cryptomator/cryptomator
    ln -s $out/usr/share/cryptomator/cryptomator $out/bin/cryptomator

    wrapProgram "$out/usr/share/cryptomator/cryptomator" \
     --prefix PATH : "$out/usr/share/cryptomator/libs/:${lib.makeBinPath [ openjdk glib ]}" \
     --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ fuse ]}" \
     --set JAVA_HOME "$openjdk"

    # install desktop entry
    install -Dm644 -t $out/share/applications ${desktopItem}/share/applications/*
    # install -Dm644 "{./org.cryptomator.Cryptomator.svg}" "$out/share/icons/hicolor/scalable/apps/org.cryptomator.Cryptomator.svg"
    # install -Dm644 "{./org.cryptomator.Cryptomator.png}" "$out/share/icons/hicolor/512x512/apps/org.cryptomator.Cryptomator.png"
  '';

  nativeBuildInputs = [ autoPatchelfHook maven makeWrapper wrapGAppsHook ];
  buildInputs = [ fuse packer openjdk glib ];

  meta = with lib; {
    description = "Free client-side encryption for your cloud files.";
    homepage = "https://cryptomator.org";
    license = licenses.gpl3;
    maintainers = with maintainers; [ bachp ];
    platforms = [ "x86_64-linux" ];
  };
}

