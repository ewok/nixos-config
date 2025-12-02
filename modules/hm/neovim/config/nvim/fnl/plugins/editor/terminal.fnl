(local {: map : get_file_cwd} (require :lib))
(local conf (require :conf))

(map :n :<C-W>S #(if conf.in_tmux
                     (vim.cmd "silent !tmux split-window -v -l 20\\% -c %:p:h")
                     (vim.cmd "split term://bash"))
     {:noremap true :silent true} "Split window")

(map :n :<C-W>V #(if conf.in_tmux
                     (vim.cmd "silent !tmux split-window -h -l 20\\% -c %:p:h")
                     (vim.cmd "vsplit term://bash"))
     {:noremap true :silent true} "VSplit window")

(map :n :<leader>ott
     #(do
        (set vim.g.tth false)
        (vim.cmd (.. "silent !~/.config/tmux/tmux_toggle '" (get_file_cwd)
                     "' t"))) {:silent true} "Open bottom terminal")

(map :n :<leader>otf
     #(do
        (set vim.g.tth true)
        (vim.cmd (.. "silent !~/.config/tmux/tmux_toggle '" (get_file_cwd)
                     "' f"))) {:silent true} "Open floating terminal")

(map :n :<c-space> #(if vim.g.tth
                        (vim.cmd (.. "silent !~/.config/tmux/tmux_toggle '"
                                     (get_file_cwd) "' f"))
                        (vim.cmd (.. "silent !~/.config/tmux/tmux_toggle '"
                                     (get_file_cwd) "' t")))
     {:silent true} "Toggle bottom or float terminal")

;(map :n :<leader>gg
;     #(vim.cmd (.. "silent !tmux popup -d " (vim.uv.cwd)
;                   " -xC -yC -w90\\% -h90\\% -E lazygit")) {:silent true}
;     "Open lazygit in bottom terminal")

[]
