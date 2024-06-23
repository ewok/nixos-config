(local lib (require :lib))

(lib.reg_ft :lua (fn [ev]
                   (let [(wk-ok? wk) (pcall require :which-key)]
                     (set vim.opt_local.expandtab true)
                     (set vim.opt_local.shiftwidth 4)
                     (set vim.opt_local.tabstop 4)
                     (set vim.opt_local.softtabstop 4)
                     (set vim.opt_local.foldmethod :marker)
                     (set vim.opt_local.foldmarker "{{{,}}}")
                     (set vim.opt_local.foldexpr "nvim_treesitter#foldexpr()")
                     (when wk-ok?
                       (wk.register {:ec {:name "Eval Comment[conjure]"}
                                     :e {:name "Eval[conjure]"}
                                     :l {:name "Log[conjure]"}
                                     :r {:name "Reset[conjure]"}}
                                    {:prefix :<leader>c
                                     :mode :n
                                     :buffer ev.buf})))))

(lib.reg_lsp :lua_ls {:Lua {:diagnostics.globals [:vim]}})

(lib.reg_ft_once :lua
                 #(let [null-ls (require :null-ls)]
                    (null-ls.register [null-ls.builtins.formatting.stylua])))
