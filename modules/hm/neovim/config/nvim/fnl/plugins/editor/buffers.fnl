(local {: map : pack} (require :lib))

(map :n :<C-w>O #(do
                   (vim.cmd :BufOnly)
                   (vim.cmd :LspRestart)) {:noremap true}
     "Wipe all buffers but one")

;; (map :n :<Tab> :<cmd>bnext<cr> {:noremap true} :Tab)
;; (map :n :<S-Tab> :<cmd>bprev<cr> {:noremap true} :S-Tab)

[(pack :famiu/bufdelete.nvim
       {:cmd [:Bdelete :Bwipeout]
        :init #(do
                 ;(map :n :<leader>bd :<CMD>Bdelete<CR> {:noremap true} ;     "Delete Buffer")
                 (map :n :<C-W>d :<CMD>Bdelete<CR> {:silent true}
                      "Close current buffer")
                 (map :n :<C-W><C-D> :<CMD>Bdelete<CR> {:silent true}
                      "Close current buffer"))})
 (pack :axkirillov/hbac.nvim
       {:event :BufReadPost
        :dependencies [:nvim-telescope/telescope.nvim]
        :config #(let [telescope (require :telescope)
                       actions (require :hbac.telescope.actions)
                       hbac (require :hbac)]
                   (hbac.setup {:autoclose false
                                :threshold 10
                                :close_buffers_with_windows false
                                :telescope {:sort_mru true
                                            :sort_lastused false
                                            :theme :dropdown
                                            :previewer false
                                            :use_default_mappings false
                                            :layout_strategy :dropdown
                                            :mappings {:i {:<C-a> actions.pin_all
                                                           :<c-d> actions.delete_buffer
                                                           :<C-o> actions.close_unpinned
                                                           :<C-Space> actions.toggle_pin
                                                           :<C-u> actions.unpin_all}}
                                            :pin_icons {:pinned {1 "󰐃 "
                                                                 :hl :DiagnosticSignOk}
                                                        :unpinned {1 "󰤱 "
                                                                   :hl :DiagnosticSignError}}}})
                   ;;(map :n :<leader>ba "<cmd>Hbac pin_all<cr>" {:noremap true} ;     "Pin all buffers")
                   ;;(map :n :<leader>bb "<cmd>Hbac toggle_pin<cr>" ;     {:noremap true} "Pin Buffer")
                   ;;(map :n :<leader>bo "<cmd>Hbac close_unpinned<cr>" ;     {:noremap true} "Close UnPinned buffers")
                   ;;(map :n :<leader>bu "<cmd>Hbac unpin_all<cr>" ;     {:noremap true} "UnPin all buffers")
                   (telescope.load_extension :hbac)
                   (map :n ";"
                        #(let [themes (require :telescope.themes)
                               theme (themes.get_dropdown {})]
                           (telescope.extensions.hbac.buffers theme))
                        {:silent true} :Buffers))})]
