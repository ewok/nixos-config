(local lib (require :lib))

(lib.reg_ft :json #(do
                     (set vim.opt_local.expandtab true)
                     (set vim.opt_local.shiftwidth 2)
                     (set vim.opt_local.tabstop 2)
                     (set vim.opt_local.softtabstop 2)))

(lib.reg_lsp :jsonls {})

(lib.reg_ft_once :json
                 #(let [null-ls (require :null-ls)]
                    (null-ls.register [null-ls.builtins.formatting.prettier])))
