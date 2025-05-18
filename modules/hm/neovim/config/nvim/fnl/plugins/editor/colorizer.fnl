(local {: pack : map} (require :lib))

(pack :brenoprata10/nvim-highlight-colors
      {:cmd [:HighlightColors]
       :init #(map :n :<leader>tc "<cmd>HighlightColors On<CR>" {:silent true}
                   "Code Colorizer")
       :config #(let [nhc (require :nvim-highlight-colors)]
                  (nhc.setup {:render :background
                              :virtual_symbol "■"
                              :enable_named_colors true}))})
