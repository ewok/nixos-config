(local {: pack : t} (require :lib))
(local conf (require :conf))

(fn under_compare [entry1 entry2]
  (let [entry1-under (string.find entry1.completion_item.label "^_+")
        entry2-under (string.find entry2.completion_item.label "^_+")]
    (< (or entry1-under 0) (or entry2-under 0))))

(local duplicate_keywords {:snippy 1 :nvim_lsp 1 :buffer 0 :path 0 :cmdline 0})

(pack :hrsh7th/nvim-cmp
      {:dependencies [{1 :hrsh7th/cmp-nvim-lsp
                       :config false
                       :event :InsertEnter}
                      {1 :hrsh7th/cmp-buffer :config false :event :InsertEnter}
                      {1 :hrsh7th/cmp-path :config false :event :InsertEnter}
                      {1 :hrsh7th/cmp-cmdline
                       :config false
                       :event :CmdlineEnter}
                      {1 :hrsh7th/cmp-calc :config false :event :InsertEnter}
                      :dcampos/cmp-snippy]
       :event [:InsertEnter :CmdlineEnter]
       :config #(let [cmp (require :cmp)
                      types (require :cmp.types)
                      gen_mapping {:<c-space> (cmp.mapping #(if (cmp.visible)
                                                                (cmp.abort)
                                                                (cmp.complete))
                                                           [:i :s :c])
                                   :<cr> (cmp.mapping (cmp.mapping.confirm)
                                                      [:i :s :c])
                                   :<c-l> (cmp.mapping #(if (cmp.visible)
                                                            (cmp.confirm)
                                                            ($1))
                                                       [:i :s :c])
                                   :<Tab> (cmp.mapping #(if (cmp.visible)
                                                            (cmp.select_next_item {:behavior cmp.SelectBehavior.Insert})
                                                            ($1))
                                                       [:i :s])
                                   :<S-Tab> (cmp.mapping #(if (cmp.visible)
                                                              (cmp.select_prev_item {:behavior cmp.SelectBehavior.Insert})
                                                              ($1))
                                                         [:i :s])
                                   :<c-j> (cmp.mapping #(cmp.select_next_item {:behavior cmp.SelectBehavior.Insert})
                                                       [:i :s])
                                   :<c-k> (cmp.mapping #(cmp.select_prev_item {:behavior cmp.SelectBehavior.Insert})
                                                       [:i :s])
                                   :<c-b> (cmp.mapping (cmp.mapping.scroll_docs -4)
                                                       [:i :s])
                                   :<c-f> (cmp.mapping (cmp.mapping.scroll_docs 4)
                                                       [:i :s])
                                   :<c-u> (cmp.mapping #(if (cmp.visible)
                                                            (for [_ 1 5]
                                                              (cmp.select_prev_item {:behavior cmp.SelectBehavior.Insert}))
                                                            ($1))
                                                       [:i :s :c])
                                   :<c-d> (cmp.mapping #(if (cmp.visible)
                                                            (for [_ 1 5]
                                                              (cmp.select_next_item {:behavior cmp.SelectBehavior.Insert}))
                                                            ($1))
                                                       [:i :s :c])
                                   :<c-h> (cmp.mapping #(if (cmp.visible)
                                                            (cmp.abort)
                                                            $1)
                                                       [:i :s :c])}
                      c_mapping {:<Tab> (cmp.mapping #(if (cmp.visible)
                                                          (cmp.select_next_item {:behavior cmp.SelectBehavior.Insert})
                                                          (vim.api.nvim_feedkeys (t :<Down>)
                                                                                 :n
                                                                                 true))
                                                     [:c])
                                 :<S-Tab> (cmp.mapping #(if (cmp.visible)
                                                            (cmp.select_prev_item {:behavior cmp.SelectBehavior.Insert})
                                                            (vim.api.nvim_feedkeys (t :<Up>)
                                                                                   :n
                                                                                   true))
                                                       [:c])
                                 :<c-j> (cmp.mapping #(if (cmp.visible)
                                                          (cmp.select_next_item {:behavior cmp.SelectBehavior.Insert})
                                                          (vim.api.nvim_feedkeys (t :<Down>)
                                                                                 :n
                                                                                 true))
                                                     [:c])
                                 :<c-k> (cmp.mapping #(if (cmp.visible)
                                                          (cmp.select_prev_item {:behavior cmp.SelectBehavior.Insert})
                                                          (vim.api.nvim_feedkeys (t :<Up>)
                                                                                 :n
                                                                                 true))
                                                     [:c])}
                      opts {:preselect types.cmp.PreselectMode.None
                            :confirmation {:default_behavior cmp.ConfirmBehavior.Insert}
                            :snippet {:expand (fn [args]
                                                (let [snippy (require :snippy)]
                                                  (snippy.expand_snippet args.body)))}
                            :sources [{:name :codeium}
                                      {:name :calc}
                                      {:name :snippy}
                                      {:name :nvim_lsp}
                                      {:name :path}
                                      {:name :buffer}]
                            :mapping gen_mapping
                            :sorting {:priority_weight 2
                                      :comparators [cmp.config.compare.offset
                                                    cmp.config.compare.exact
                                                    cmp.config.compare.score
                                                    under_compare
                                                    cmp.config.compare.kind
                                                    cmp.config.compare.sort_text
                                                    cmp.config.compare.length
                                                    cmp.config.compare.order]}
                            :window {:completion (cmp.config.window.bordered {:winhighlight "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None"})
                                     :documentation (cmp.config.window.bordered {:winhighlight "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None"})}
                            :kind_icons conf.icons.lsp_kind
                            :formatting {:format (fn [entry vim_item]
                                                   (let [max_width 40]
                                                     (if (and (not= max_width 0)
                                                              (> (length vim_item.abbr)
                                                                 max_width))
                                                         (set vim_item.abbr
                                                              (.. (string.sub vim_item.abbr
                                                                              1
                                                                              (- max_width
                                                                                 1))
                                                                  "…")))
                                                     (set vim_item.kind
                                                          (string.format "%s %s"
                                                                         (. conf.icons.lsp_kind
                                                                            vim_item.kind)
                                                                         vim_item.kind))
                                                     (set vim_item.menu
                                                          (string.format "%s"
                                                                         (. conf.icons.source
                                                                            entry.source.name)))
                                                     (set vim_item.dup
                                                          (or (. duplicate_keywords
                                                                 entry.source.name)
                                                              0))
                                                     vim_item))}}]
                  (cmp.setup opts)
                  (cmp.setup.cmdline "/"
                                     {:mapping c_mapping
                                      :sources [{:name :buffer}]})
                  (cmp.setup.cmdline "?"
                                     {:mapping c_mapping
                                      :sources [{:name :buffer}]})
                  (cmp.setup.cmdline ":"
                                     {:mapping c_mapping
                                      :sources (cmp.config.sources [{:name :path}
                                                                    {:name :cmdline}])}))})
