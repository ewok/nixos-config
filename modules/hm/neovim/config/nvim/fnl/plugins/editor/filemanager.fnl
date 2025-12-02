(local {: pack : map} (require :lib))

[(pack :nvim-mini/mini.files
       {:version "*"
        :dependencies [:nvim-mini/mini.icons]
        :config #(let [mini-files (require :mini.files)]
                   (mini-files.setup {:mappings {:go_in :L :go_in_plus :l}})
                   (let [map-split (fn [buf-id lhs direction]
                                     (let [rhs (fn []
                                                 ;; Make new window and set it as target
                                                 (let [cur-target (. (mini-files.get_explorer_state)
                                                                     :target_window)
                                                       new-target (vim.api.nvim_win_call cur-target
                                                                                         (fn []
                                                                                           (vim.cmd (.. direction
                                                                                                        " split"))
                                                                                           (vim.api.nvim_get_current_win)))]
                                                   (mini-files.set_target_window new-target)
                                                   (mini-files.go_in {:close_on_file true})))]
                                       (vim.keymap.set :n lhs rhs
                                                       {:buffer buf-id
                                                        :desc (.. "Split "
                                                                  direction)})))
                         ui_open #(vim.ui.open (. (mini-files.get_fs_entry)
                                                  :path))]
                     (vim.api.nvim_create_autocmd :User
                                                  {:pattern :MiniFilesBufferCreate
                                                   :callback (fn [args]
                                                               (map :n :gx
                                                                    ui_open
                                                                    {:buffer args.data.buf_id}
                                                                    "OS open")
                                                               (map :n :<esc>
                                                                    #(mini-files.close)
                                                                    {:buffer args.data.buf_id}
                                                                    :Close)
                                                               (map :n ";"
                                                                    #(mini-files.close)
                                                                    {:buffer args.data.buf_id}
                                                                    :Close)
                                                               (map-split args.data.buf_id
                                                                          :<C-s>
                                                                          "belowright horizontal")
                                                               (map-split args.data.buf_id
                                                                          :<C-v>
                                                                          "belowright vertical")
                                                               (map-split args.data.buf_id
                                                                          :<C-t>
                                                                          :tab))})))
        :init #(map :n :<space><space>
                    "<CMD>lua if not require('mini.files').close() then require('mini.files').open() end<CR>"
                    {:noremap true} "Open Files")})]
