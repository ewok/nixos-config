(local {: pack} (require :lib))
(local conf (require :conf))

(local ts_hint "
Spell Langs
  ^
  ^^^^^_s_ %{spell} spell
  ^^^^^_e_ %{en_us} en
  ^^^^^_r_ %{ru_ru} ru
  ^^^^^_q_ quit")

(pack :nvimtools/hydra.nvim {:config true
                             :keys [{1 :<leader>j
                                     2 #(let [hy (require :hydra)
                                              lualine (require :lualine)
                                              l_refresh #(lualine.refresh {:scope :tabpage
                                                                           :place [:tabline
                                                                                   :statusline
                                                                                   :winbar]})]
                                          (-> (hy {:name "Switch buffers"
                                                   :config {:hint false
                                                            :timeout 300
                                                            :on_enter #(do
                                                                         (vim.cmd "silent! bnext")
                                                                         (l_refresh))
                                                            :on_key l_refresh}
                                                   :heads [[:k
                                                            "<cmd>silent! bprevious<CR>"
                                                            {:desc :prev}]
                                                           [:j
                                                            "<cmd>silent! bnext<CR>"
                                                            {:desc :next}]
                                                           [:q
                                                            nil
                                                            {:exit true}]]})
                                              (: :activate)))
                                     :mode :n
                                     :desc "Goto next buffer"}
                                    {1 :<leader>k
                                     2 #(let [hy (require :hydra)
                                              lualine (require :lualine)
                                              l_refresh #(lualine.refresh {:scope :tabpage
                                                                           :place [:tabline
                                                                                   :statusline
                                                                                   :winbar]})]
                                          (-> (hy {:name "Switch buffers"
                                                   :config {:hint false
                                                            :timeout 300
                                                            :on_enter #(do
                                                                         (vim.cmd "silent! bprevious")
                                                                         (l_refresh))
                                                            :on_key l_refresh}
                                                   :heads [[:k
                                                            "<cmd>silent! bprevious<CR>"
                                                            {:desc :prev}]
                                                           [:j
                                                            "<cmd>silent! bnext<CR>"
                                                            {:desc :next}]
                                                           [:q
                                                            nil
                                                            {:exit true}]]})
                                              (: :activate)))
                                     :mode :n
                                     :desc "Goto prev buffer"}
                                    ; {1 :<leader>ts
                                    ;  2 #(let [hy (require :hydra)]
                                    ;       (-> (hy {:name :Spell
                                    ;                :hint ts_hint
                                    ;                :config {:invoke_on_body true
                                    ;                         :hint {:float_opts {:style :minimal}
                                    ;                                :position :middle
                                    ;                                :funcs {:spell #(if vim.wo.spell
                                    ;                                                    "[x]"
                                    ;                                                    "[ ]")
                                    ;                                        :en_us #(if (= vim.bo.spelllang
                                    ;                                                       :en_us)
                                    ;                                                    "[x]"
                                    ;                                                    "[ ]")
                                    ;                                        :ru_ru #(if (= vim.bo.spelllang
                                    ;                                                       :ru_ru)
                                    ;                                                    "[x]"
                                    ;                                                    "[ ]")}}}
                                    ;                :mode :n
                                    ;                :body :<leader>ts
                                    ;                :heads [[:s
                                    ;                         #(let [sw (require :spellwarn)]
                                    ;                            (sw.disable)
                                    ;                            (set vim.wo.spell (not vim.wo.spell)))
                                    ;                         {:desc :toggle :exit true}]
                                    ;                        [:e
                                    ;                         #(let [sw (require :spellwarn)]
                                    ;                            (sw.enable)
                                    ;                            (set vim.o.spell true)
                                    ;                            (set vim.bo.spelllang :en_us)
                                    ;                            (set vim.bo.spellfile
                                    ;                                 (.. conf.notes_dir
                                    ;                                     :/dict-en.utf-8.add)))
                                    ;                         {:exit true}]
                                    ;                        [:r
                                    ;                         #(let [sw (require :spellwarn)]
                                    ;                            (sw.enable)
                                    ;                            (set vim.o.spell true)
                                    ;                            (set vim.bo.spelllang :ru_ru)
                                    ;                            (set vim.bo.spellfile
                                    ;                                 (.. conf.notes_dir
                                    ;                                     :/dict-ru.utf-8.add)))
                                    ;                         {:exit true}]
                                    ;                        [:q nil {:exit true}]]})
                                    ;           (: :activate)))
                                    ;  :mode :n
                                    ;  :desc "Toggle spell check"}
                                    ]})
