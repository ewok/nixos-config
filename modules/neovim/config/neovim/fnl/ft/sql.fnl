(local {: reg-ft} (require :lib))

(reg-ft "mysql" #(do
    (set vim.opt_local.expandtab true)
    (set vim.opt_local.shiftwidth 2)
    (set vim.opt_local.tabstop 2)
    (set vim.opt_local.softtabstop 2)))

(reg-ft "sql" #(do
    (set vim.opt_local.expandtab true)
    (set vim.opt_local.shiftwidth 2)
    (set vim.opt_local.tabstop 2)
    (set vim.opt_local.softtabstop 2)))

