(local {: pack} (require :lib))

(fn config []
  (vim.cmd "

                        imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'
                        inoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<Cr>
                        snoremap <silent> <Tab> <cmd>lua require('luasnip').jump(1)<Cr>
                        snoremap <silent> <S-Tab> <cmd>lua require('luasnip').jump(-1)<Cr>
                  "))

(if (= :luasnip conf.options.snippets)
    [(pack :L3MON4D3/LuaSnip {:build "make install_jsregexp" : config})
     (pack :saadparwaiz1/cmp_luasnip {:config false})
     (pack :rafamadriz/friendly-snippets
           {:event [:InsertEnter]
            :config #(let [from_vscode (require :luasnip.loaders.from_vscode)]
                       (from_vscode.lazy_load))})]
    [])
