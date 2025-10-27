(local {: pack : map : reg_ft : umap} (require :lib))

(local conf (require :conf))

[(pack :nvim-neo-tree/neo-tree.nvim
       {:enabled conf.packages.neotree
        :branch :v3.x
        :cmd :Neotreefilee
        :init #(map :n ";"
                    "<CMD>Neotree buffers focus dir=/ reveal toggle float<CR>"
                    {:noremap true} "Open buffers")
        :config #(let [ntree (require :neo-tree)
                       command (require :neo-tree.command)
                       call-filesystem {1 #(do
                                             (vim.api.nvim_exec "Neotree close"
                                                                true)
                                             (vim.api.nvim_exec "Neotree focus filesystem float reveal"
                                                                true))}
                       call-close {1 #(vim.api.nvim_exec "Neotree close" true)}
                       ;; call-gitstatus {1 #(do
                       ;;                      (vim.api.nvim_exec "Neotree close"
                       ;;                                         true)
                       ;;                      (vim.api.nvim_exec "Neotree focus git_status float reveal"
                       ;;                                         true))}
                       call-oil {1 (fn [p]
                                     (let [p-tree p.tree
                                           p-path (. p-tree._.node_id_by_linenr
                                                     p.position.lnum)
                                           p-type (. (. p-tree.nodes.by_id
                                                        p-path)
                                                     :type)]
                                       (vim.api.nvim_exec (.. "Oil "
                                                              (if (= p-type
                                                                     :directory)
                                                                  p-path
                                                                  (vim.fn.fnamemodify p-path
                                                                                      ":h")))
                                                          true)))}]
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
                                                     :<C-l> :focus_preview
                                                     :<C-s> :open_split
                                                     :<C-v> :open_vsplit
                                                     :<C-t> :open_tabnew
                                                     :<cr> :open
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
                                                          :nowait false}
                                                     :/ :noop}}
                                 :filesystem {:filtered_items {:hide_by_name [:.direnv]
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
                                              :window {:mappings {";" call-close
                                                                  :ga :git_add_file
                                                                  :gs :git_add_file
                                                                  :gu :git_unstage_file
                                                                  :b :noop
                                                                  :i call-oil}}}
                                 ; :git_status {:window {:mappings {";" call-close
                                 ;                                  :s :git_add_file
                                 ;                                  :u :git_unstage_file
                                 ;                                  :b :noop
                                 ;                                  :gg :noop
                                 ;                                  :gp :noop
                                 ;                                  :gu :noop
                                 ;                                  :gU :noop
                                 ;                                  :gc :noop
                                 ;                                  :gr :noop
                                 ;                                  :sc :noop
                                 ;                                  :sd :noop
                                 ;                                  :sg :noop
                                 ;                                  :sm :noop
                                 ;                                  :sn :noop
                                 ;                                  :ss :noop
                                 ;                                  :st :noop}}}
                                 :buffers {:bind_to_cwd false
                                           :follow_current_file {:enabled true
                                                                 :leave_dirs_open false}
                                           :group_empty_dirs true
                                           :show_unloaded true
                                           :window {:mappings {";" call-filesystem
                                                               :ga :git_add_file
                                                               :gs :git_add_file
                                                               :gu :git_unstage_file
                                                               :bd :noop
                                                               :i call-oil
                                                               :d :buffer_delete}}}}))})
 (pack :stevearc/oil.nvim
       {:enabled conf.packages.oil
        :cmd :Oil
        :dependencies [(pack :refractalize/oil-git-status.nvim)]
        ; :init (map :n ";" :<CMD>Oil<CR> {:noremap true} "Open Oil")
        :config #(let [oil (require :oil)
                       oil-git (require :oil-git-status)]
                   (reg_ft :oil
                           (fn [ev]
                             (map :n :<C-t>
                                  #(do
                                     (vim.cmd "tab split")
                                     (oil.select))
                                  {:buffer ev.buf} "Open in Tab")
                             ;; (map [:n :x] :L :<right> {:buffer ev.buf})
                             ;; (map [:n :x] :H :<left> {:buffer ev.buf})
                             ;; (map [:n :x] :<C-j> :<down> {:buffer ev.buf})
                             ;; (map [:n :x] :<C-k> :<up> {:buffer ev.buf})
                             ;; (map [:n :x] :gi
                             ;;      #(do
                             ;;         (each [_ x (ipairs [:l
                             ;;                             :h
                             ;;                             :u
                             ;;                             :<C-t>
                             ;;                             :<C-V>
                             ;;                             :<C-S>
                             ;;                             :<C-p>])]
                             ;;           (umap [:n] x {:buffer ev.buf}))
                             ;;         (vim.notify "Editing is on" :INFO
                             ;;                     {:title :Oil}))
                             ;;      {:buffer ev.buf})
                             (map :n :w :<cmd>w<cr> {:buffer ev.buf})))
                   (oil.setup {:float {:padding 2
                                       :max_width 0.5
                                       :max_height 0.8
                                       :border :rounded
                                       :win_options {:winblend 0}
                                       :get_win_title nil
                                       :preview_split :auto}
                               :default_file_explorer true
                               :columns [:icon]
                               :skip_confirm_for_simple_edits false
                               :prompt_save_on_select_new_entry true
                               :cleanup_delay_ms 2000
                               :win_options {:signcolumn "yes:2"}
                               :delete_to_trash false
                               :use_default_keymaps false
                               :view_options {:show_hidden true}
                               :keymaps {:g? :actions.show_help
                                         :<CR> :actions.select
                                         ; :l :actions.select
                                         :<C-v> :actions.select_vsplit
                                         :<C-s> :actions.select_split
                                         :<C-p> :actions.preview
                                         ; :h :actions.parent
                                         ; :u :actions.parent
                                         :q :actions.close
                                         ; :<Esc> :actions.close
                                         ; ";" :actions.close
                                         :R :actions.refresh
                                         "@" :actions.open_cwd
                                         :. :actions.cd
                                         :gs :actions.change_sort
                                         :gx :actions.open_external
                                         ; :H :actions.toggle_hidden
                                         "g\\" :actions.toggle_trash}})
                   (oil-git.setup {}))})]
