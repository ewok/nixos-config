(local {: pack : map} (require :lib))

(pack :jiaoshijie/undotree
      {:init #(map :n :<leader>u "<cmd>lua require('undotree').toggle()<cr>"
                   {:silent true} "Toggle Undo Tree")})
