(local {: map : pack} (require :lib))

(map :n :<C-w>O #(do
                   (vim.cmd :BufOnly)
                   (vim.cmd :LspRestart)) {:noremap true}
     "Wipe all buffers but one")

[(pack :famiu/bufdelete.nvim
       {:cmd [:Bdelete :Bwipeout]
        :init #(do
                 (map :n :<C-W>d :<CMD>Bdelete<CR> {:silent true}
                      "Close current buffer")
                 (map :n :<C-W><C-D> :<CMD>Bdelete<CR> {:silent true}
                      "Close current buffer"))})]
