{ lib, stdenv, fetchFromGitHub }:

with lib;
stdenv.mkDerivation rec {
  pname = "todo-txt-again";
  version = "91f44ff";

  src = fetchFromGitHub {
    owner = "nthorne";
    repo = "todo.txt-cli-again-addon";
    rev = "91f44ff9cc26a8dbfb083eefe034880156fec838";
    sha256 = "0b82ms66v5xnz8yjg8mjk5fihknyzxlfik5vb1bxff7c62135a8c";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/todo.actions.d
    mv again againFilter.sh againHelpers.sh $out/todo.actions.d
    chmod +x $out/todo.actions.d/*
  '';

  meta = with lib; {
    description = "A todo.txt command line add-on for marking a task as done, and then adding it again";
    homepage = "https://github.com/nthorne/todo.txt-cli-again-addon";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ewok ];
    platforms = platforms.linux;
  };
}
