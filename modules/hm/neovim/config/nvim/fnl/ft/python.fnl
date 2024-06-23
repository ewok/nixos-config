(local lib (require :lib))

(lib.reg_ft :python (fn [ev]
                      (let [(wk-ok? wk) (pcall require :which-key)]
                        (set vim.opt_local.expandtab true)
                        (set vim.opt_local.shiftwidth 4)
                        (set vim.opt_local.tabstop 4)
                        (set vim.opt_local.softtabstop 4)
                        (when wk-ok?
                          (wk.register {:c {:name "Connect[conjure]"}
                                        :ec {:name "Eval Comment[conjure]"}
                                        :e {:name "Eval[conjure]"}
                                        :l {:name "Log[conjure]"}
                                        :r {:name "Reset[conjure]"}}
                                       {:prefix :<leader>c
                                        :mode :n
                                        :buffer ev.buf}))
                        (lib.map :n :<leader>cv :<cmd>VenvSelect<cr>
                                 {:noremap true :buffer true}
                                 "Select VirtualEnv"))))

(lib.reg_lsp :pyright {})

(lib.reg_ft_once :python
                 #(let [null-ls (require :null-ls)]
                    (null-ls.register [null-ls.builtins.formatting.black])))
