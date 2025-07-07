(local {: pack : t} (require :lib))
; (local conf (require :conf))

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

;
; (fn under_compare [entry1 entry2]
;   (let [entry1-under (string.find entry1.completion_item.label "^_+")
;         entry2-under (string.find entry2.completion_item.label "^_+")]
;     (< (or entry1-under 0) (or entry2-under 0))))
;
; (local duplicate_keywords {:snippy 0
;                            :nvim_lsp 1
;                            :conjure 0
;                            :buffer 0
;                            :path 0
;                            :cmdline 0})
;
; (pack :hrsh7th/nvim-cmp
;       {:dependencies [{1 :hrsh7th/cmp-nvim-lsp
;                        :config false
;                        :event :InsertEnter}
;                       {1 :hrsh7th/cmp-buffer :config false :event :InsertEnter}
;                       {1 :hrsh7th/cmp-path :config false :event :InsertEnter}
;                       {1 :hrsh7th/cmp-cmdline
;                        :config false
;                        :event :CmdlineEnter}
;                       {1 :hrsh7th/cmp-calc :config false :event :InsertEnter}
;                       ;:dcampos/cmp-snippy
;                       :PaterJason/cmp-conjure
;                       {1 "https://gitlab.com/msvechla/cmp-jira.git"
;                        :event :InsertEnter
;                        :opts {:file_types [:gitcommit :markdown]}}]
;        :event [:InsertEnter :CmdlineEnter]
;        :config #(let [cmp (require :cmp)
;                       types (require :cmp.types)
;                       gen_mapping {:<c-space> (cmp.mapping #(if (cmp.visible)
;                                                                 (do
;                                                                   (cmp.abort)
;                                                                   (when vim.g.copilot_loaded
;                                                                     (vim.fn.copilot#Suggest)))
;                                                                 (cmp.complete))
;                                                            [:i :s :c])
;                                    :<cr> (cmp.mapping (cmp.mapping.confirm)
;                                                       [:i :s :c])
; :<c-l> (cmp.mapping #(if (cmp.visible)
;                          (cmp.confirm)
;                          (when vim.g.copilot_loaded
;                            (vim.api.nvim_feedkeys (vim.fn.copilot#Accept (vim.api.nvim_replace_termcodes :<C-l>
;                                                                                                          true
;                                                                                                          true
;                                                                                                          true))
;                                                   :n
;                                                   true)))
;                     [:i :s :c])
;                                    :<c-j> (cmp.mapping #(if (cmp.visible)
;                                                             (cmp.select_next_item {:behavior cmp.SelectBehavior.Insert})
; (when vim.g.copilot_loaded
;   (vim.fn.copilot#Next)))
;                                                        [:i :s])
;                                    :<c-k> (cmp.mapping #(if (cmp.visible)
;                                                             (cmp.select_prev_item {:behavior cmp.SelectBehavior.Insert})
; (when vim.g.copilot_loaded
;   (vim.fn.copilot#Previous)))
;                                                        [:i :s])
;                                    :<c-b> (cmp.mapping (cmp.mapping.scroll_docs -4)
;                                                        [:i :s])
;                                    :<c-f> (cmp.mapping (cmp.mapping.scroll_docs 4)
;                                                        [:i :s])
;                                    :<c-u> (cmp.mapping #(if (cmp.visible)
;                                                             (for [_ 1 5]
;                                                               (cmp.select_prev_item {:behavior cmp.SelectBehavior.Insert}))
;                                                             ($1))
;                                                        [:i :s :c])
;                                    :<c-d> (cmp.mapping #(if (cmp.visible)
;                                                             (for [_ 1 5]
;                                                               (cmp.select_next_item {:behavior cmp.SelectBehavior.Insert}))
;                                                             ($1))
;                                                        [:i :s :c])
;                                    :<c-h> (cmp.mapping #(if (cmp.visible)
;                                                             (cmp.abort)
;                                                             ;$1
;                                                             (when vim.g.copilot_loaded
;                                                               (vim.fn.copilot#Dismiss)))
;                                                        [:i :s :c])}
;                       c_mapping {:<Tab> (cmp.mapping #(if (cmp.visible)
;                                                           (cmp.select_next_item {:behavior cmp.SelectBehavior.Insert})
;                                                           (vim.api.nvim_feedkeys (t :<Down>)
;                                                                                  :n
;                                                                                  true))
;                                                      [:c])
;                                  :<S-Tab> (cmp.mapping #(if (cmp.visible)
;                                                             (cmp.select_prev_item {:behavior cmp.SelectBehavior.Insert})
;                                                             (vim.api.nvim_feedkeys (t :<Up>)
;                                                                                    :n
;                                                                                    true))
;                                                        [:c])
;                                  :<c-j> (cmp.mapping #(if (cmp.visible)
;                                                           (cmp.select_next_item {:behavior cmp.SelectBehavior.Insert})
;                                                           (vim.api.nvim_feedkeys (t :<Down>)
;                                                                                  :n
;                                                                                  true))
;                                                      [:c])
;                                  :<c-k> (cmp.mapping #(if (cmp.visible)
;                                                           (cmp.select_prev_item {:behavior cmp.SelectBehavior.Insert})
;                                                           (vim.api.nvim_feedkeys (t :<Up>)
;                                                                                  :n
;                                                                                  true))
;                                                      [:c])}
;                       opts {;;:experimental {:ghost_text true}
;                             :preselect types.cmp.PreselectMode.None
;                             :confirmation {:default_behavior cmp.ConfirmBehavior.Insert}
;                             :snippet {:expand (fn [args]
;                                                 (let [snippy (require :snippy)]
;                                                   (snippy.expand_snippet args.body)))}
;                             :sources [{:name :cmp_jira}
;                                       {:name :codecompanion}
;                                       {:name :calc}
;                                       {:name :nvim_lsp}
;                                       {:name :conjure}
;                                       {:name :snippy}
;                                       {:name :path}
;                                       {:name :buffer}]
;                             :mapping gen_mapping
;                             :sorting {:priority_weight 2
;                                       :comparators [cmp.config.compare.offset
;                                                     cmp.config.compare.exact
;                                                     cmp.config.compare.score
;                                                     under_compare
;                                                     cmp.config.compare.kind
;                                                     cmp.config.compare.sort_text
;                                                     cmp.config.compare.length
;                                                     cmp.config.compare.order]}
;                             :window {:completion (cmp.config.window.bordered {:winhighlight "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None"})
;                                      :documentation (cmp.config.window.bordered {:winhighlight "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None"})}
;                             :kind_icons conf.icons.lsp_kind
;                             :formatting {:format (fn [entry vim_item]
;                                                    (let [max_width 80]
;                                                      (if (and (not= max_width 0)
;                                                               (> (length vim_item.abbr)
;                                                                  max_width))
;                                                          (set vim_item.abbr
;                                                               (.. (string.sub vim_item.abbr
;                                                                               1
;                                                                               (- max_width
;                                                                                  1))
;                                                                   "…")))
;                                                      (set vim_item.kind
;                                                           (string.format "%s %s"
;                                                                          (. conf.icons.lsp_kind
;                                                                             vim_item.kind)
;                                                                          vim_item.kind))
;                                                      (set vim_item.menu
;                                                           (string.format "%s"
;                                                                          (. conf.icons.source
;                                                                             entry.source.name)))
;                                                      (set vim_item.dup
;                                                           (or (. duplicate_keywords
;                                                                  entry.source.name)
;                                                               0))
;                                                      vim_item))}}]
;                   (cmp.setup opts)
;                   (cmp.setup.cmdline "/"
;                                      {:mapping c_mapping
;                                       :sources [{:name :buffer}]})
;                   (cmp.setup.cmdline "?"
;                                      {:mapping c_mapping
;                                       :sources [{:name :buffer}]})
;                   (cmp.setup.cmdline ":"
;                                      {:mapping c_mapping
;                                       :sources (cmp.config.sources [{:name :path}
;                                                                     {:name :cmdline}])}))})

