(local {: pack : map : reg_ft} (require :lib))
(local conf (require :conf))

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
                :desc "Git Blame"}]
        :config #(let [blame (require :blame)]
                   (blame.setup {}))})
 (pack :ruifm/gitlinker.nvim
       {:keys [{:mode :n
                1 :<leader>gx
                2 "<cmd>lua require'gitlinker'.get_buf_range_url('n', {action_callback = require'gitlinker.actions'.open_in_browser})<cr>"
                :desc :GBrowse}
               {:mode :v
                1 :<leader>gx
                2 "<cmd>lua require'gitlinker'.get_buf_range_url('v', {action_callback = require'gitlinker.actions'.open_in_browser})<cr>"
                :desc :GBrowse}]
        :config true
        :opts {:mappings nil}})
 (pack :NeogitOrg/neogit
       {:cmd [:Neogit :DiffviewFileHistory]
        :keys [{1 :<leader>gs 2 :<cmd>Neogit<cr> :mode [:n] :desc "Git Status"}
               {1 :<leader>gll
                2 "<cmd>Neogit log<cr>"
                :mode [:n]
                :desc "Git Log"}
               {1 :<leader>gd
                2 "<cmd>Neogit diff<cr>"
                :mode [:n]
                :desc "Git Diff"}
               {1 :<leader>gp
                2 "<cmd>Neogit pull<cr>"
                :mode [:n]
                :desc "Git Pull"}
               {1 :<leader>gP
                2 "<cmd>Neogit push<cr>"
                :mode [:n]
                :desc "Git Push"}
               {1 :<leader>glf
                2 "<cmd>DiffviewFileHistory %<cr>"
                :mode [:n]
                :desc "Git File Log"}]
        :dependencies [:sindrets/diffview.nvim]
        :config #(let [ng (require :neogit)]
                   (ng.setup {:use_per_project_settings true
                              :remember_settings true
                              :mappings {:status {:gx :OpenTree := :Toggle}}
                              :auto_show_console false
                              :console_timeout 5000})
                   (reg_ft :DiffviewFileHistory
                           (fn [ev]
                             (map :n :q :<cmd>tabclose<cr> {:buffer ev.buf}
                                  :Close))))})
 (pack :chrishrb/gx.nvim {:keys [{1 :gx 2 :<cmd>Browse<cr> :mode [:n :x]}]
                          :cmd [:Browse]
                          :config true})
 (pack :echasnovski/mini.diff
       {:event [:BufReadPre :BufNewFile]
        :version false
        :config #(let [diff (require :mini.diff)]
                   (map :n :<leader>gh "<cmd>lua MiniDiff.toggle_overlay()<cr>"
                        {:noremap true} "Show githunk overlay")
                   (diff.setup {:view {:style :sign
                                       :signs {:add "┃"
                                               :change "┃"
                                               :delete "_"}}
                                :mappings {:apply :gh
                                           :reset :gH
                                           :textobject :gh
                                           :goto_first ""
                                           :goto_prev "[g"
                                           :goto_next "]g"
                                           :goto_last ""}}))})]
