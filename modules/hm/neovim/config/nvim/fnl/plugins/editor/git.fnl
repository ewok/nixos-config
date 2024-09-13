(local {: pack : map : reg_ft} (require :lib))

[;;(pack :f-person/git-blame.nvim {:event :VeryLazy})
 (pack :FabijanZulj/blame.nvim
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
               {1 :<leader>gfh
                2 "<cmd>DiffviewFileHistory %<cr>"
                :mode [:n]
                :desc "File history"}
               {1 :<leader>gP 2 "<cmd>Neogit push<cr>" :desc :Push...}
               {1 :<leader>gp 2 "<cmd>Neogit pull<cr>" :desc :Pull...}
               {1 :<leader>gl 2 "<cmd>Neogit log<cr>" :desc :Log...}
               {1 :<leader>gd 2 "<cmd>Neogit diff<cr>" :desc :Diff...}]
        :dependencies [:sindrets/diffview.nvim]
        :config #(let [ng (require :neogit)]
                   (ng.setup {:use_per_project_settings true
                              :remember_settings true
                              :mappings {:status {:gx :OpenTree := :Toggle}}
                              :auto_show_console true
                              :console_timeout 5000
                              :disable_insert_on_commit true})
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
                                       :signs {:add "│"
                                               :change "│"
                                               :delete "_"}}
                                :mappings {:apply :gh
                                           :reset :gH
                                           :textobject :gh
                                           :goto_first ""
                                           :goto_prev "[g"
                                           :goto_next "]g"
                                           :gotoGit_last ""}}))})]
