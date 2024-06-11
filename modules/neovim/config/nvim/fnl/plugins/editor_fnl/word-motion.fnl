(local {: pack} (require :lib))

(pack :chaoren/vim-wordmotion {:config false :event [:BufReadPre :BufNewFile]})
