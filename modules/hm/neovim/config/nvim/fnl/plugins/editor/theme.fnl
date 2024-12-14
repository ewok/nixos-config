(local {: pack : map} (require :lib))
(local conf (require :conf))

(fn update-bg [forced]
  (if (= 1 (vim.fn.filereadable (.. conf.home_dir :/Documents/theme_light)))
      (when (or forced (not= vim.o.background :light))
        (set vim.o.background :light))
      (when (or forced (not= vim.o.background :dark))
        (set vim.o.background :dark)))
  (vim.cmd "doautocmd ColorScheme")
  false)

(map :n :<leader>th #(do
                       (update-bg)
                       (os.execute (.. "toggle-theme "
                                       (if (= vim.o.background :light) :dark
                                           :light)))
                       (update-bg true)) {:noremap true}
     "Toggle theme Dark")

(pack :catppuccin/nvim
      {:name :catppuccin
       :priority 1000
       :lazy false
       :config #(let [catppuccin (require :catppuccin)]
                  (catppuccin.setup {:no_italic true
                                     :flavour :auto
                                     :background {:light :latte
                                                  :dark :macchiato}
                                     ;:custom_highlights (fn [colors]
                                     ;                     {:Visual {:bg colors.overlay4}
                                     ;                      :VisualNOS {:bg colors.overlay4}})
                                     :integrations {:fidget true
                                                    :which_key true
                                                    :navic {:enabled true}}})
                  (vim.cmd.colorscheme :catppuccin)
                  (update-bg true)
                  (vim.api.nvim_create_augroup :toggle-theme {:clear true})
                  (vim.api.nvim_create_autocmd [:FocusGained]
                                               {:group :toggle-theme
                                                :callback update-bg}))})
