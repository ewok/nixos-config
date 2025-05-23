(local {: pack : map : reg_ft} (require :lib))

[(pack :FabijanZulj/blame.nvim
       {:cmd :BlameToggle
        :keys [{1 :<leader>gb
                2 #(let [pos (vim.fn.getcurpos)]
                     (vim.cmd "normal! gg")
                     (vim.cmd :BlameToggle)
                     (vim.fn.timer_start 500
                                         #(do
                                            (vim.fn.setpos "." pos)
                                            (vim.cmd "normal! zz"))))
                :mode [:n]
                :desc :Blame}]
        :config #(let [blame (require :blame)]
                   (blame.setup {}))})
 (pack :NeogitOrg/neogit
       {:cmd [:Neogit :DiffviewOpenFileHistory]
        :keys [{1 :<leader>gs 2 :<cmd>Neogit<cr> :mode [:n] :desc "Git Status"}
               {1 :<leader>gg 2 :<cmd>Neogit<cr> :mode [:n] :desc "Git Status"}
               {1 :<leader>gfd
                2 "<cmd>DiffviewFileHistory %<cr>"
                :mode [:n]
                :desc "Diff history"}
               {1 :<leader>gfl
                2 :<cmd>NeogitLog<cr>
                :mode [:n]
                :desc "Line history"}
               {1 :<leader>gfl
                2 ":NeogitLog<cr>"
                :mode [:v]
                :desc "Line history"}]
        :dependencies [:sindrets/diffview.nvim]
        :config #(let [ng (require :neogit)]
                   (ng.setup {:use_per_project_settings true
                              :remember_settings true
                              :mappings {:status {:gx :OpenTree := :Toggle}
                                         :finder {:<c-j> :Next
                                                  :<c-k> :Previous}}
                              :auto_show_console true
                              :console_timeout 500
                              :disable_insert_on_commit true
                              ;:kind :tab
                              ;:commit_editor {:kind :auto}
                              })
                   (reg_ft :DiffviewFileHistory
                           (fn [ev]
                             (map :n :q :<cmd>tabclose<cr> {:buffer ev.buf}
                                  :Close))))})
 (pack :echasnovski/mini.diff
       {:event [:BufReadPre :BufNewFile]
        :version false
        :config #(let [diff (require :mini.diff)]
                   (map :n :<leader>gh "<cmd>lua MiniDiff.toggle_overlay()<cr>"
                        {:noremap true} "Toggle githunk overlay")
                   (diff.setup {:view {:style :sign
                                       :signs {:add "+"
                                               :change "~"
                                               :delete "▁"
                                               ;:add "│"
                                               ;:change "│"
                                               ;:delete "_"
                                               }}
                                :mappings {:apply :gh
                                           :reset :gH
                                           :textobject :gh
                                           :goto_first ""
                                           :goto_prev "[g"
                                           :goto_next "]g"
                                           :gotoGit_last ""}}))})
 (pack :fredeeb/tardis.nvim
       {:config true :cmd :Tardis :keys [{1 :<leader>gfh}]})]
