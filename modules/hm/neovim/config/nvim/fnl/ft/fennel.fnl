(local lib (require :lib))

(lib.reg_ft :fennel
            (fn [ev]
              (let [(wk-ok? wk) (pcall require :which-key)]
                (set vim.opt_local.expandtab true)
                (set vim.opt_local.shiftwidth 2)
                (set vim.opt_local.tabstop 2)
                (set vim.opt_local.softtabstop 2)
                (when wk-ok?
                  (wk.add [{1 :<leader>ce
                            :buffer ev.buf
                            :group "Eval[conjure]"}
                           {1 :<leader>cec
                            :buffer ev.buf
                            :group "Eval Comment[conjure]"}
                           {1 :<leader>cl :buffer ev.buf :group "Log[conjure]"}
                           {1 :<leader>cp
                            2 :<cmd>FnlPeek<cr>
                            :buffer ev.buf
                            :desc "[fnl] Convert buffer"}
                           {1 :<leader>cr
                            :buffer ev.buf
                            :group "Reset[conjure]"}
                           {1 :<leader>ct
                            :buffer ev.buf
                            :group "Test[conjure]"}])))))

(lib.reg_lsp :fennel_ls {:fennel-ls {:extra-globals :vim}})

(lib.reg_ft_once :fennel
                 #(let [null-ls (require :null-ls)]
                    (null-ls.register [null-ls.builtins.formatting.fnlfmt])))
