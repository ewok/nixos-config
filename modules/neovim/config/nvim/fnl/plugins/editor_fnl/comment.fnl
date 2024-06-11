(local {: pack} (require :lib))

(pack :numToStr/Comment.nvim
      {:event [:BufNewFile :BufReadPre]
       :config #((-> (require :Comment) (. :setup)) {:opleader {:line :gc
                                                                :block :gb}
                                                     :toggler {:line :gcc
                                                               :block :gcb}
                                                     :extra {:above :gck
                                                             :below :gcj
                                                             :eol :gcA}})})
