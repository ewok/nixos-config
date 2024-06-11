(local {: pack : map} (require :lib))
(local conf (require :conf))

(pack :ntpeters/vim-better-whitespace
      {:event [:BufReadPre :BufNewFile]
       :config #(do
                  (set vim.g.better_whitespace_filetypes_blacklist conf.ui_ft)
                  (set vim.g.better_whitespace_operator :<localleader>S)
                  (map :n :<leader>cw ":StripWhitespace<CR>" {}
                       "Strip Whitespaces"))})
