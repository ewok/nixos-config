(local lib (require :lib))

(lib.reg_ft :fennel (fn [ev]
                      (let [(wk-ok? wk) (pcall require :which-key)]
                        (set vim.opt_local.expandtab true)
                        (set vim.opt_local.shiftwidth 2)
                        (set vim.opt_local.tabstop 2)
                        (set vim.opt_local.softtabstop 2)
                        (when wk-ok?
                          (wk.register {:ec {:name "Eval Comment[conjure]"}
                                        :e {:name "Eval[conjure]"}
                                        :l {:name "Log[conjure]"}
                                        :r {:name "Reset[conjure]"}
                                        :t {:name "Test[conjure]"}
                                        :p {1 :<cmd>FnlPeek<cr>
                                            2 "[fnl] Convert buffer"
                                            :noremap true}}
                                       {:prefix :<leader>c
                                        :mode :n
                                        :buffer ev.buf})))))

(lib.reg_lsp :fennel_ls {:fennel-ls {:extra-globals :vim}})

(lib.reg_ft_once :fennel
                 #(let [null-ls (require :null-ls)]
                    (null-ls.register [null-ls.builtins.formatting.fnlfmt])))
