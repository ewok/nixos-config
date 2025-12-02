(local {: pack : is_loaded} (require :lib))
(local conf (require :conf))

[(pack :nvim-lualine/lualine.nvim
       {:event :VeryLazy
        :config #(let [ll (require :lualine)
                       opts {:extensions [:aerial]
                             :options {:theme :auto
                                       :icons_enabled true
                                       :component_separators {:left conf.separator.alt_left
                                                              :right conf.separator.alt_right}
                                       :section_separators {:left conf.separator.left
                                                            :right conf.separator.right}
                                       :disabled_filetypes {}
                                       :globalstatus true}
                             :sections {:lualine_a [:mode]
                                        :lualine_b [:branch :diff :diagnostics]
                                        :lualine_c [{1 :filename :path 1}]
                                        :lualine_x [{1 #(let [(isSet venv) (pcall require
                                                                                  :venv-selector)]
                                                          (if isSet
                                                              (if (venv.venv)
                                                                  :venv
                                                                  "")
                                                              ""))
                                                     :cond #(is_loaded :venv-selector)}
                                                    :encoding
                                                    :fileformat
                                                    :filetype]
                                        :lualine_y [:progress]
                                        :lualine_z [:location]}
                             :winbar {:lualine_c [{1 #(let [cur_buf (vim.api.nvim_get_current_buf)
                                                            (isSet is_pinned) (pcall #((-> (require :hbac.state)
                                                                                           (. :is_pinned)) cur_buf))]
                                                        (if (and isSet
                                                                 is_pinned)
                                                            "%#DiagnosticSignOk#󰐃"
                                                            "%#DiagnosticSignError#󰤱"))
                                                   :cond #(is_loaded :hbac)}
                                                  {1 :filename :path 4}
                                                  {1 #"%{%v:lua.require'nvim-navic'.get_location()%}"
                                                   :cond #(is_loaded :nvim-navic)}]}
                             :inactive_winbar {:lualine_c [{1 #(let [cur_buf (vim.api.nvim_get_current_buf)
                                                                     (isSet is_pinned) (pcall #((-> (require :hbac.state)
                                                                                                    (. :is_pinned)) cur_buf))]
                                                                 (if (and isSet
                                                                          is_pinned)
                                                                     "%#DiagnosticSignOk#󰐃"
                                                                     "%#DiagnosticSignError#󰤱"))
                                                            :cond #(is_loaded :hbac)}
                                                           {1 :filename
                                                            :path 4}]}
                             :tabline {:lualine_a [;{1 :buffers
                                                   ; :use_mode_colors true}
                                                   :tabs]
                                       :lualine_b []
                                       :lualine_c []
                                       :lualine_x []
                                       :lualine_z [{1 #(let [cwd (string.gsub (vim.fn.getcwd)
                                                                              (os.getenv :HOME)
                                                                              "~")]
                                                         cwd)}]
                                       :lualine_y [{1 #(.. "buffers: "
                                                           (length (vim.api.nvim_list_bufs)))}]}}]
                   (ll.setup opts))})]
