(local lib (require :lib))

(lib.reg_ft :markdown
            #(let [map! lib.map
                   md {:noremap true :silent true :buffer true}]
               (set vim.opt_local.expandtab true)
               (set vim.opt_local.shiftwidth 4)
               (set vim.opt_local.tabstop 4)
               (set vim.opt_local.softtabstop 4)
               (set vim.wo.foldlevel 2)
               (set vim.wo.conceallevel 2)
               (map! [:n] :<leader>ce :<cmd>EvalBlock<CR> md "Run Block")
               (map! [:n] :<CR> "<Cmd>lua vim.lsp.buf.definition()<CR>" md
                     "Open Link")
               (map! [:v] :<CR>
                     ":'<,'>ZkNewFromTitleSelection { dir = vim.fn.expand('%:p:h') }<CR>"
                     md "Create Link")
               (map! [:n] :<leader>wb :<Cmd>ZkBacklinks<CR> md :Backlinks)
               (map! [:n] :<leader>wl :<Cmd>ZkLinks<CR> md :Links)
               (map! :n :tn "<cmd>MkdnTable 1 1<cr>" md "New Table")))

(lib.reg_lsp :zk {})

(lib.reg_ft_once :markdown
                 #(let [null-ls (require :null-ls)]
                    (null-ls.register [null-ls.builtins.formatting.prettier])))
