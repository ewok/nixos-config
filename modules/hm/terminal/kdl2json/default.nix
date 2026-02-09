{ lib, buildGoModule }:

buildGoModule {
  pname = "kdl2json";
  version = "0.1.0";

  src = ./.;

  vendorHash = "sha256-OHEa7eJ+vhbGizZIMb7eHOehZSDRj9P5Y9zCQlxRwH8=";

  meta = with lib; {
    description = "Convert KDL (KDL Document Language) to JSON";
    homepage = "https://github.com/sblinch/kdl-go";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "kdl2json";
  };
}
