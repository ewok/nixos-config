(local {: pack : map} (require :lib))
(local conf (require :conf))

[:debugloop/telescope-undo.nvim
 (pack :nvim-telescope/telescope-fzf-native.nvim {:build :make})
 (pack :folke/todo-comments.nvim
       {:keys [{1 :<leader>fd
                2 #(let [ts (require :telescope)]
                     ((-> (. ts.extensions :todo-comments)
                          (. :todo))))
                :desc "Find todo tag in the current workspace"
                :mode :n}]
        :opts {:keywords {:NOTE {:icon conf.icons.Note :color "#97CDFB"}
                          :TODO {:icon conf.icons.Todo :color "#B5E8E0"}
                          :PERF {:icon conf.icons.Pref :color "#F8BD96"}
                          :WARN {:icon conf.icons.Warn :color "#FAE3B0"}
                          :HACK {:icon conf.icons.Hack :color "#DDB6F2"}
                          :FIX {:icon conf.icons.Fixme
                                :color "#DDB6F2"
                                :alt {:FIXME :BUG :FIXIT :ISSUE}}}}})
 (pack :nvim-telescope/telescope.nvim
       {:cmd :Telescope
        :init #(do
                 (map :n :<leader>fo
                      (.. ":lua require'telescope.builtin'.find_files({find_command = {"
                          "'rg','--ignore','--hidden','--files','--iglob','!.git','--ignore-vcs','--ignore-file',"
                          "'~/.config/git/gitexcludes'}})<CR>")
                      {:silent true} "Find files in the current workspace")
                 (map :n :<leader>ff "<CMD>Telescope live_grep<CR>"
                      {:silent true} "Find string in the current workspace")
                 (map :n :<leader>fh "<CMD>Telescope oldfiles<CR>"
                      {:silent true} "Find telescope history")
                 (map :n :<leader>f. "<CMD>Telescope resume<CR>" {:silent true}
                      "Find last lookup")
                 (map :n :<leader>fM "<CMD>Telescope marks<CR>" {:silent true}
                      "Find marks in the current workspace")
                 (map :n :<leader>f/
                      "<CMD>Telescope current_buffer_fuzzy_find<CR>"
                      {:silent true} "Find string in current buffer")
                 (map :n "<leader>f:" "<cmd>Telescope command_history<cr>"
                      {:silent true} "Find all command history")
                 (map :n :<leader>fss "<cmd>Telescope vim_options<CR>"
                      {:silent true} :Settings)
                 (map :n :<leader>fH "<cmd>Telescope help_tags<CR>"
                      {:silent true} "Help tags")
                 (map :n :<leader>fsa "<cmd>Telescope autocommands<CR>"
                      {:silent true} :Autocommands)
                 (map :n :<leader>fsf "<cmd>Telescope filetypes<CR>"
                      {:silent true} :Filetypes)
                 (map :n :<leader>fsh "<cmd>Telescope highlights<CR>"
                      {:silent true} :Highlights)
                 (map :n :<leader>fsk "<cmd>Telescope keymaps<CR>"
                      {:silent true} :Keymaps)
                 (map :n :<leader>fsc "<cmd>Telescope colorscheme<CR>"
                      {:silent true} :Colorschemes)
                 (map :n :<leader>fj "<cmd>Telescope jumplist<CR>"
                      {:silent true} "Find jumps")
                 (map :n :<leader>fm "<cmd>Telescope man_pages<CR>"
                      {:silent true} "Find man pages")
                 (map :n :<leader>u "<cmd>Telescope undo<CR>" {:silent true}
                      "Undo History"))
        :config #(let [ts (require :telescope)
                       act (require :telescope.actions)
                       tsu (require :telescope-undo.actions)]
                   (ts.setup {:defaults {:vimgrep_arguments [:rg
                                                             :--color=never
                                                             :--no-heading
                                                             :--with-filename
                                                             :--line-number
                                                             :--column
                                                             :--smart-case
                                                             :--hidden
                                                             :--ignore
                                                             :--iglob
                                                             :!.git
                                                             :--ignore-vcs
                                                             :--ignore-file
                                                             (.. conf.home_dir
                                                                 :/.config/git/gitexcludes)]
                                         :color_devicons true
                                         :file_ignore_patterns [:node_modules]
                                         :layout_strategy :flex
                                         :set_env [:COLORTERM :truecolor]
                                         :layout_config {:flex {:height 0.95
                                                                :width 0.95
                                                                :flip_columns 130
                                                                :prompt_position :bottom
                                                                :horizontal {:width 0.99
                                                                             :height 0.95
                                                                             :preview_width 0.5}
                                                                :vertical {:width 0.99
                                                                           :height 0.99
                                                                           :preview_height 0.7}}}
                                         :mappings {:i {:<c-j> act.move_selection_next
                                                        :<c-k> act.move_selection_previous
                                                        :<c-s> act.select_horizontal
                                                        :<c-v> act.select_vertical
                                                        :<c-t> act.select_tab
                                                        :<c-q> (+ act.smart_send_to_qflist
                                                                  act.open_qflist)
                                                        :<c-i> (+ act.toggle_selection
                                                                  act.move_selection_previous)
                                                        :<esc> act.close}
                                                    :n {:<esc> act.close
                                                        :q act.close
                                                        :a act.close
                                                        :i act.close
                                                        :A act.close
                                                        :I act.close}}}
                              :pickers {:buffers {:show_all_buffers true
                                                  :sort_mru true
                                                  :select_current true
                                                  :theme :dropdown
                                                  :previewer false
                                                  :mappings {:i {:<c-d> (+ act.delete_buffer
                                                                           act.move_to_top)}}}}
                              :extensions {:fzf {:fuzzy true
                                                 :override_generic_sorter true
                                                 :override_file_sorter true
                                                 :case_mode :smart_case}
                                           :undo {:initial_mode :normal
                                                  :mappings {:n {:y tsu.yank_additions
                                                                 :Y tsu.yank_deletions
                                                                 :u tsu.restore
                                                                 :<cr> tsu.restore}}}}})
                   (ts.load_extension :fzf)
                   (ts.load_extension :undo))})]
