(local lib (require :lib))

(lib.reg_ft :python (fn [ev]
                      (let [(wk-ok? wk) (pcall require :which-key)]
                        (set vim.opt_local.expandtab true)
                        (set vim.opt_local.shiftwidth 4)
                        (set vim.opt_local.tabstop 4)
                        (set vim.opt_local.softtabstop 4)
                        (when wk-ok?
                          (wk.add [{1 :<leader>cc
                                    :buffer ev.buf
                                    :group "Connect[conjure]"}
                                   {1 :<leader>ce
                                    :buffer ev.buf
                                    :group "Eval[conjure]"}
                                   {1 :<leader>cec
                                    :buffer ev.buf
                                    :group "Eval Comment[conjure]"}
                                   {1 :<leader>cl
                                    :buffer ev.buf
                                    :group "Log[conjure]"}
                                   {1 :<leader>cr
                                    :buffer ev.buf
                                    :group "Reset[conjure]"}]))
                        (lib.map :n :<leader>cv :<cmd>VenvSelect<cr>
                                 {:noremap true :buffer true}
                                 "Select VirtualEnv"))))

(lib.reg_lsp :pyright {})

(lib.reg_ft_once :python
                 #(let [null-ls (require :null-ls)]
                    (null-ls.register [null-ls.builtins.formatting.black])))
