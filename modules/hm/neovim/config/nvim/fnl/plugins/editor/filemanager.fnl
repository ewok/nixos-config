(local {: pack : map : get_file_cwd : reg_ft} (require :lib))

[(pack :stevearc/oil.nvim
       {:cmd :Oil
        :dependencies [(pack :refractalize/oil-git-status.nvim)]
        :init #(do
                 (map :n :<leader>fp :<CMD>Oil<CR> {} "Open parent directory"))
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
