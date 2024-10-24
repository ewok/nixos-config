(local {: pack : map} (require :lib))
(local conf (require :conf))

(pack :stevearc/aerial.nvim
      {:cmd [:AerialToggle]
       :init #(map :n :<C-P> "<cmd>AerialToggle float<cr>" {:silent true}
                   "Open Outline Explorer")
       :config #(let [aerial (require :aerial)]
                  (aerial.setup {:icons conf.icons
                                 :keymaps {:q :actions.close
                                           :<esc> :actions.close}
                                 :layout {:min_width 120}
                                 :show_guides true
                                 :backends [:lsp :treesitter :markdown :man]
                                 :update_events "TextChanged,InsertLeave"
                                 ; :on_attach = on_attach,
                                 :lsp {:diagnostics_trigger_update false
                                       :update_when_errors true
                                       :update_delay 300}
                                 :guides {:mid_item "├─"
                                          :last_item "└─"
                                          :nested_top "│ "
                                          :whitespace "  "}
                                 :filter_kind [:Module
                                               :Struct
                                               :Interface
                                               :Class
                                               :Constructor
                                               :Enum
                                               :Function
                                               :Method]}))})
