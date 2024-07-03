(local {: pack} (require :lib))

[(pack :chrishrb/gx.nvim {:keys [{1 :gx 2 :<cmd>Browse<cr> :mode [:n :x]}]
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
 (pack :axieax/urlview.nvim {:cmd [:UrlView]
                             :keys [{1 :<leader>ou
                                     2 ":UrlView buffer picker=telescope<cr>"
                                     :mode :n
                                     :silent true
                                     :desc "Open URL"}]
                             :config true})]
