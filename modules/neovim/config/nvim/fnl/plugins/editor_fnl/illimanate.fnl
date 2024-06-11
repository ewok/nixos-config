(local {: pack} (require :lib))

(pack :RRethy/vim-illuminate
      {:event [:BufNewFile :BufReadPre]
       :config #(let [illuminate (require :illuminate)
                      conf (require :conf)]
                  (illuminate.configure {:delay 100
                                         :under_cursor true
                                         :modes_denylist [:i]
                                         :providers [:regex :treesitter]
                                         :filetypes_denylist conf.ui_ft}))})
