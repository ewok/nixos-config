(local {: pack : map : reg_ft} (require :lib))

[(pack :FabijanZulj/blame.nvim
       {:cmd :BlameToggle
        :keys [{1 :<leader>cb
                2 #(let [pos (vim.fn.getcurpos)]
                     (vim.cmd "normal! gg")
                     (vim.cmd :BlameToggle)
                     (vim.fn.timer_start 500
                                         #(do
                                            (vim.fn.setpos "." pos)
                                            (vim.cmd "normal! zz"))))
                :mode [:n]
                :desc "Code Blame"}]
        :config #(let [blame (require :blame)]
                   (blame.setup {}))})
 (pack :chrishrb/gx.nvim {:keys [{1 :gx 2 :<cmd>Browse<cr> :mode [:n :x]}]
                          :cmd [:Browse]
                          :config true})
 (pack :ruifm/gitlinker.nvim
       {:keys [{:mode :n
                1 :<leader>cx
                2 "<cmd>lua require'gitlinker'.get_buf_range_url('n', {action_callback = require'gitlinker.actions'.open_in_browser})<cr>"
                :desc :GBrowse}
               {:mode :v
                1 :<leader>cx
                2 "<cmd>lua require'gitlinker'.get_buf_range_url('v', {action_callback = require'gitlinker.actions'.open_in_browser})<cr>"
                :desc :GBrowse}]
        :config #(let [gl (require :gitlinker)]
                   (gl.setup {:mappings :<localleader>gy}))
        :opts {:mappings nil}})
 (pack :NeogitOrg/neogit
       {:cmd [:Neogit :DiffviewFileHistory]
        :keys [{1 :<leader>g 2 :<cmd>Neogit<cr> :mode [:n] :desc "Git Status"}
               {1 :<leader>cdh
                2 "<cmd>DiffviewFileHistory %<cr>"
                :mode [:n]
                :desc "File history"}]
        :dependencies [:sindrets/diffview.nvim]
        :config #(let [ng (require :neogit)]
                   (ng.setup {:use_per_project_settings true
                              :remember_settings true
                              :mappings {:status {:gx :OpenTree := :Toggle}}
                              :auto_show_console true
                              :console_timeout 5000})
                   (reg_ft :DiffviewFileHistory
                           (fn [ev]
                             (map :n :q :<cmd>tabclose<cr> {:buffer ev.buf}
                                  :Close))))})
 (pack :echasnovski/mini.diff
       {:event [:BufReadPre :BufNewFile]
        :version false
        :config #(let [diff (require :mini.diff)]
                   (map :n :<leader>tg "<cmd>lua MiniDiff.toggle_overlay()<cr>"
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
                                           :goto_last ""}}))})]