(pack :saghen/blink.cmp {:dependencies [:rafamadriz/friendly-snippets
                                        :PaterJason/cmp-conjure
                                        {1 "https://gitlab.com/msvechla/cmp-jira.git"
                                         :opts {:file_types [:gitcommit
                                                             :markdown]}}
                                        :hrsh7th/cmp-calc
                                        (pack :saghen/blink.compat
                                              {:version :2.* :opts {}})]
                         :version :1.*
                         :opts {:keymap {:preset :none
                                         :<C-space> [:show
                                                     :hide
                                                     #((when vim.g.copilot_loaded
                                                         (vim.fn.copilot#Suggest)))]
                                         :<C-h> [:cancel
                                                 #(when vim.g.copilot_loaded
                                                    (vim.fn.copilot#Dismiss))]
                                         ; :<ESC> [:hide :fallback]
                                         :<CR> [:accept :fallback]
                                         :<C-l> [:select_and_accept
                                                 #(when vim.g.copilot_loaded
                                                    (vim.api.nvim_feedkeys (vim.fn.copilot#Accept (vim.api.nvim_replace_termcodes :<C-l>
                                                                                                                                  true
                                                                                                                                  true
                                                                                                                                  true))
                                                                           :n
                                                                           true))]
                                         :<Up> [:select_prev :fallback]
                                         :<Down> [:select_next :fallback]
                                         :<C-k> [:select_prev
                                                 #(when vim.g.copilot_loaded
                                                    (vim.fn.copilot#Previous))]
                                         :<C-j> [:select_next
                                                 #(when vim.g.copilot_loaded
                                                    (vim.fn.copilot#Next))]
                                         :<C-b> [:scroll_documentation_up
                                                 :fallback]
                                         :<C-f> [:scroll_documentation_down
                                                 :fallback]
                                         :<Tab> [:snippet_forward :fallback]
                                         :<S-Tab> [:snippet_backward :fallback]
                                         ; :<C-e> [:show_signature :hide_signature :fallback]
                                         }
                                :appearance {:nerd_font_variant :mono}
                                :completion {:menu {:border :single
                                                    :auto_show true}
                                             :list {:selection {:preselect false
                                                                :auto_insert true}}
                                             :documentation {:auto_show true
                                                             :auto_show_delay_ms 100
                                                             :window {:border :single}}
                                             :ghost_text {:enabled false}
                                             :trigger {:show_on_keyboard true}}
                                :sources {:default [:calc
                                                    :cmp_jira
                                                    :conjure
                                                    :lsp
                                                    :path
                                                    :snippets
                                                    :buffer
                                                    :codecompanion]
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
                                                                               (vim.fn.getcwd))}}}
                                          :priority [:lsp :conjure]}
                                :signature {:window {:border :singe}
                                            :enabled false
                                            :show_on_insert true}
                                :fuzzy {:sorts [:exact :score :sort_text]}
                                :cmdline {:keymap {:preset :none
                                                   :<Tab> [:show_and_insert
                                                           :select_next]
                                                   :<S-Tab> [:show_and_insert
                                                             :select_prev]
                                                   :<C-space> [:show :fallback]
                                                   :<C-n> [:select_next
                                                           :fallback]
                                                   :<C-p> [:select_prev
                                                           :fallback]
                                                   :<C-j> [:select_next
                                                           :fallback]
                                                   :<C-k> [:select_prev
                                                           :fallback]
                                                   :<Right> [:select_next
                                                             :fallback]
                                                   :<Left> [:select_prev
                                                            :fallback]
                                                   :<C-y> [:select_and_accept]
                                                   :<C-l> [:select_and_accept]
                                                   :<CR> [:accept_and_enter
                                                          :fallback]
                                                   :<C-e> [:cancel]
                                                   :<C-h> [:cancel :fallback]}
                                          :completion {:list {:selection {:preselect false
                                                                          :auto_insert true}}
                                                       :menu {:auto_show true}}}}
                         :opts_extend [:sources.default]
                         :config (fn [_ opts]
                                   (let [bl (require :blink.cmp.completion.list)
                                         original bl.show
                                         b (require :blink.cmp)]
                                     (set bl.show
                                          (fn [ctx items_by_source]
                                            (original ctx
                                                      (dedupe-toplevel items_by_source))))
                                     (b.setup opts)))})
