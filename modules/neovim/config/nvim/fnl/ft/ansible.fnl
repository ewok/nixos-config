(local lib (require :lib))

(lib.reg_ft :ansible #(do
                        (set vim.opt_local.expandtab true)
                        (set vim.opt_local.shiftwidth 2)
                        (set vim.opt_local.tabstop 2)
                        (set vim.opt_local.softtabstop 2)))
