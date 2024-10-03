(local {: pack : map!} (require :lib))

[;(pack :epwalsh/obsidian.nvim
 ;      {:version "*"
 ;       :init #(let [md {:noremap true :silent false}]
 ;                (map! :n :<leader>wo :<cmd>ObsidianQuickSwitch<cr> md
 ;                      "Open note")
 ;                (map! :n :<leader>wt :<cmd>ObsidianTags<cr> md "Open tag")
 ;                (map! :n :<leader>wf :<cmd>ObsidianSearch<cr> md
 ;                      "Find in notes"))
 ;       :cmd [:ObsidianQuickSwitch :ObsidianTags :ObsidianSearch]
 ;       :ft :markdown
 ;       :event [(.. "BufReadPre " conf.notes_dir :/**.md)
 ;               (.. "BufNewFile " conf.notes_dir :/**.md)]
 ;       :opts {:workspaces [{:name :notes :path "~/Notes"}]
 ;              :daily_notes {:folder :calendar/daily
 ;                            :date_format "%Y-%m-%d"
 ;                            :alias_format "%B %-d, %Y"
 ;                            :default_tags [:dailyNote]
 ;                            :template nil}
 ;              :wiki_link_func :use_alias_only
 ;              :disable_frontmatter true
 ;              :note_id_func #(.. $1)
 ;              :ui {:checkboxes {" " {:char "" :hl_group :ObsidianTodo}
 ;                                :x {:char "󰄳" :hl_group :ObsidianDone}
 ;                                :/ {:char "󱎖" :hl_group :ObsidianImportant}
 ;                                :- {:char " " :hl_group :ObsidianDone}
 ;                                :> {:char "" :hl_group :ObsidianRightArrow}
 ;                                :< {:char "" :hl_group :ObsidianRightArrow}
 ;                                :? {:char "" :hl_group :ObsidianTodo}
 ;                                :! {:char "" :hl_group :ObsidianTodo}
 ;                                :* {:char "" :hl_group :ObsidianTodo}
 ;                                "\"" {:char "" :hl_group :ObsidianTodo}
 ;                                :l {:char "" :hl_group :ObsidianTodo}
 ;                                :b {:char "" :hl_group :ObsidianTodo}
 ;                                :i {:char "󰋼" :hl_group :ObsidianTodo}
 ;                                :S {:char "" :hl_group :ObsidianTodo}
 ;                                :i {:char "󱩎" :hl_group :ObsidianTodo}
 ;                                :p {:char "󰔓" :hl_group :ObsidianTodo}
 ;                                :c {:char "󰔑" :hl_group :ObsidianTodo}
 ;                                :f {:char "" :hl_group :ObsidianTodo}
 ;                                :k {:char "" :hl_group :ObsidianTodo}
 ;                                :w {:char "" :hl_group :ObsidianTodo}
 ;                                :u {:char "󰔵" :hl_group :ObsidianTodo}
 ;                                :d {:char "󰔳" :hl_group :ObsidianTodo}}}}})
 (pack :gpanders/vim-medieval
       {:ft [:markdown]
        :config #(set vim.g.medieval_langs
                      [:python :ruby :sh :console=bash :bash :perl :fish :bb])})
 (pack :mickael-menu/zk-nvim
       {:cmd [:ZkNew
              :ZkIndex
              :ZkNotes
              :ZkTags
              :ZkMatch
              :ZkBacklinks
              :ZkNewFromTitleSelection
              :ZkLinks]
        :init #(let [md {:noremap true :silent false}]
                 (map! :n :<leader>wn
                       "<cmd>ZkNew { title = vim.fn.input('Title: '), dir = 'notes' }<cr>"
                       md "New note")
                 (map! :n :<leader>wi :<cmd>ZkIndex<cr> md "Reindex notes")
                 (map! :n :<leader>wo
                       "<cmd>ZkNotes { sort = { 'modified' }, select = { 'absPath', 'path' } }<cr>"
                       md "Open note")
                 (map! :n :<leader>wt :<cmd>ZkTags<cr> md "Open tag")
                 (map! :n :<leader>wf
                       "<cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') }, select = { 'absPath', 'path' } }<cr>"
                       md "Find in notes")
                 (map! :v :<leader>wf ":'<,'>ZkMatch<cr>" md "Find in notes"))
        :config #(let [zk (require :zk)
                       telescope (require :telescope)]
                   (zk.setup {:picker :telescope})
                   (telescope.load_extension :zk))})
 (pack :jakewvincent/mkdnflow.nvim
       {:ft [:markdown]
        :opts {:modules {:bib false
                         :buffers true
                         :conceal false
                         :cursor true
                         :folds false
                         :links true
                         :lists true
                         :maps true
                         :paths true
                         :tables true
                         :yaml false}
               :filetypes {:md true :rmd true :markdown true}
               :create_dirs true
               :perspective {:priority :first
                             :fallback :current
                             :root_tell false
                             :nvim_wd_heel true}
               :wrap false
               :silent false
               :links {:style :markdown
                       :name_is_source false
                       :conceal true
                       :context 1
                       :implicit_extension nil
                       :transform_implicit false
                       :transform_explicit (fn [text]
                                             (-> text
                                                 (string.gsub " " "-")
                                                 (string.lower) ; (.. ;   ;;(str (time.now)) ;        "_")
                                                 ))}
               :to_do {:symbols [" " "+" :x "-"]
                       :update_parents true
                       :not_started " "
                       :in_progress "+"
                       :complete :x}
               :tables {:trim_whitespace true
                        :format_on_move true
                        :auto_extend_rows false
                        :auto_extend_cols false}
               :mappings {:MkdnEnter [[:n :v] :<M-CR>]
                          :MkdnTab false
                          :MkdnSTab false
                          :MkdnNextLink [:n "]l"]
                          :MkdnPrevLink [:n "[l"]
                          :MkdnNextHeading [:n "]]"]
                          :MkdnPrevHeading [:n "[["]
                          :MkdnGoBack [:n :<BS>]
                          :MkdnGoForward [:n :<Del>]
                          :MkdnFollowLink false
                          :MkdnMoveSource [:n :<leader>wr]
                          :MkdnYankAnchorLink [:n :yfa]
                          :MkdnYankFileAnchorLink [:n :yfA]
                          :MkdnIncreaseHeading [:n "="]
                          :MkdnDecreaseHeading [:n "-"]
                          :MkdnToggleToDo [[:n :v] :<C-Space>]
                          :MkdnNewListItem [:i :<CR>]
                          :MkdnNewListItemBelowInsert [:n :o]
                          :MkdnNewListItemAboveInsert [:n :O]
                          :MkdnExtendList false
                          :MkdnUpdateNumbering [:n :<leader>wN]
                          :MkdnTableFormat [:n :<leader>wTf]
                          :MkdnTableNewColAfter [:n :<leader>wTa]
                          :MkdnTableNewColBefore [:n :<leader>wTi]
                          :MkdnTableNewRowAbove [:n :<leader>wTO]
                          :MkdnTableNewRowBelow [:n :<leader>wTo]
                          :MkdnTableNextCell [:i :<Tab>]
                          :MkdnTableNextRow [:i :<C-Down>]
                          :MkdnTablePrevCell [:i :<S-Tab>]
                          :MkdnTablePrevRow [:i :<C-Up>]
                          :MkdnFoldSection [:n :zf]
                          :MkdnUnfoldSection [:n :zF]}}})]
