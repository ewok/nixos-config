(local {: pack : map : reg_ft} (require :lib))

(local conf (require :conf))

[(pack :nvim-neo-tree/neo-tree.nvim
       {:enabled conf.packages.neotree
        :branch :v3.x
        :cmd :Neotree
        :init #(do
                 (map :n ";"
                      "<CMD>Neotree buffers focus dir=/ reveal toggle float<CR>"
                      {:noremap true} "Open buffers")
                 (map :n :<leader>n "<CMD>Neotree toggle left reveal<CR>"
                      {:noremap true} "Open NeoTree"))
        :config #(let [ntree (require :neo-tree)
                       command (require :neo-tree.command)]
                   (ntree.setup {:close_if_last_window true
                                 :popup_border_style :rounded
                                 :enable_git_status true
                                 :enable_diagnostics true
                                 :open_files_do_not_replace_types [:terminal
                                                                   :trouble
                                                                   :qf]
                                 :sort_case_insensitive false
                                 :bind_to_cwd false
                                 :event_handlers [{:event :file_open_requested
                                                   :handler #(command.execute {:action :close})}]
                                 :window {:position :left
                                          :width 40
                                          :mapping_options {:noremap true
                                                            :nowait true}
                                          :mappings {:<space> {1 :toggle_node
                                                               :nowait true}
                                                     :l :open
                                                     :<C-p> {1 :toggle_preview
                                                         :config {:use_float true
                                                                  :use_image_nvim false}}
                                                     :L :focus_preview
                                                     :<C-s> :open_split
                                                     :<C-v> :open_vsplit
                                                     :<C-t> :open_tabnew
                                                     :<cr> :open_drop
                                                     :h :close_node
                                                     :zc :close_all_nodes
                                                     :zo :expand_all_nodes
                                                     :a {1 :add
                                                         :config {:show_path :relative}}
                                                     :o {1 :add
                                                         :config {:show_path :relative}}
                                                     :A {1 :add_directory
                                                         :config {:show_path :relative}}
                                                     :c {1 :copy
                                                         :config {:show_path :relative}}
                                                     :m {1 :move
                                                         :config {:show_path :relative}}
                                                     :u :navigate_up
                                                     :C :noop
                                                     :z :noop
                                                     :s {1 :show_help
                                                         :nowait false
                                                         :config {:title "Order by"
                                                                  :prefix_key :s}}
                                                     :oc :noop
                                                     :od :noop
                                                     :og :noop
                                                     :om :noop
                                                     :on :noop
                                                     :os :noop
                                                     :ot :noop
                                                     :sc {1 :order_by_created
                                                          :nowait false}
                                                     :sd {1 :order_by_diagnostics
                                                          :nowait false}
                                                     :sg {1 :order_by_git_status
                                                          :nowait false}
                                                     :sm {1 :order_by_modified
                                                          :nowait false}
                                                     :sn {1 :order_by_name
                                                          :nowait false}
                                                     :ss {1 :order_by_size
                                                          :nowait false}
                                                     :st {1 :order_by_type
                                                          :nowait false}}}
                                 :filesystem {:filtered_items {;:visible false
                                                               ;                              :hide_dotfiles false
                                                               ;                              :hide_gitignored false
                                                               ;                              :hide_hidden true
                                                               :hide_by_name [:.direnv]
                                                               :hide_by_pattern [;"*.meta"
                                                                                 ;"*/src/*/tsconfig.json"
                                                                                 ]
                                                               :always_show [:.gitignored]
                                                               :always_show_by_pattern [:.env*
                                                                                        :.gitlab*]
                                                               :never_show [:.DS_Store
                                                                            :thumbs.db]
                                                               :never_show_by_pattern [:.null-ls_*]}
                                              :follow_current_file {:enabled true
                                                                    :leave_dirs_open false}
                                              :group_empty_dirs true
                                              :hijack_netrw_behavior :open_default
                                              :use_libuv_file_watcher false
                                              :window {:mappings {";" {1 #(do
                                                                            ;(vim.api.nvim_exec "Neotree close"
                                                                            ;                   true)
                                                                            (vim.api.nvim_exec "Neotree focus git_status float"
                                                                                               true))}}
                                                       :fuzzy_finder_mappings {:<down> :move_cursor_down
                                                                               :<C-j> :move_cursor_down
                                                                               :<up> :move_cursor_up
                                                                               :<C-k> :move_cursor_up
                                                                               ; '<key>' function(state) ... end,
                                                                               }}
                                              ;commands = {} -- Add a custom command or override a global one using the same function name
                                              }
                                 :git_status {:window {:mappings {";" {1 #(do
                                                                            (vim.api.nvim_exec "Neotree close"
                                                                                               true)
                                                                            (vim.api.nvim_exec "Neotree focus buffers float reveal dir=/"
                                                                                               true))}
                                                                  :u :noop}}}
                                 :buffers {:bind_to_cwd false
                                           :follow_current_file {:enabled true
                                                                 :leave_dirs_open false}
                                           :group_empty_dirs true
                                           :show_unloaded true
                                           :window {:mappings {";" {1 #(do
                                                                         (vim.api.nvim_exec "Neotree close"
                                                                                            true)
                                                                         (vim.api.nvim_exec "Neotree focus filesystem float reveal"
                                                                                            true))}
                                                               :u :noop
                                                               :bd :noop
                                                               :d :buffer_delete}}}}))})
 (pack :stevearc/oil.nvim
       {:enabled conf.packages.oil
        :cmd :Oil
        :dependencies [(pack :refractalize/oil-git-status.nvim)]
        ;:init #(do
        ;         (map :n :<leader>fp :<CMD>Oil<CR> {} "Open parent directory"))
        :config #(let [oil (require :oil)
                       oil-git (require :oil-git-status)]
                   (reg_ft :oil
                           (fn [ev]
                             (map :n :<C-T>
                                  #(do
                                     (vim.cmd "tab split")
                                     (oil.select))
                                  {:buffer ev.buf} "Open in Tab")
                             (map [:n :x] :H :<left> {:buffer ev.buf})
                             (map [:n :x] :L :<right> {:buffer ev.buf})
                             (map [:n :x] :J :<down> {:buffer ev.buf})
                             (map [:n :x] :K :<up> {:buffer ev.buf})
                             (map :n "=" :<cmd>w<cr> {:buffer ev.buf})))
                   (oil.setup {:default_file_explorer true
                               :columns [:icon]
                               :skip_confirm_for_simple_edits false
                               :prompt_save_on_select_new_entry true
                               :cleanup_delay_ms 2000
                               :win_options {:signcolumn "yes:2"}
                               :delete_to_trash true
                               :use_default_keymaps false
                               :view_options {:show_hidden true}
                               :keymaps {:g? :actions.show_help
                                         :<CR> :actions.select
                                         :l :actions.select
                                         :<C-V> :actions.select_vsplit
                                         :<C-S> :actions.select_split
                                         :<C-p> :actions.preview
                                         :q :actions.close
                                         :R :actions.refresh
                                         :h :actions.parent
                                         "@" :actions.open_cwd
                                         :cd :actions.cd
                                         :cD :actions.tcd
                                         :gs :actions.change_sort
                                         :gx :actions.open_external
                                         :g. :actions.toggle_hidden
                                         "g\\" :actions.toggle_trash}})
                   (oil-git.setup {}))})]
