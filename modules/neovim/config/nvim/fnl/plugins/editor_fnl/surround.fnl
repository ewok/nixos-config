(local {: pack} (require :lib))

(pack :kylechui/nvim-surround {:version "*"
                               :event [:BufReadPre :BufNewFile]
                               :config true})
