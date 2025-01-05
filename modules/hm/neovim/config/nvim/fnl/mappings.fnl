(local {: map!} (require :lib))
(local conf (require :conf))

(local md {:noremap true :silent true})

;; Converters
(map! :v :<leader>6d "c<c-r>=system('base64 --decode', @\")<cr><esc>"
      {:noremap true :silent true} "Decode Base64")

(map! :v :<leader>6e "c<c-r>=system('base64', @\")<cr><esc>"
      {:noremap true :silent true} "Encode Base64")

;; Open current cwd note page
(fn open_mind [] ; git remote get-url origin 2>/dev/null | sed 's/^.*://;s/.git$//'
  (vim.cmd (.. "e " conf.notes_dir :/mind/
               (let [git# (io.popen "git remote get-url origin 2>/dev/null | sed 's/^.*://;s/.git$//'")
                     git (git#:read :*a)]
                 (if (= git "")
                     (string.match (vim.fn.getcwd) "([^/]+)$")
                     (let [(git _) (string.gsub (string.match git
                                                              "^%s*(.-)%s*$")
                                                "/" "_")]
                       git))) :.md)))

(map! :n :<leader>on open_mind {:noremap true :silent true} "Open CWD note")

;; Windows manipulation
(map! [:n] :<C-W>t "<cmd>tab split<CR>" md "Open in tab")
(map! [:n] :<C-W><C-T> "<cmd>tab split<CR>" md "Open in tab")

(map! [:n] :<C-W><C-J> ":resize +5<CR>" md "Increase height +5")
(map! [:n] :<C-W><C-K> ":resize -5<CR>" md "Decrease height -5")
(map! [:n] :<C-W><C-L> ":vertical resize +5<CR>" md "Increase width +5")
(map! [:n] :<C-W><C-H> ":vertical resize -5<CR>" md "Decrease width -5")
(map! [:n] :<C-W>q :<cmd>close<CR> md "Close window")
(map! [:n] :<C-W><C-Q> :<cmd>close<CR> md "Close window")

;; Folding
(map! [:n] "]z" "zjmzzMzvzz15<c-e>`z" md "Next Fold")
(map! [:n] "[z" "zkmzzMzvzz15<c-e>`z" md "Previous Fold")
(map! [:n] :zO :zczO md "Open all folds under cursor")
(map! [:n] :zC "zcV:foldc!<CR>" md "Close all folds under cursor")
(map! [:n] :z<Space> "mzzMzvzz15<c-e>`z" md "Show only current Fold")
(map! [:n] :<Space><Space> "za\"{{{\"" md "Toggle Fold")
(map! [:x] :<Space><Space> "zf\"}}}\"" md "Toggle Fold")

;; Yank
(map! [:n] :<leader>yy "<cmd>.w! ~/.vbuf<CR>" md "Yank to ~/.vbuf")
(map! [:n] :<leader>yp "<cmd>r ~/.vbuf<CR>" md "Paste from ~/.vbuf")
(map! [:x] :<leader>yy ":'<,'>w! ~/.vbuf<CR>" md "Yank to ~/.vbuf")
(map! [:n] :<leader>yfl ":let @+=expand(\"%\") . ':' . line(\".\")<CR>" md
      "Yank file name and line")

(map! [:n] :<leader>yfn ":let @+=expand(\"%\")<CR>" md "Yank file name")
(map! [:n] :<leader>yfp ":let @+=expand(\"%:p\")<CR>" md "Yank file path")

;; Profiling
(map! [:n] :<leader>PS
      "<cmd>profile start /tmp/profile_vim.log|profile func *|profile file *<CR>"
      md "Start")

(map! [:n] :<leader>PT
      "<cmd>profile stop|e /tmp/profile_vim.log|nmap <buffer> q :!rm /tmp/profile_vim.log<CR>"
      md "Stop")

;; Replace search
(vim.cmd "
nmap <expr>  MR  ':%s/\\(' . @/ . '\\)/\\1/g<LEFT><LEFT>'
vmap <expr>  MR  ':s/\\(' . @/ . '\\)/\\1/g<LEFT><LEFT>'")

;; Replace without yanking
(map! [:v] :p :P md "Replace without yanking")

;; Tunings
(map! [:n] :Y :y$ md "Yank to end of line")

;; Don't cancel visual select when shifting
(map! [:v] "<" :<gv md "Shift left")
(map! [:v] ">" :>gv md "Shift right")

;; Keep the cursor in place while joining lines
(map! [:n] :J "mzJ`z" md "Join lines")
(map! [:n] :gJ "mzgJ`z" md "Join lines")

;; [S]plit line (sister to [J]oin lines) S is covered by cc.
(map! [:n] :S "mzi<CR><ESC>`z" md "Split line")

;; Move to start of line
(fn start_line [mode]
  (let [mode (or mode :n)]
    (if (= mode :v) (vim.api.nvim_exec "normal! gv" nil))
    (let [cursor (vim.api.nvim_win_get_cursor (vim.api.nvim_get_current_win))]
      (vim.api.nvim_exec "normal ^" nil)
      (let [check_cursor (vim.api.nvim_win_get_cursor (vim.api.nvim_get_current_win))]
        (if (and (= (. cursor 1) (. check_cursor 1))
                 (= (. cursor 2) (. check_cursor 2)))
            (vim.api.nvim_exec "normal 0" nil))))))

(map! [:n] :H start_line md "Move to start of line")
(map! [:n] :L "$" md "Move to end of line")
(map! [:v] :H start_line md "Move to start of line")
(map! [:x] :L "$" md "Move to end of line")

;; Terminal
(vim.cmd "tnoremap <Esc> <C-\\><C-n>")

;; Don't move cursor when searching via *
(map! [:n] "*"
      ":let stay_star_view = winsaveview()<cr>*:call winrestview(stay_star_view)<CR>"
      md "Search for word under cursor")

;; Keep search matches in the middle of the window.
(map! [:n] :n :nzzzv md "Next search match")
(map! [:n] :N :Nzzzv md "Previous search match")

;; Lazy mapping
(map! [:n] :<leader>pu "<cmd>Lazy sync<CR>" md "Sync Packages")
(map! [:n] :<leader>pl "<cmd>Lazy home<CR>" md "List Packages")
(map! [:n] :<leader>pc #(do
                          (vim.cmd :FnlCompile!)
                          (vim.cmd :FnlClean)) md
      "Compile Configs")

(map! :i :<M-BS> :<C-W> md "Split hack")
