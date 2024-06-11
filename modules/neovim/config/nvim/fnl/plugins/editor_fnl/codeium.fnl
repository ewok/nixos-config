(local {: pack} (require :lib))

(local conf (require :conf))

(pack :Exafunction/codeium.nvim
      {:cmd [:Codeium]
       :keys [{1 :<leader>tc
               2 #(do
                    (vim.notify "Codeium Enabled" :INFO {:title :Codeium}))
               :mode :n
               :desc "Toggle Codeium for Buffer"}]
       :config #(let [codeium (require :codeium)]
                  (codeium.setup {:tools {:language_server (.. conf.home_dir
                                                               :/.nix-profile/bin/codeium-lsp)}}))})
