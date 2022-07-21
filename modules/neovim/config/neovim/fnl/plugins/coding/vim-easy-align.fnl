;; Allignment
(local {: pack : map!} (require :lib))

(pack :junegunn/vim-easy-align
      {:event [:BufReadPre :BufNewFile]
       :config (fn []
                 (map! [:n] :ga "<Plug>(LiveEasyAlign)" {:noremap true}
                       "Align Block")
                 (map! [:x] :ga "<Plug>(LiveEasyAlign)" {:noremap true}
                       "Align Block"))})
