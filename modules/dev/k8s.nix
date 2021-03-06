{ config, lib, pkgs, ... }:
with lib;
let
  dev = config.modules.dev;
  cfg = config.modules.dev.k8s;
  username = config.properties.user.name;

  k8s-mysqldump = pkgs.writeScriptBin "k8s-mysqldump" ''
    #!${pkgs.bash}/bin/bash
    set -e
    if [ $# -eq 1 ];then
    echo "Usage: $(basename $0) [mysql options]"
    exit 1
    fi
    NAME="debug-mysqldump"
    if ! which kubectl &>/dev/null;then
    echo "kubectl not found, please run the command below:"
    echo
    CMD="echo"
    fi
    $CMD kubectl run $NAME --image=mysql:5.6.47 -it --rm --restart='Never' -- mysqldump $@
    sleep 1
    $CMD kubectl get po | grep $NAME && echo "ERROR: Pod was not deleted!"
  '';

  k8s-mysql = pkgs.writeScriptBin "k8s-mysql" ''
    #!${pkgs.bash}/bin/bash
    set -e
    if [ $# -eq 1 ];then
    echo "Usage: $(basename $0) [mysql options]"
    exit 1
    fi
    NAME="debug-mysql-client"
    if ! which kubectl &>/dev/null;then
    echo "kubectl not found, please run the command below:"
    echo
    CMD="echo"
    fi
    $CMD kubectl run $NAME --image=mysql:5.6.47 -it --rm --restart='Never' -- mysql $@
    sleep 1
    $CMD kubectl get po | grep $NAME && echo "ERROR: Pod was not deleted!"
  '';

  k8s-argo = pkgs.writeScriptBin "k8s-argo" ''
    #!${pkgs.bash}/bin/bash
    set -ex
    PORT=$(shuf -i 31000-31999 | head -n 1 )
    kubectl port-forward -n argocd service/argocd-server $PORT:443 &
    PID=$!
    cleanup(){
    echo "***Stopping"
    kill -15 $PID
    wait $PID
    }
    trap 'cleanup' 1 2 3 6 15
    sleep 3
    open "localhost:$PORT" &
    wait $PID
  '';

  k8s-busybox = pkgs.writeScriptBin "k8s-busybox" ''
    #!${pkgs.bash}/bin/bash
    set -e
    if [ $# -gt 2 ];then
    echo "Usage: $(basename $0) [pod name] [cmd]"
    exit 1
    fi
    NAME="debug-busybox"
    test "$1" != "" && NAME="$1"
    RUN="sh"
    test "$2" != "" && RUN="$2"
    if ! which kubectl &>/dev/null;then
    echo "kubectl not found, please run the command below:"
    echo
    CMD="echo"
    fi
    $CMD kubectl run $NAME --image=busybox -it --rm --restart='Never' -- $RUN
    sleep 1
    $CMD kubectl get po | grep $NAME && echo "ERROR: Pod was not deleted!"
  '';

  k8s-kafka-client = pkgs.writeScriptBin "k8s-kafka-client" ''
    #!${pkgs.bash}/bin/bash
    set -e
    if [ $# -gt 1 ];then
    echo "Usage: $(basename $0) [pod name]"
    exit 1
    fi
    NAME="debug-kafka-client"
    test "$1" != "" && NAME="$1"
    if ! which kubectl &>/dev/null;then
    echo "kubectl not found, please run the command below:"
    echo
    CMD="echo"
    fi
    $CMD kubectl run "$NAME" --restart='Never' --image docker.io/bitnami/kafka:2.5.0-debian-10-r112 -it --rm -- bash
    sleep 1
    $CMD kubectl get po | grep "$NAME" && echo "ERROR: Pod was not deleted!"
  '';

  k8s-jmxterm = pkgs.writeScriptBin "k8s-jmxterm" ''
    #!${pkgs.bash}/bin/bash
    set -e
    if [ $# -gt 2 ];then
    echo "Usage: $(basename $0) [pod name] [cmd]"
    exit 1
    fi
    NAME="debug-jmxterm"
    test "$1" != "" && NAME="$1"
    if ! which kubectl &>/dev/null;then
    echo "kubectl not found, please run the command below:"
    echo
    CMD="echo"
    fi
    $CMD kubectl run $NAME --image=ewok/jmxterm -it --rm --restart='Never'
    sleep 1
    $CMD kubectl get po | grep $NAME && echo "ERROR: Pod was not deleted!"
  '';

  k8s-alpine = pkgs.writeScriptBin "k8s-alpine" ''
    #!${pkgs.bash}/bin/bash
    set -e
    if [ $# -gt 2 ];then
    echo "Usage: $(basename $0) [pod name] [cmd]"
    exit 1
    fi
    NAME="debug-alpine"
    test "$1" != "" && NAME="$1"
    if ! which kubectl &>/dev/null;then
    echo "kubectl not found, please run the command below:"
    echo
    CMD="echo"
    fi
    $CMD kubectl run $NAME --image=alpine -it --rm --restart='Never'
    sleep 1
    $CMD kubectl get po | grep $NAME && echo "ERROR: Pod was not deleted!"
  '';
in
{
  options.modules.dev.k8s = {
    enable = mkOption {
      type = types.bool;
      description = "Enable k8s environment.";
      default = true;
    };
  };

  config = mkIf (dev.enable && cfg.enable) {
    home-manager.users."${username}" = {
      home.packages = with pkgs; [
        kubectl
        kubecfg
        kubectx
        minikube
        google-cloud-sdk
      ] ++ [
        k8s-argo
        k8s-busybox
        k8s-kafka-client
        k8s-jmxterm
        k8s-alpine
        k8s-mysql
        k8s-mysqldump
      ];
    };
  };
}
