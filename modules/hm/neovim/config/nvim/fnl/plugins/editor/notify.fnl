(local {: pack : map} (require :lib))

(pack :j-hui/fidget.nvim
      {:lazy false
       :config #(let [fidget (require :fidget)]
                  (fidget.setup {:notification {:override_vim_notify true
                                                :window {:normal_hl :Keyword
                                                         :align :top}
                                                :view {:stack_upwards false}}}))
       :init #(map :n :<leader>fn "<cmd>Fidget history<cr>" {:silent true}
                   "Find notices history")})
