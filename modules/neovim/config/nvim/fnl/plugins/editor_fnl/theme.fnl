(local {: pack : map} (require :lib))

(map :n :<leader>th
     #(do
        (set vim.o.background (if (= vim.o.background :light) :dark :light))
        (os.execute (.. "toggle-theme " vim.o.background))) {:noremap true}
     "Toggle theme Dark")

(map :n :<leader>tha #(os.execute "toggle-theme auto") {:noremap true}
     "Toggle theme Auto")

(pack :catppuccin/nvim {:name :catppuccin
                        :priority 1000
                        :lazy false
                        :config #(let [catppuccin (require :catppuccin)]
                                   (catppuccin.setup {:no_italic true
                                                      :flavour :auto
                                                      :background {:light :latte
                                                                   :dark :macchiato}
                                                      :custom_highlights (fn [colors]
                                                                           {:Visual {:bg colors.overlay2}
                                                                            :VisualNOS {:bg colors.overlay2}})
                                                      :integrations {:fidget true
                                                                     :which_key true
                                                                     :navic {:enabled true}}})
                                   (vim.cmd.colorscheme :catppuccin)
                                   (set vim.o.background
                                        (if (= 1
                                               (vim.fn.filereadable :/tmp/theme_light))
                                            :light
                                            :dark)))})
