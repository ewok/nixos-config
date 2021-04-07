{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.dev.docker;
  dev = config.modules.dev;
  username = config.properties.user.name;
  configHome = config.home-manager.users."${username}".xdg.configHome;

  docker-arch = pkgs.writeShellScriptBin "docker-arch " ''
    docker run -ti --rm --entrypoint bash -u root archlinux -c "$*"
  '';

  docker-centos = pkgs.writeShellScriptBin "docker-centos " ''
    docker run -ti --rm --entrypoint bash centos:7 -c "$*"
  '';

  docker-cerebro = pkgs.writeShellScriptBin "docker-cerebro " ''
    docker run -ti --rm -p 9000:9000 lmenezes/cerebro
  '';

  docker-mvn = pkgs.writeShellScriptBin "docker-mvn " ''
    docker run -v $HOME/.m2:/var/maven/.m2 \
    -v "$PWD":/var/maven/src -w /var/maven/src  \
    -ti --rm -u $(id -u) \
    -e MAVEN_CONFIG=/var/maven/.m2 \
    maven:$1 \
    mvn -Duser.home=/var/maven ''${*:2}
  '';

  docker-krb = pkgs.writeShellScriptBin "docker-krb " ''
    docker run -ti --rm -e KRB5_CONFIG=/etc/krb5.conf \
    -v ''$(pwd)/krb5.conf:/etc/krb5.conf \
    --entrypoint bash -w ''${PWD} \
    pilchard/krb5 -c "$*"
  '';

  docker-mysql-server = pkgs.writeScriptBin "docker-mysql-server" ''
    #!${pkgs.bash}/bin/bash
    set -e
    PORT=$(shuf -i 31000-31999 | head -n 1 )
    docker run -d --rm --name=mysql -e MYSQL_ROOT_PASSWORD=root -p 3306:3306 mysql/mysql-server:5.7
    cleanup(){
    echo "***Stopping"
    docker stop mysql
    }
    trap 'cleanup' 1 2 3 6 15
    sleep 10
    docker exec -t mysql mysql -uroot -proot -e "CREATE USER 'root'@'%' IDENTIFIED BY 'root';GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;FLUSH PRIVILEGES;"
    docker logs -f mysql
  '';

  docker-mysql-cli = pkgs.writeShellScriptBin "docker-mysql " ''
    docker exec -it mysql mysql -uroot -proot $@
  '';

  docker-mysqldump = pkgs.writeShellScriptBin "docker-mysqldump " ''
    docker exec -it mysql mysqldump -uroot -proot $@
  '';

in
{
  options.modules.dev = {
    docker = {
      enable = mkEnableOption "Enable docker.";
      autoPrune = mkEnableOption "Enable weekly cleanup.";
    };
  };

  config = mkIf (cfg.enable && dev.enable) {

    virtualisation.docker = {
      enable = true;
      autoPrune = {
        enable = cfg.autoPrune;
      };
    };

    users.users.${username}.extraGroups = [ "docker" ];

    home-manager.users."${username}" = {
      home.sessionVariables.DOCKER_CONFIG = "${configHome}/docker";

      home.packages = [
        docker-arch
        docker-centos
        docker-cerebro
        docker-mvn
        docker-krb
        docker-mysql-server
        docker-mysql-cli
        docker-mysqldump

        pkgs.docker-compose
      ];
    };
  };
}
