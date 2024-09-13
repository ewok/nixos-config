(local {: pack} (require :lib))
(local conf (require :conf))

;(pack :LunarVim/bigfile.nvim
;      {:event [:BufReadPre :BufNewFile]
;       :config #(let [bigfile (require :bigfile)]
;                  (bigfile.setup {:filesize conf.large_file_size}))})

(pack :pteroctopus/faster.nvim {:event [:BufReadPre :BufNewFile]})
