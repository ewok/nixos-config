{ config, lib, pkgs, ... }:
let
  cfg = config.opt.lisps;
in
{
  options.opt.lisps = {
    enable = lib.mkEnableOption "lisps";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      clojure
      clojure-lsp
      clj-kondo
      babashka-unwrapped
      leiningen
    ];
    home.file.".clojure/deps.edn".text = ''
      {:deps {org.clojure/clojure {:mvn/version "1.11.3"}}
        :aliases
         {:nrepl-clj {:extra-deps {cider/cider-nrepl {:mvn/version "0.49.0"}},
                      :main-opts ["-m" "nrepl.cmdline" "--middleware"
                                  "[cider.nrepl/cider-middleware]" "--interactive"]},
          :nrepl-cljs
            {:extra-deps {cider/cider-nrepl {:mvn/version "0.49.0"},
                          cider/piggieback {:mvn/version "0.5.2"},
                          org.clojure/clojurescript {:mvn/version "1.10.339"}},
             :main-opts
               ["-m" "nrepl.cmdline" "--middleware"
                "[cider.nrepl/cider-middleware,cider.piggieback/wrap-cljs-repl]"]}
          :outdated {:replace-deps {olical/depot {:mvn/version "2.3.0"}}
                                :main-opts ["-m" "depot.outdated.main"]}
                }}
    '';
  };
}
