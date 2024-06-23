(local lib (require :lib))

(lib.reg_ft :clojure
            (fn [ev]
              (let [(wk-ok? wk) (pcall require :which-key)]
                (set vim.opt_local.expandtab true)
                (set vim.opt_local.shiftwidth 2)
                (set vim.opt_local.tabstop 2)
                (set vim.opt_local.softtabstop 2)
                (when wk-ok?
                  (wk.register {:c {:name "Connect[conjure]"}
                                :ec {:name "Eval Comment[conjure]"}
                                :e {:name "Eval[conjure]"}
                                :l {:name "Log[conjure]"}
                                :r {:name "Refresh[conjure]"}
                                :s {:name "Session[conjure]"}
                                :t {:name "Test[conjure]"}
                                :v {:name "View[conjure]"}}
                               {:prefix :<leader>c :mode :n :buffer ev.buf})))))

(lib.reg_lsp :clojure_lsp {})

(lib.reg_ft_once :clojure
                 #(let [null-ls (require :null-ls)]
                    (null-ls.register [null-ls.builtins.formatting.zprint])))
