(local {: pack} (require :lib))
(local conf (require :conf))

(pack :folke/which-key.nvim
      {:event [:VeryLazy]
       :config #(let [wk (require :which-key)]
                  (wk.setup {:plugins {:presets {:operators false
                                                 :motions true}
                                       :spelling {:enabled true
                                                  :suggestions 20}}
                             :icons {:breadcrumb conf.icons.wk.breadcrumb
                                     :separator conf.icons.wk.separator
                                     :group conf.icons.wk.group}
                             :window {:border :single}})
                  (wk.register {:th "Dark/Light theme"
                                :j "Goto Next buffer"
                                :k "Goto Prev buffer"
                                :b {:name :Buffer}
                                :c {:name :Code}
                                :cd {:name :Diff/Diagnostics}
                                :f {:name :Find}
                                :fs {:name :Settings}
                                ; :g {:name :Git}
                                :l {:name :Lsp}
                                :o {:name :Open}
                                :p {:name "Packages | Profiling"}
                                :s {:name :Session}
                                :y {:name :Yank}
                                :yf {:name :File}
                                :t {:name :Toggle}
                                :w {:name :Wiki}}
                               {:prefix :<leader> :mode :n})
                  (wk.register {[:6] {:name :Base64}
                                :c {:name :Code}
                                ; :g {:name :Git}
                                ; :gl {:name "Git Log"}
                                ; :gh {:name :Hunk}
                                :y {:name :Yank}
                                :w {:name :Wiki}}
                               {:prefix :<leader> :mode :x}))})
