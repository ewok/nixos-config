(local {: pack : map} (require :lib))

(pack :folke/zen-mode.nvim
      {:cmd [:ZenMode]
       :opts {:window {:backdrop 0.95
                       :width 0.7
                       :height 0.98
                       :options {:signcolumn :no
                                 :number false
                                 :relativenumber false
                                 :cursorline false
                                 :cursorcolumn false
                                 :foldcolumn :0
                                 :list false}}
              :plugins {:gitsigns {:enabled false} :tmux {:enabled true}}
              :on_open #(do
                          (set vim.o.winbar "")
                          (set vim.o.laststatus 0)
                          (set vim.o.cmdheight 0))
              :on_close #(do
                           (set vim.o.laststatus 3)
                           (set vim.o.cmdheight 1))}
       :init #(map :n :<leader>z :<cmd>ZenMode<cr> {:silent true :nowait true}
                   :Zoom)})
