(local {: pack} (require :lib))

[(pack :dcampos/nvim-snippy {:event [:InsertEnter]
                             :config #(vim.cmd "
                imap <expr> <Tab> snippy#can_expand_or_advance() ? '<Plug>(snippy-expand-or-advance)' : '<Tab>'
                imap <expr> <S-Tab> snippy#can_jump(-1) ? '<Plug>(snippy-previous)' : '<S-Tab>'
                smap <expr> <Tab> snippy#can_jump(1) ? '<Plug>(snippy-next)' : '<Tab>'
                smap <expr> <S-Tab> snippy#can_jump(-1) ? '<Plug>(snippy-previous)' : '<S-Tab>'
                xmap <Tab> <Plug>(snippy-cut-text)
                          ")})
 (pack :dcampos/cmp-snippy {:config false :event [:InsertEnter]})
 (pack :honza/vim-snippets {:event [:InsertEnter]})]
