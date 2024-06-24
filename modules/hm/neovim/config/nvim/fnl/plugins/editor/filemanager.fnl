(local {: pack : map : get_file_cwd} (require :lib))

(pack :echasnovski/mini.files
      {:keys [{1 :<leader>fp
               2 #(let [mf (require :mini.files)]
                    (mf.open (vim.fn.expand "%:p")))
               :mode :n
               :desc "Open Minifiles"}
              {1 :<leader>fP
               2 #(let [mf (require :mini.files)]
                    (mf.open (get_file_cwd)))
               :mode :n
               :desc "Open Minifiles"}]
       :config #(let [mf (require :mini.files)]
                  (mf.setup {:mappings {:close :q :go_in_plus :l :go_in :<cr>}
                             :windows {:preview false :width_preview 40}})

                  (fn map-split [buf-id lhs direction]
                    (let [rhs (fn []
                                (var new-target-window 0)
                                (vim.api.nvim_win_call (mf.get_target_window)
                                                       (fn []
                                                         (vim.cmd (.. direction
                                                                      " split"))
                                                         (set new-target-window
                                                              (vim.api.nvim_get_current_win))))
                                (mf.set_target_window new-target-window)
                                (mf.go_in))
                          desc (.. "Split " direction)]
                      (vim.keymap.set :n lhs rhs {:buffer buf-id : desc})))

                  (fn files-set-cwd [path]
                    (let [cur-entry-path (. (mf.get_fs_entry) :path)
                          cur-directory (vim.fs.dirname cur-entry-path)]
                      (vim.fn.chdir cur-directory)))

                  (vim.api.nvim_create_autocmd :User
                                               {:pattern :MiniFilesBufferCreate
                                                :callback (fn [args]
                                                            (let [cur-buf args.data.buf_id]
                                                              (map-split cur-buf
                                                                         :<C-S>
                                                                         "belowright horizontal")
                                                              (map-split cur-buf
                                                                         :<C-V>
                                                                         "belowright vertical")
                                                              (map :n :cd
                                                                   files-set-cwd
                                                                   {:buffer cur-buf}
                                                                   "Set cwd")
                                                              (map :n :<c-h>
                                                                   :<left>
                                                                   {:buffer cur-buf})
                                                              (map :n :<c-l>
                                                                   :<right>
                                                                   {:buffer cur-buf})
                                                              (map :n :<c-j>
                                                                   :<down>
                                                                   {:buffer cur-buf})
                                                              (map :n :<c-k>
                                                                   :<up>
                                                                   {:buffer cur-buf})))}))})
