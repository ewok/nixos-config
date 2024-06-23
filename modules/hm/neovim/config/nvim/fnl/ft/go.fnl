(local lib (require :lib))

(lib.reg_ft :go #(do
                   (set vim.opt_local.expandtab true)
                   (set vim.opt_local.shiftwidth 4)
                   (set vim.opt_local.tabstop 4)
                   (set vim.opt_local.softtabstop 4)))

(lib.reg_lsp :gopls {})
