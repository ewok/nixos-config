(local {: pack : map} (require :lib))

[(pack :kevinhwang91/nvim-bqf
       {:ft :qf
        :config #(let [bqf (require :bqf)]
                   (bqf.setup {:func_map {:tab :<C-t>
                                          :vsplit :<C-v>
                                          :split :<C-s>}
                               :filter {:fzf {:action_for {:ctrl-t :tabedit
                                                           :ctrl-v :vsplit
                                                           :ctrl-s :split}}}}))})
 (pack :stevearc/quicker.nvim {:ft :qf
                               :init #(do
                                        (map :n :<leader>q
                                             "<cmd>lua require('quicker').toggle()<cr>"
                                             {:noremap true} "Toggle quickfix")
                                        (map :n :<leader>tl
                                             "<cmd>lua require('quicker').toggle({loclist = true})<cr>"
                                             {:noremap true} "Toggle loclist"))
                               :config true})]
