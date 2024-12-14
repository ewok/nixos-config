(local {: pack} (require :lib))

(pack :RRethy/vim-illuminate
      {:event [:BufNewFile :BufReadPre]
       :config #(let [illuminate (require :illuminate)
                      conf (require :conf)]
                  (vim.cmd.highlight "illuminatedCurWord cterm=underline gui=underline")
                  (illuminate.configure {:delay 100
                                         :under_cursor false
                                         :modes_denylist [:i]
                                         :providers [:regex :treesitter]
                                         :filetypes_denylist conf.ui_ft}))})
