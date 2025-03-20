(local {: pack} (require :lib))

(pack :Exafunction/codeium.nvim
      {:cmd [:Codeium]
       :enabled false
       :keys [{1 :<leader>tc
               2 #(do
                    (vim.notify "Codeium Enabled" :INFO {:title :Codeium}))
               :mode :n
               :desc "Toggle Codeium for Buffer"}]
       :config #(let [codeium (require :codeium)]
                  (codeium.setup))})
