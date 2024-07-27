(local lib (require :lib))

(lib.reg_ft :clojure
            (fn [ev]
              (let [(wk-ok? wk) (pcall require :which-key)]
                (set vim.opt_local.expandtab true)
                (set vim.opt_local.shiftwidth 2)
                (set vim.opt_local.tabstop 2)
                (set vim.opt_local.softtabstop 2)
                (when wk-ok?
                  (wk.add [{1 :<leader>cc
                            :buffer ev.buf
                            :group "Connect[conjure]"}
                           {1 :<leader>cec
                            :buffer ev.buf
                            :group "Eval Comment[conjure]"}
                           {1 :<leader>ce
                            :buffer ev.buf
                            :group "Eval[conjure]"}
                           {1 :<leader>cl :buffer ev.buf :group "Log[conjure]"}
                           {1 :<leader>cr
                            :buffer ev.buf
                            :group "Refresh[conjure]"}
                           {1 :<leader>cs
                            :buffer ev.buf
                            :group "Session[conjure]"}
                           {1 :<leader>ct
                            :buffer ev.buf
                            :group "Test[conjure]"}
                           {1 :<leader>cv
                            :buffer ev.buf
                            :group "View[conjure]"}])))))

(lib.reg_lsp :clojure_lsp {})

(lib.reg_ft_once :clojure
                 #(let [null-ls (require :null-ls)]
                    (null-ls.register [null-ls.builtins.formatting.zprint])))
