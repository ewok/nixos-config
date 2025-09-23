(local {: pack} (require :lib))

(local unique-by-label (fn [items]
                         (let [seen {}
                               result []]
                           (each [_ item (ipairs items)]
                             (when (and (= (type item) :table) (. item :label)
                                        (not (. seen (. item :label))))
                               (tset seen (. item :label) true)
                               (table.insert result item)))
                           result)))

(local dedupe-toplevel (fn [tbl]
                         (each [k v (pairs tbl)]
                           (when (and (= (type v) :table) (. v 1)
                                      (= (type (. v 1)) :table)
                                      (. (. v 1) :label))
                             (tset tbl k (unique-by-label v))))
                         tbl))

(pack :saghen/blink.cmp
      {:dependencies [:rafamadriz/friendly-snippets
                      :PaterJason/cmp-conjure
                      "https://gitlab.com/msvechla/cmp-jira.git"
                      :hrsh7th/cmp-calc
                      (pack :saghen/blink.compat {:version :2.* :opts {}})]
       :opts {:keymap {:preset :none
                       :<C-space> [:show
                                   :hide
                                   #((when vim.g.copilot_loaded
                                       (vim.fn.copilot#Suggest)))]
                       :<C-h> [:cancel
                               #(when vim.g.copilot_loaded
                                  (vim.fn.copilot#Dismiss))]
                       :<CR> [:accept :fallback]
                       :<C-l> [:select_and_accept
                               #(when vim.g.copilot_loaded
                                  (vim.api.nvim_feedkeys (vim.fn.copilot#Accept (vim.api.nvim_replace_termcodes :<C-l>
                                                                                                                true
                                                                                                                true
                                                                                                                true))
                                                         :n true))]
                       :<Up> [:select_prev :fallback]
                       :<Down> [:select_next :fallback]
                       :<C-k> [:select_prev
                               #(when vim.g.copilot_loaded
                                  (vim.fn.copilot#Previous))]
                       :<C-j> [:select_next
                               #(when vim.g.copilot_loaded
                                  (vim.fn.copilot#Next))]
                       :<C-b> [:scroll_documentation_up :fallback]
                       :<C-f> [:scroll_documentation_down :fallback]
                       :<Tab> [:snippet_forward :fallback]
                       :<S-Tab> [:snippet_backward :fallback]
                       ; :<C-e> [:show_signature :hide_signature :fallback]
                       }
              :appearance {:nerd_font_variant :mono}
              :completion {:menu {:border :single :auto_show true}
                           :list {:selection {:preselect false
                                              :auto_insert true}}
                           :documentation {:auto_show true
                                           :auto_show_delay_ms 100
                                           :window {:border :single}}
                           :ghost_text {:enabled false}}
              :sources {:default [:calc
                                  :cmp_jira
                                  :conjure
                                  :lsp
                                  :path
                                  :snippets
                                  :buffer
                                  :codecompanion
                                  :obsidian
                                  :obsidian_new
                                  :obsidian_tags]
                        :providers {:conjure {:name :conjure
                                              :module :blink.compat.source
                                              :score_offset -3
                                              :opts {}}
                                    :cmp_jira {:name :cmp_jira
                                               :module :blink.compat.source
                                               :score_offset -3
                                               :opts {}}
                                    :calc {:name :calc
                                           :module :blink.compat.source
                                           :score_offset -3
                                           :opts {}}
                                    :path {:opts {:get_cwd (fn [_]
                                                             (vim.fn.getcwd))}}
                                    :obsidian {:name :obsidian
                                               :module :blink.compat.source}
                                    :obsidian_new {:name :obsidian_new
                                                   :module :blink.compat.source}
                                    :obsidian_tags {:name :obsidian_tags
                                                    :module :blink.compat.source}}}
              :signature {:window {:border :singe} :enabled true}
              :fuzzy {:sorts [:exact :score :sort_text]}
              :cmdline {:keymap {:preset :none
                                 :<Tab> [:show_and_insert :select_next]
                                 :<S-Tab> [:show_and_insert :select_prev]
                                 :<C-space> [:show :fallback]
                                 :<C-n> [:select_next :fallback]
                                 :<C-p> [:select_prev :fallback]
                                 :<C-j> [:select_next :fallback]
                                 :<C-k> [:select_prev :fallback]
                                 :<Right> [:select_next :fallback]
                                 :<Left> [:select_prev :fallback]
                                 :<C-y> [:select_and_accept]
                                 :<C-l> [:select_and_accept]
                                 :<CR> [:accept_and_enter :fallback]
                                 :<C-e> [:cancel]
                                 :<C-h> [:cancel :fallback]}
                        :completion {:list {:selection {:preselect false
                                                        :auto_insert true}}
                                     :menu {:auto_show true}}}}
       :version :1.*
       :opts_extend [:sources.default]
       :config (fn [_ opts]
                 (let [b (require :blink.cmp)]
                   (b.setup opts)
                   (let [bl (require :blink.cmp.completion.list)
                         original bl.show]
                     (set bl.show
                          (fn [ctx items_by_source]
                            (original ctx (dedupe-toplevel items_by_source)))))))})
