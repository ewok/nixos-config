(local {: pack} (require :lib))

(pack :christoomey/vim-tmux-navigator
      {:event [:VeryLazy]
       :init #(do
                (set vim.g.tmux_navigator_save_on_switch 2)
                (set vim.g.tmux_navigator_disable_when_zoomed 1))})
