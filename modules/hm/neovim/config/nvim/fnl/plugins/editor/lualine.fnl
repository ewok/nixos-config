(local {: pack : is_loaded : get_buf_ft} (require :lib))
(local conf (require :conf))

[
 ;(pack :freddiehaddad/feline.nvim
 ;      {:events :VeryLazy
 ;       :config #(let [feline (require :feline)
 ;                      vi-mode (require :feline.providers.vi_mode)]
 ;                  (feline.setup {:components {:active [[{:provider #(string.format "%s"
 ;                                                                                   (vi-mode.get_vim_mode))
 ;                                                         :hl #(:fg (vi-mode.get_mode_color)
 ;                                                                   :bg :none)
 ;                                                         :right_sep {:always_visible true
 ;                                                                     :str (string.format "%s"
 ;                                                                                         "  ")
 ;                                                                     :hl {:fg :none
 ;                                                                          :bg :none}}}]]}})
 ;                  (feline.winbar.setup {})
 ;                  (feline.statuscolumn.setup {}))})
 ;(pack :rebelot/heirline.nvim
 ;      {:event :VeryLazy
 ;       :dependencies [:Zeioth/heirline-components.nvim]
 ;       :config #(let [heirline (require :heirline)
 ;                      components (require :heirline-components.all)
 ;                      utils (require :heirline.utils)]
 ;                  (components.init.subscribe_to_events)
 ;                  (heirline.load_colors (components.hl.get_colors))
 ;                  (heirline.setup {:tabline [(components.component.tabline_buffers)
 ;                                             (utils.surround [conf.separator.left
 ;                                                              conf.separator_right]
 ;                                                             ""
 ;                                                             (components.component.tabline_tabpages))]
 ;                                   :statusline [(components.component.tabline_conditional_padding)]
 ;                                   :winbar [(components.component.tabline_conditional_padding)]
 ;                                   :statuscolumn [(components.component.tabline_conditional_padding)]}))})
 (pack :nvim-lualine/lualine.nvim
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
                                                  {1 :filename
                                                   :path 4
                                                   ;:cond #(not= :oil
                                                   ;             (get_buf_ft 0))
                                                   }
                                                  ;{1 #" oil://%{v:lua.string.gsub(v:lua.require('oil').get_current_dir(), v:lua.os.getenv('HOME'), '~')}"
                                                  ; :cond #(= :oil
                                                  ;           (get_buf_ft 0))}
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
                                                            :path 4
                                                            ;:cond #(not= :oil
                                                            ;             (get_buf_ft 0))
                                                            }
                                                           ;{1 #" oil://%{v:lua.string.gsub(v:lua.require('oil').get_current_dir(), v:lua.os.getenv('HOME'), '~')}"
                                                           ; :cond #(= :oil
                                                           ;           (get_buf_ft 0))}
                                                            ]}
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
                   (ll.setup opts))}
        )
 ]
