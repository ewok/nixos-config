(local {: reg-ft} (require :lib))

(reg-ft "vim" #(do
    (set vim.opt_local.expandtab true)
    (set vim.opt_local.shiftwidth 4)
    (set vim.opt_local.tabstop 4)
    (set vim.opt_local.softtabstop 4)
    (set vim.opt_local.foldmethod "expr")))

